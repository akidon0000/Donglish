import SwiftUI

/// シンプルなカウンターのサンプル
/// swift-swiftui スキルのレビュー観点を実践したコード例
struct CounterView: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 24) {
            Text("\(count)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
                .animation(.spring, value: count)

            HStack(spacing: 16) {
                Button {
                    count -= 1
                } label: {
                    Label("減らす", systemImage: "minus.circle.fill")
                        .font(.title2)
                }
                .buttonStyle(.bordered)
                .tint(.red)

                Button {
                    count = 0
                } label: {
                    Text("リセット")
                        .font(.title2)
                }
                .buttonStyle(.bordered)
                .tint(.gray)
                .disabled(count == 0)

                Button {
                    count += 1
                } label: {
                    Label("増やす", systemImage: "plus.circle.fill")
                        .font(.title2)
                }
                .buttonStyle(.bordered)
                .tint(.blue)
            }
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
