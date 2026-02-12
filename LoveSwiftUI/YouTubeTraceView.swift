import SwiftUI

// 動画データモデル
//struct VideoItem: Identifiable {
//    let id = UUID()
//    let thumbnail: String
//    let title: String
//    let channelName: String
//    let views: String
//    let uploadTime: String
//}

struct YouTubeTraceView: View {
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
                // Header
                HStack {
                    // YouTubeロゴ
                    HStack(spacing: 4) {
                        Image(systemName: "play.rectangle.fill")
                            .font(.title2)
                            .foregroundStyle(.red)
                        Text("YouTubeTrace")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    // Icon Buttons
                    HStack(spacing: 20) {
                        Button {
                            // Notification
                        } label: {
                            Image(systemName: "bell")
                                .font(.title3)
                                .foregroundStyle(.primary)
                        }
                        
                        Button {
                            // Search
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.title3)
                                .foregroundStyle(.primary)
                        }
                        
                        Button {
                            // Profile
                        } label: {
                            Image(systemName: "person.circle")
                                .font(.title3)
                                .foregroundStyle(.primary)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                
                // Category ScrollView
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
                
                // Video List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(videos) { video in
                            VideoCardView(video: video)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// カテゴリーボタン
//struct CategoryButton: View {
//    let title: String
//    let isSelected: Bool
//    
//    var body: some View {
//        Text(title)
//            .font(.subheadline)
//            .fontWeight(isSelected ? .semibold : .regular)
//            .padding(.horizontal, 16)
//            .padding(.vertical, 8)
//            .background(isSelected ? Color.primary : Color(uiColor: .secondarySystemBackground))
//            .foregroundStyle(isSelected ? Color(uiColor: .systemBackground) : .primary)
//            .clipShape(Capsule())
//    }
//}

// Video Card
struct VideoCardView: View {
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

#Preview {
    YouTubeTraceView()
}
