import SwiftUI

struct PhoneNumberView: View {
    // サンプルの連絡先データ
    let contacts = [
        "田中太郎",
        "佐藤花子",
        "鈴木一郎",
        "高橋美咲",
        "伊藤健太",
        "渡辺さくら",
        "山本直樹",
        "中村優子",
        "小林大輔",
        "加藤愛"
    ]
    
    // 検索テキストを保持する状態変数
    @State private var searchText = ""
    
    // 検索結果（フィルタリングされた配列）
    var filteredContacts: [String] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { $0.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredContacts, id: \.self) { contact in
                HStack(spacing: 12) {
                    // Person Icon
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.gray)
                    // Right Name
                    Text(contact)
                        .font(.body)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("連絡先")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "連絡先を検索")
        }
    }
}

#Preview {
    PhoneNumberView()
}
