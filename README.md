# LoveSwiftUI
SwiftUIの学習帳

* 学習内容
* Arrayの操作と動的なUIの構築
* REST APIとの通信

## X like UI

```swift
import SwiftUI

struct PhoneNumberView: View {
    // サンプルの連絡先データ
    let contacts = [
        Contact(username: "jboy", displayName: "J Boy", bio: "iOS Developer 📱"),
        Contact(username: "adachin", displayName: "Adachi", bio: "Designer & Creator ✨"),
        Contact(username: "icchy", displayName: "Icchy", bio: "Tech Enthusiast 💻"),
        Contact(username: "nakayan", displayName: "Nakayan", bio: "Full Stack Engineer 🚀"),
        Contact(username: "yamaken", displayName: "Yamaken", bio: "Product Manager 📊")
    ]
    // keyword search
    @State private var searchText: String = ""
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter {
                $0.username.contains(searchText) || $0.displayName.contains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredContacts) { contact in
                        XStyleUserRow(contact: contact)
                        Divider()
                            .padding(.leading, 70)
                    }
                }
            }
            .navigationTitle("Connect")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Settings action
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }
}

// X風のユーザー情報構造体
struct Contact: Identifiable {
    let id = UUID()
    let username: String
    let displayName: String
    let bio: String
}

// X風のユーザー行
struct XStyleUserRow: View {
    let contact: Contact
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // プロフィール画像（円形）
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundStyle(.gray)
                )
            
            // ユーザー情報
            VStack(alignment: .leading, spacing: 2) {
                // 表示名
                Text(contact.displayName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.primary)
                
                // ユーザー名
                Text("@\(contact.username)")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                
                // 自己紹介
                Text(contact.bio)
                    .font(.system(size: 15))
                    .foregroundStyle(.primary)
                    .padding(.top, 4)
            }
            
            Spacer()
            
            // フォローボタン
            Button {
                // Follow action
            } label: {
                Text("Follow")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black)
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

#Preview {
    PhoneNumberView()
}
#Preview {
    PhoneNumberView()
}
```

## Loggerのログレベル

os.Loggerのログレベル（表示されやすい順）:
error - 常に表示
fault - 常に表示
notice - デフォルトで表示 ✅
info - デフォルトで表示
debug - デフォルトで非表示