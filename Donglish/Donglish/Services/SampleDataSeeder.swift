import Foundation
import SwiftData

enum SampleDataSeeder {
    static func seedIfNeeded(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Question>()
        let count = (try? modelContext.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        for question in sampleQuestions {
            modelContext.insert(question)
        }
    }

    private static var sampleQuestions: [Question] {
        [
            Question(
                englishText: "Could you keep me in the loop?",
                japaneseSummary: "状況を共有してほしい",
                paraphrase1: "Can you keep me updated on what's happening?",
                paraphrase2: "Please let me know whenever there's any progress.",
                japaneseExplanation: "「keep someone in the loop」は「情報を共有し続ける」という意味のビジネス表現です。",
                level: 1
            ),
            Question(
                englishText: "Let's circle back to this later.",
                japaneseSummary: "後でこの話に戻ろう",
                paraphrase1: "We can revisit this topic after a while.",
                paraphrase2: "Let's come back to this discussion at a later time.",
                japaneseExplanation: "「circle back」は「後で話題に戻る」というビジネスミーティングでよく使われる表現です。",
                level: 1
            ),
            Question(
                englishText: "I'm running behind schedule today.",
                japaneseSummary: "今日は予定より遅れている",
                paraphrase1: "I'm a bit behind on my tasks for today.",
                paraphrase2: "Things are taking longer than I expected today.",
                japaneseExplanation: "「run behind schedule」は「予定より遅れている」という意味です。通勤中に同僚に連絡する場面で使えます。",
                level: 1
            ),
            Question(
                englishText: "Can we push the meeting to tomorrow?",
                japaneseSummary: "会議を明日に延期できますか",
                paraphrase1: "Would it be possible to reschedule the meeting for tomorrow?",
                paraphrase2: "Can we move tomorrow's meeting to a later date?",
                japaneseExplanation: "「push the meeting」は「会議を後ろにずらす」という意味です。スケジュール調整でよく使います。",
                level: 1
            ),
            Question(
                englishText: "I'll take care of it right away.",
                japaneseSummary: "すぐに対応します",
                paraphrase1: "I'll handle it immediately.",
                paraphrase2: "Consider it done — I'm on it now.",
                japaneseExplanation: "「take care of it」は「対処する・処理する」という意味です。仕事の依頼に応答する際に使います。",
                level: 2
            ),
            Question(
                englishText: "That's a good point, but have you considered the cost?",
                japaneseSummary: "良い指摘だけど、コストは考慮した？",
                paraphrase1: "You raise a fair point. But what about the budget impact?",
                paraphrase2: "I agree it's worth exploring, though we should also think about expenses.",
                japaneseExplanation: "相手の意見を認めつつ、別の観点を提示する丁寧な反論表現です。ミーティングで頻出します。",
                level: 2
            ),
            Question(
                englishText: "I'm not sure I follow. Could you elaborate?",
                japaneseSummary: "よくわからないので詳しく説明してもらえますか",
                paraphrase1: "I didn't quite catch that. Can you explain further?",
                paraphrase2: "Could you go into a bit more detail? I want to make sure I understand.",
                japaneseExplanation: "「I'm not sure I follow」は「話についていけない」という丁寧な聞き返し表現です。",
                level: 2
            ),
            Question(
                englishText: "We need to align on the priorities before moving forward.",
                japaneseSummary: "先に進む前に優先順位を合わせる必要がある",
                paraphrase1: "Let's agree on what's most important before we proceed.",
                paraphrase2: "Before taking next steps, we should make sure we're on the same page about priorities.",
                japaneseExplanation: "「align on」は「認識を合わせる」という意味のビジネス英語です。プロジェクト管理で頻繁に使われます。",
                level: 3
            ),
            Question(
                englishText: "I'll loop in the design team and get their input.",
                japaneseSummary: "デザインチームを巻き込んで意見をもらいます",
                paraphrase1: "I'll bring the design team into the conversation for their feedback.",
                paraphrase2: "Let me check with the design team and gather their thoughts.",
                japaneseExplanation: "「loop in」は「人を議論や情報共有の輪に入れる」という意味です。チーム間連携の場面で使います。",
                level: 3
            ),
            Question(
                englishText: "Let's not boil the ocean — we should start small and iterate.",
                japaneseSummary: "最初から完璧を目指さず、小さく始めて改善しよう",
                paraphrase1: "We don't need to solve everything at once. Let's take it step by step.",
                paraphrase2: "Rather than trying to do everything, let's focus on a small first step and improve from there.",
                japaneseExplanation: "「boil the ocean」は「不可能なほど大きなことをやろうとする」という慣用句です。スコープを絞る提案で使えます。",
                level: 4
            ),
        ]
    }
}
