import SwiftUI
import os

// API通信学習用のソースコード
// GitHub APIから情報を取得
private let logger = Logger(subsystem: "com.loveswiftui", category: "GitHubSearch")

// GitHubユーザーモデル
struct GitHubUser: Identifiable, Codable {
    let id: Int
    let login: String
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
    }
}

// GitHub検索レスポンス
struct GitHubSearchResponse: Codable {
    let items: [GitHubUser]
}

// 状態管理（@Observableマクロを使用）
@Observable
class GitHubSearchViewModel {
    var searchText = ""
    var users: [GitHubUser] = []
    var isLoading = false
    var errorMessage: String?

    @MainActor
    func searchUsers() async {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else {
            logger.notice("検索クエリが空です")
            users = []
            return
        }

        logger.notice("🔍 検索開始: \(query)")
        isLoading = true
        errorMessage = nil

        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.github.com/search/users?q=\(encodedQuery)") else {
            logger.error("❌ 無効なURL")
            errorMessage = "無効なURLです"
            isLoading = false
            return
        }

        logger.notice("📡 リクエストURL: \(url.absoluteString)")

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            if let httpResponse = response as? HTTPURLResponse {
                logger.notice("📥 HTTPステータス: \(httpResponse.statusCode)")
            }

            logger.notice("📦 レスポンスデータサイズ: \(data.count) bytes")

            let decoded = try JSONDecoder().decode(GitHubSearchResponse.self, from: data)
            logger.notice("✅ ユーザー数: \(decoded.items.count)件")
            users = decoded.items
        } catch {
            logger.error("❌ エラー: \(error.localizedDescription)")
            errorMessage = "検索に失敗しました: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

struct GitHubSeachView: View {
    @State private var viewModel = GitHubSearchViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 検索バー
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    TextField("ユーザーを検索", text: $viewModel.searchText)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onSubmit {
                            Task {
                                await viewModel.searchUsers()
                            }
                        }

                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
                            viewModel.users = []
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }

                    // 検索ボタン
                    Button {
                        Task {
                            await viewModel.searchUsers()
                        }
                    } label: {
                        Text("検索")
                            .fontWeight(.medium)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()

                // コンテンツ
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("検索中...")
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)
                        Text(error)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                } else if viewModel.users.isEmpty && !viewModel.searchText.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "person.slash")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("ユーザーが見つかりません")
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                } else if viewModel.users.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("GitHubユーザーを検索してください")
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                } else {
                    // ユーザーリスト
                    List(viewModel.users) { user in
                        GitHubUserRow(user: user)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("GitHub Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// ユーザー行コンポーネント
struct GitHubUserRow: View {
    let user: GitHubUser

    var body: some View {
        HStack(spacing: 12) {
            // ユーザー画像
            AsyncImage(url: URL(string: user.avatarUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)
                @unknown default:
                    EmptyView()
                }
            }

            // ユーザー名
            Text(user.login)
                .font(.headline)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    GitHubSeachView()
}
