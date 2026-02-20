# Memory Match — English ↔ Español

A bilingual memory card game for iPhone and iPad. Flip cards to find matching pairs, where each pair shows the same item in both English and Spanish.

## How to Play

1. Choose a mode — **START** (normal) or **⚡ Andy's Mode** (faster).
2. All 16 cards are revealed face-up during a preview period. Memorize their positions.
3. Cards flip back over. The timer starts.
4. Tap any card to flip it. Then tap a second card:
   - **Match** — both cards instantly stay face-up and turn green.
   - **No match** — both cards flip back over after a brief pause.
5. Find all 8 pairs to win. Your completion time is displayed on the finish screen.
6. Tap **Play Again** (or the refresh button during a game) to start a new round with a reshuffled board.

Each card speaks its label aloud when tapped — English cards in an American English voice, Spanish cards in a Mexican Spanish voice.

## Gameplay Details

- **Board:** 4×4 grid, 16 cards, 8 matching pairs
- **Modes:** Normal (5 s preview, 800 ms mismatch pause) · ⚡ Andy's Mode (2 s preview, 300 ms mismatch pause)
- **Matching:** Matched pairs resolve instantly with no delay. Mismatched cards pause briefly before flipping back.
- **Card labels:** One card in each pair shows the English name; the other shows the Spanish name. They share the same emoji.
- **Timer:** Counts up in tenths of a second from when gameplay starts
- **Haptics:** Light tap feedback on every card flip (iOS only)

## Requirements

- iOS 17.0 or later
- iPhone or iPad
- Xcode 15.2+ to build from source

## Building

Open `MemoryCardGame.xcodeproj` in Xcode, select a simulator or connected device, and press **Run** (⌘R).

## Web Version

A standalone web port of the game lives in `WebApp/index.html`. It is a single self-contained HTML file (no build step, no dependencies) that replicates all game mechanics — card flipping, bilingual speech via the Web Speech API, timer, and match detection. It is **not used by the Xcode project** and is not referenced anywhere in the iOS build; it exists solely for embedding in a website (e.g., pasting into a WordPress Custom HTML block).

## Acknowledgements

This game was fully generated with AI — built using [Claude Code](https://claude.ai/code) by Anthropic.
