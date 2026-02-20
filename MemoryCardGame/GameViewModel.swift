import Foundation
import SwiftUI
import AVFoundation

enum GameState {
    case start
    case preview
    case playing
    case finished
}

@MainActor
class GameViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var gameState: GameState = .start
    @Published var elapsedTime: TimeInterval = 0

    private var firstSelectedIndex: Int? = nil
    private var isProcessing = false
    private var timerTask: Task<Void, Never>?
    private var startTime: Date?
    private var previewTask: Task<Void, Never>?
    private var synthesizer: AVSpeechSynthesizer?
    private var feedbackGenerator: UIImpactFeedbackGenerator?

    let columns = 4
    let rows = 4
    var pairCount: Int { (columns * rows) / 2 }
    
    deinit {
        previewTask?.cancel()
        timerTask?.cancel()
        
        // Safely stop speech on main thread if needed
        if let synth = synthesizer, synth.isSpeaking {
            synth.stopSpeaking(at: .immediate)
        }
        synthesizer = nil
        feedbackGenerator = nil
    }

    // MARK: - Game Flow

    func startGame() {
        previewTask?.cancel()
        stopTimer()
        buildCards()
        gameState = .preview
        elapsedTime = 0
        firstSelectedIndex = nil
        isProcessing = false

        // Show all cards face-up for 5 seconds, then flip them down
        previewTask = Task {
            try? await Task.sleep(for: GameConstants.previewDuration)
            guard !Task.isCancelled else { return }
            withAnimation(.easeInOut(duration: GameConstants.flipAnimationDuration)) {
                for i in self.cards.indices {
                    self.cards[i].isFaceUp = false
                }
            }
            self.gameState = .playing
            self.startTimer()
        }
    }

    func selectCard(at index: Int) async {
        guard gameState == .playing,
              !isProcessing,
              !cards[index].isFaceUp,
              !cards[index].isMatched else { return }

        // Initialize feedback generator lazily and prepare it
        if feedbackGenerator == nil {
            feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator?.prepare()
        }
        feedbackGenerator?.impactOccurred()
        
        withAnimation(.easeInOut(duration: GameConstants.flipAnimationDuration)) {
            cards[index].isFaceUp = true
        }

        speak(cards[index].displayName, isSpanish: cards[index].isSpanish)

        if let firstIndex = firstSelectedIndex {
            // Second card selected
            isProcessing = true
            firstSelectedIndex = nil

            let isMatch = cards[firstIndex].emoji == cards[index].emoji

            try? await Task.sleep(for: GameConstants.matchCheckDelay)
            
            if isMatch {
                withAnimation(.easeInOut(duration: GameConstants.flipAnimationDuration)) {
                    cards[firstIndex].isMatched = true
                    cards[index].isMatched = true
                }
                checkForWin()
            } else {
                withAnimation(.easeInOut(duration: GameConstants.flipAnimationDuration)) {
                    cards[firstIndex].isFaceUp = false
                    cards[index].isFaceUp = false
                }
            }
            isProcessing = false
        } else {
            // First card selected
            firstSelectedIndex = index
        }
    }

    // MARK: - Speech

    private func speak(_ text: String, isSpanish: Bool) {
        if synthesizer == nil {
            synthesizer = AVSpeechSynthesizer()
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: isSpanish ? "es-MX" : "en-US")
        utterance.rate = GameConstants.speechRate
        synthesizer?.stopSpeaking(at: .immediate)
        synthesizer?.speak(utterance)
    }

    // MARK: - Helpers

    private func buildCards() {
        let selected = Array(emojiPool.shuffled().prefix(pairCount))
        var newCards: [Card] = []
        for item in selected {
            newCards.append(Card(emoji: item.emoji, englishName: item.english,
                                spanishName: item.spanish, isSpanish: false, isFaceUp: true))
            newCards.append(Card(emoji: item.emoji, englishName: item.english,
                                spanishName: item.spanish, isSpanish: true, isFaceUp: true))
        }
        cards = newCards.shuffled()
    }

    private func startTimer() {
        timerTask?.cancel()
        startTime = Date()
        timerTask = Task { @MainActor in
            while !Task.isCancelled, gameState == .playing {
                try? await Task.sleep(for: GameConstants.timerUpdateInterval)
                guard let start = startTime else { return }
                elapsedTime = Date().timeIntervalSince(start)
            }
        }
    }

    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    private func checkForWin() {
        if cards.allSatisfy({ $0.isMatched }) {
            stopTimer()
            // Small delay so the last match animation completes
            Task {
                try? await Task.sleep(for: .milliseconds(500))
                gameState = .finished
            }
        }
    }

    var formattedTime: String {
        let total = Int(elapsedTime)
        let minutes = total / 60
        let seconds = total % 60
        let tenths = Int((elapsedTime - Double(total)) * 10)
        return String(format: "%d:%02d.%d", minutes, seconds, tenths)
    }
}
