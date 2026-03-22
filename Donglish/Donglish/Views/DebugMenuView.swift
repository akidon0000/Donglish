import SwiftUI
import SwiftData

#if DEBUG
struct DebugMenuView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var questions: [Question]
    @Query private var sessions: [DrillSession]

    var body: some View {
        NavigationStack {
            List {
                Section("画面") {
                    NavigationLink("通勤モード (ContentView)") {
                        ContentView()
                    }
                    NavigationLink("ドリル実行中 (DrillActiveView)") {
                        drillActivePreview
                    }
                    NavigationLink("セッションサマリー (SessionSummaryView)") {
                        sessionSummaryPreview
                    }
                }

                Section("サービス") {
                    NavigationLink("TTS テスト") {
                        TTSTestView()
                    }
                    NavigationLink("AirPods 検出") {
                        AirPodsTestView()
                    }
                    NavigationLink("首振りジェスチャー") {
                        HeadGestureTestView()
                    }
                }

                Section("データ") {
                    NavigationLink("Question 一覧 (\(questions.count)件)") {
                        QuestionListDebugView()
                    }
                    NavigationLink("Session 一覧 (\(sessions.count)件)") {
                        SessionListDebugView()
                    }
                    Button("サンプルデータ再投入") {
                        SampleDataSeeder.seedIfNeeded(modelContext: modelContext)
                    }
                    Button("全データ削除", role: .destructive) {
                        deleteAllData()
                    }
                }
            }
            .navigationTitle("Debug Menu")
        }
    }

    private var drillActivePreview: some View {
        let flow = DrillFlow()
        return DrillActiveView(drillFlow: flow)
    }

    private var sessionSummaryPreview: some View {
        let flow = DrillFlow()
        return SessionSummaryView(drillFlow: flow)
    }

    private func deleteAllData() {
        try? modelContext.delete(model: SessionAnswer.self)
        try? modelContext.delete(model: DrillSession.self)
        try? modelContext.delete(model: Question.self)
        try? modelContext.save()
    }
}

// MARK: - TTS テスト

private struct TTSTestView: View {
    @State private var tts = TTSService()
    @State private var inputText = "Hello, this is a test."

    var body: some View {
        List {
            Section("カスタムテキスト") {
                TextField("テキスト", text: $inputText)
                Button("英語で再生") {
                    Task { await tts.speak(inputText, language: "en-US") }
                }
                Button("日本語で再生") {
                    Task { await tts.speak("これはテストです", language: "ja-JP") }
                }
                Button("停止") { tts.stop() }
            }

            Section("DrillPrompt") {
                Button("didYouUnderstand") {
                    Task { await tts.speakPrompt(.didYouUnderstand) }
                }
                Button("goodMorning") {
                    Task { await tts.speakPrompt(.goodMorning) }
                }
                Button("goodEvening") {
                    Task { await tts.speakPrompt(.goodEvening) }
                }
                Button("nodReminder") {
                    Task { await tts.speakPrompt(.nodReminder) }
                }
                Button("sessionComplete(5, 3, 2)") {
                    Task { await tts.speakPrompt(.sessionComplete(total: 5, understood: 3, review: 2)) }
                }
            }
        }
        .navigationTitle("TTS テスト")
    }
}

// MARK: - AirPods テスト

private struct AirPodsTestView: View {
    var body: some View {
        List {
            Section("接続状態") {
                LabeledContent("AirPods Pro 接続") {
                    Text(AirPodsDetector.isAirPodsProConnected() ? "✅ 接続中" : "❌ 未接続")
                }
                LabeledContent("Head Tracking 対応") {
                    Text(AirPodsDetector.supportsHeadTracking() ? "✅ 対応" : "❌ 非対応")
                }
            }
            Button("再チェック") {}
                .disabled(true)
        }
        .navigationTitle("AirPods 検出")
    }
}

// MARK: - Head Gesture テスト

private struct HeadGestureTestView: View {
    @State private var service = HeadGestureService()
    @State private var lastGesture = "未検出"
    @State private var isDetecting = false

    var body: some View {
        List {
            Section("状態") {
                LabeledContent("利用可能") {
                    Text(service.isAvailable ? "✅" : "❌")
                }
                LabeledContent("検出中") {
                    Text(isDetecting ? "🟢" : "⚪️")
                }
                LabeledContent("最後のジェスチャー") {
                    Text(lastGesture)
                }
            }

            Section("操作") {
                Button("検出開始") {
                    service.startDetection { gesture in
                        lastGesture = "\(gesture) (\(Date().formatted(date: .omitted, time: .standard)))"
                    }
                    isDetecting = true
                }
                .disabled(isDetecting)

                Button("検出停止") {
                    service.stopDetection()
                    isDetecting = false
                }
                .disabled(!isDetecting)
            }
        }
        .navigationTitle("首振りジェスチャー")
        .onDisappear { service.stopDetection() }
    }
}

// MARK: - Question 一覧

private struct QuestionListDebugView: View {
    @Query(sort: \Question.level) private var questions: [Question]

    var body: some View {
        List(questions) { question in
            VStack(alignment: .leading, spacing: 4) {
                Text(question.englishText)
                    .font(.headline)
                HStack {
                    Text("Lv.\(question.level)")
                    Text("状態: \(question.statusRawValue)")
                    Text("難易度: \(question.difficultyScore)")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                if let nextReview = question.nextReviewDate {
                    Text("次回復習: \(nextReview.formatted())")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .navigationTitle("Questions")
    }
}

// MARK: - Session 一覧

private struct SessionListDebugView: View {
    @Query(sort: \DrillSession.sessionDate, order: .reverse) private var sessions: [DrillSession]

    var body: some View {
        List(sessions) { session in
            VStack(alignment: .leading, spacing: 4) {
                Text(session.sessionDate.formatted())
                    .font(.headline)
                HStack {
                    Text("種別: \(session.sessionType)")
                    Text("計: \(session.totalQuestions)")
                    Text("Yes: \(session.yesCount)")
                    Text("No: \(session.noCount)")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Sessions")
    }
}
#endif
