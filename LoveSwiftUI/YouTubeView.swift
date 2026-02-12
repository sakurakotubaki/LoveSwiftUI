import SwiftUI

// 動画データモデル
struct VideoItem: Identifiable {
    let id = UUID()
    let thumbnail: String
    let title: String
    let channelName: String
    let views: String
    let uploadTime: String
}

struct YouTubeView: View {
    @State private var selectedTab = 0
    @State private var searchText = ""
    
    // サンプルデータ
    let videos = [
        VideoItem(thumbnail: "video.fill", title: "SwiftUIの基礎を学ぼう", channelName: "プログラミングチャンネル", views: "12万回視聴", uploadTime: "3日前"),
        VideoItem(thumbnail: "play.rectangle.fill", title: "初心者向けiOSアプリ開発講座", channelName: "開発者TV", views: "5.2万回視聴", uploadTime: "1週間前"),
        VideoItem(thumbnail: "video.fill", title: "Xcodeの使い方完全ガイド", channelName: "テックチュートリアル", views: "8.7万回視聴", uploadTime: "2日前"),
        VideoItem(thumbnail: "play.rectangle.fill", title: "モダンなUIデザインの作り方", channelName: "デザインスタジオ", views: "3.4万回視聴", uploadTime: "5日前"),
        VideoItem(thumbnail: "video.fill", title: "Swift言語の新機能解説", channelName: "コーディング研究所", views: "15万回視聴", uploadTime: "4日前"),
        VideoItem(thumbnail: "play.rectangle.fill", title: "実践的なアプリ開発テクニック", channelName: "プロ開発者", views: "6.8万回視聴", uploadTime: "1週間前"),
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // ヘッダー
                HStack {
                    // YouTubeロゴ
                    HStack(spacing: 4) {
                        Image(systemName: "play.rectangle.fill")
                            .font(.title2)
                            .foregroundStyle(.red)
                        Text("YouTube")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    // アイコンボタン
                    HStack(spacing: 20) {
                        Button {
                            // 通知機能
                        } label: {
                            Image(systemName: "bell")
                                .font(.title3)
                                .foregroundStyle(.primary)
                        }
                        
                        Button {
                            // 検索機能
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.title3)
                                .foregroundStyle(.primary)
                        }
                        
                        Button {
                            // プロフィール
                        } label: {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                
                // カテゴリータブ
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryButton(title: "すべて", isSelected: true)
                        CategoryButton(title: "音楽", isSelected: false)
                        CategoryButton(title: "ゲーム", isSelected: false)
                        CategoryButton(title: "ニュース", isSelected: false)
                        CategoryButton(title: "料理", isSelected: false)
                        CategoryButton(title: "スポーツ", isSelected: false)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color(uiColor: .systemBackground))
                
                Divider()
                
                // 動画リスト
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(videos) { video in
                            VideoCard(video: video)
                        }
                    }
                    .padding(.vertical)
                }
                
                // ボトムタブバー
                Divider()
                HStack {
                    TabButton(icon: "house.fill", title: "ホーム", isSelected: true)
                    TabButton(icon: "play.square.stack", title: "Shorts", isSelected: false)
                    TabButton(icon: "plus.circle.fill", title: "", isSelected: false, isLarge: true)
                    TabButton(icon: "rectangle.stack", title: "登録チャンネル", isSelected: false)
                    TabButton(icon: "person.crop.square", title: "ライブラリ", isSelected: false)
                }
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
            }
            .navigationBarHidden(true)
        }
    }
}

// カテゴリーボタン
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(isSelected ? .semibold : .regular)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.primary : Color(uiColor: .secondarySystemBackground))
            .foregroundStyle(isSelected ? Color(uiColor: .systemBackground) : .primary)
            .clipShape(Capsule())
    }
}

// 動画カード
struct VideoCard: View {
    let video: VideoItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // サムネイル
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(16/9, contentMode: .fit)
                
                Image(systemName: video.thumbnail)
                    .font(.system(size: 60))
                    .foregroundStyle(.white.opacity(0.8))
                
                // 再生時間バッジ
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("12:34")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(.black.opacity(0.8))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .padding(8)
                    }
                }
            }
            
            // 動画情報
            HStack(alignment: .top, spacing: 12) {
                // チャンネルアイコン
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(video.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("\(video.channelName) • \(video.views) • \(video.uploadTime)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // メニューボタン
                Button {
                    // メニュー表示
                } label: {
                    Image(systemName: "ellipsis.vertical")
                        .foregroundStyle(.primary)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }
}

// タブバーボタン
struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    var isLarge: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(isLarge ? .title : .title3)
                .foregroundStyle(isLarge ? .red : (isSelected ? .primary : .secondary))
            
            if !title.isEmpty {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    YouTubeView()
}
