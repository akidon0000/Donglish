import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
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
            .navigationTitle("認実")
        }
    }

    private var levelSection: some View {
        Section("Recent") {
            Picker("現在のレベル", selection: $selectedLevel) {
                ForEach(1...5, id: \.self) { level in
                    Text("レベル \(level)").tag(level)
                }
            }

            Stepper("1日の碗�: \(dailyGoal)啎", value: $dailyGoal, in: 1...50)
        }
    }

    private var statsSection: some View {
        Section("学界竬法") {
            // 🚻 MUST FIX: 動刺アンラップ