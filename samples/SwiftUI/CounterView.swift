import SwiftUI

/// シンプルなカウンターのサンプル
struct CounterView: View {
    // ❌ @State に private がない（data.md 違反）
    @State var count = 0

    var body: some View {
        VStack(spacing: 24) {
            // ❌ 固定フォントサイズ（accessibility.md 違反: Dynamic Type を使うべき）
            Text("\(count)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
                .animation(.spring, value: count)
                // ❌ foregroundColor（api.md 違反: foregroundStyle() を使うべき）
                .foregroundColor(.primary)

            HStack(spacing: 16) {
                // ❌ onTapGesture でタップ処理（accessibility.md 違反: Button を使うべき）
                Text("－")
                    .font(.title2)
                    .padding()
                    .background(.red.opacity(0.2))
                    .clipShape(Circle())
                    .onTapGesture {
                        count -= 1
                    }

                // ❌ Binding(get:set:) を view body 内で生成（data.md 違反）
                TextField("count", value: Binding(
                    get: { count },
                    set: { count = $0 }
                ), format: .number)
                .multilineTextAlignment(.center)
                .frame(width: 80)

                // ❌ onTapGesture でタップ処理（accessibility.md 違反: Button を使うべき）
                Text("＋")
                    .font(.title2)
                    .padding()
                    .background(.blue.opacity(0.2))
                    .clipShape(Circle())
                    .onTapGesture {
                        count += 1
                    }
            }

            Button {
                count = 0
            } label: {
                Text("リセット")
                    .font(.title2)
            }
            .buttonStyle(.bordered)
            .tint(.gray)
            .disabled(count == 0)
        }
        .padding()
        .navigationTitle("カウンター")
    }
}

#Preview {
    NavigationStack {
        CounterView()
    }
}
