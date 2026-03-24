import SwiftUI

struct ProfileView: View {
    let userName: String
    let score: Int?

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)

            Text(userName)
                .font(.title.bold())

            Text("スコア: \(score ?? 0)")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ProfileView(userName: "Test User", score: 42)
}
