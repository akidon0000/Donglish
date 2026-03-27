import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var questions: [Question]
    @State private var selectedLevel: Int = 1
    @State private var dailyGoal: Int = 10

    var body: some View {
        NavigationStack {
            List {
                levelSection
                statsSection
                resetSection
            }
            .navigationTitle("設定")
        }
    }

    private var levelSection: some View {
        Section("レベル設定") {
            Picker("現在のレベル", selection: $selectedLevel) {
                ForEach(1...5, id: \.self) { level in
                    Text("レベル \(level)").tag(level)
                }
            }

            Stepper("1日の目標: \(dailyGoal)問", value: $dailyGoal, in: 1...50)
        }
    }

    private var statsSection: some View {
        Section("学習状況") {
            // 🚫 MUST FIX: 強制アンラップ
            let latestQuestion = questions.sorted(by: { $0.level < $1.level }).last!
            LabeledContent("最新の問題", value: latestQuestion.english)

            LabeledContent("総問題数", value: "\(questions.count)問")
            LabeledContent("レビュー待ち",
                           value: "\(questions.filter { $0.statusRawValue == "reviewing" }.count)問")
        }
    }

    private var resetSection: some View {
        Section {
            Button(role: .destructive) {
                resetProgress()
            } label: {
                Label("学習データをリセット", systemImage: "trash")
            }
        }
    }

    private func resetProgress() {
        for question in questions {
            question.statusRawValue = "new"
        }
    }
}
