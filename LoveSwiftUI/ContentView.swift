import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .topLeading) { // 左上揃えに指定
            Color.clear // 背景

            Image(systemName: "star.fill")
                .padding() // セーフエリアや余白の調整
        }
        .edgesIgnoringSafeArea(.all) // 必要に応じてセーフエリアを無視

    }
}

#Preview {
    ContentView()
}
