import SwiftUI

struct ContentView: View {
    @StateObject private var vm = GameViewModel()

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            switch vm.gameState {
            case .start:
                startScreen
            case .preview, .playing:
                gameScreen
            case .finished:
                finishedScreen
            }
        }
    }

    // MARK: - Start Screen

    private var startScreen: some View {
        VStack(spacing: 24) {
            Text("🧠")
                .font(.system(size: 80))

            Text("Memory Match")
                .font(.system(size: 34, weight: .bold, design: .rounded))

            Text("English ↔ Español")
                .font(.title3)
                .foregroundColor(.secondary)

            VStack(spacing: 12) {
                Button(action: { vm.startGame(andysMode: false) }) {
                    Text("START")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 56)
                        .background(
                            LinearGradient(colors: [.blue, .purple],
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(28)
                }
                Button(action: { vm.startGame(andysMode: true) }) {
                    Text("⚡ Andy's Mode")
                        .font(.title3.weight(.bold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 56)
                        .background(
                            LinearGradient(colors: [Color(red: 1, green: 0.42, blue: 0), .pink],
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(28)
                }
            }
            .padding(.top, 16)
        }
    }

    // MARK: - Game Screen

    private var gameScreen: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                if vm.gameState == .preview {
                    Text("Memorize!")
                        .font(.headline)
                        .foregroundColor(.orange)
                } else {
                    Text("⏱ \(vm.formattedTime)")
                        .font(.system(.title3, design: .monospaced).weight(.semibold))
                }
                if vm.isAndysMode {
                    Text("⚡ Andy's Mode")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.pink)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.pink.opacity(0.1))
                        .cornerRadius(10)
                }
                Spacer()
                Text("Matches: \(vm.cards.filter { $0.isMatched }.count / 2)/\(vm.pairCount)")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.secondary)
                Button {
                    vm.startGame()
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 8)
            }
            .padding(.horizontal)

            // Card Grid
            GeometryReader { geo in
                LazyVGrid(
                    columns: gridColumns(for: geo.size.width),
                    spacing: GameConstants.gridSpacing
                ) {
                    ForEach(vm.cards.indices, id: \.self) { index in
                        CardView(card: vm.cards[index]) {
                            await vm.selectCard(at: index)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Helper Methods
    
    private func gridColumns(for width: CGFloat) -> [GridItem] {
        let totalHSpacing = GameConstants.gridSpacing * CGFloat(vm.columns - 1) + 24
        let cardWidth = (width - totalHSpacing) / CGFloat(vm.columns)
        return Array(repeating: GridItem(.fixed(cardWidth), spacing: GameConstants.gridSpacing), count: vm.columns)
    }

    // MARK: - Finished Screen

    private var finishedScreen: some View {
        VStack(spacing: 20) {
            Text("🎉")
                .font(.system(size: 72))

            Text("You did it!")
                .font(.system(size: 30, weight: .bold, design: .rounded))

            VStack(spacing: 8) {
                Text("Your Time")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(vm.formattedTime)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundStyle(
                        LinearGradient(colors: [.blue, .purple],
                                       startPoint: .leading, endPoint: .trailing)
                    )
            }

            Button(action: { vm.startGame() }) {
                Text("Play Again")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 56)
                    .background(
                        LinearGradient(colors: [.blue, .purple],
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(28)
            }
            .padding(.top, 12)
        }
    }
}

#Preview {
    ContentView()
}
