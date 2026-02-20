import SwiftUI

struct CardView: View {
    let card: Card
    let onTap: () async -> Void

    var body: some View {
        ZStack {
            if card.isFaceUp || card.isMatched {
                // Front face
                RoundedRectangle(cornerRadius: GameConstants.cardCornerRadius)
                    .fill(card.isMatched ? Color.green.opacity(0.2) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: GameConstants.cardCornerRadius)
                            .stroke(card.isMatched ? Color.green : Color.gray.opacity(0.4), lineWidth: 2)
                    )
                    .overlay(
                        VStack(spacing: 4) {
                            Text(card.emoji)
                                .font(.system(size: 36))
                            Text(card.displayName)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(GameConstants.cardTextColor)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.7)
                                .padding(.horizontal, 4)
                        }
                    )
            } else {
                // Back face
                RoundedRectangle(cornerRadius: GameConstants.cardCornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: GameConstants.cardCornerRadius)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .overlay(
                        Text("?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white.opacity(0.7))
                            .rotation3DEffect(
                                .degrees(180),
                                axis: (x: 0, y: 1, z: 0)
                            )
                    )
            }
        }
        .rotation3DEffect(
            .degrees(card.isFaceUp || card.isMatched ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        .aspectRatio(GameConstants.cardAspectRatio, contentMode: .fit)
        .shadow(color: .black.opacity(0.1), radius: 3, y: 2)
        .onTapGesture {
            Task { await onTap() }
        }
    }
}
