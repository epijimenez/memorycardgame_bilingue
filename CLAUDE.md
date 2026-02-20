# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

This is a pure Xcode project — there is no Package.swift, no SPM dependencies, and no test targets. Build and run via Xcode or `xcodebuild`:

```bash
# Build for simulator
xcodebuild -project MemoryCardGame.xcodeproj -scheme MemoryCardGame -destination 'platform=iOS Simulator,name=iPhone 15' build

# Build for device
xcodebuild -project MemoryCardGame.xcodeproj -scheme MemoryCardGame -destination 'generic/platform=iOS' build
```

There are no lint tools or test targets configured. SwiftUI Previews are enabled (`ENABLE_PREVIEWS = YES`) and `ContentView` has a `#Preview` block.

## Target & Deployment

- **iOS 17.0** minimum deployment target (`IPHONEOS_DEPLOYMENT_TARGET = 17.0`)
- **Swift 5**, SwiftUI-only (no UIKit views, but UIKit used for `UIImpactFeedbackGenerator`)
- **iPhone + iPad** (`TARGETED_DEVICE_FAMILY = "1,2"`); portrait-only on iPhone, all orientations on iPad
- No Mac Catalyst (`SUPPORTS_MACCATALYST = NO`)
- Bundle ID: `com.memorycardgame.app`

## Architecture

The app follows a lightweight MVVM pattern with a state-machine game flow.

### State machine
`GameViewModel` drives everything through `GameState`:
```
.start → .preview (5 s, all cards face-up) → .playing → .finished
```
`ContentView` switches between three screens based on `gameState`. Restarting always calls `vm.startGame()`.

### Data flow
- `Card.swift` — pure data: `Card` (Identifiable, Equatable), `EmojiItem` (Codable), `GameConstants` enum, and the global `emojiPool` array (25 items).
- `GameViewModel.swift` — `@MainActor ObservableObject`; owns all mutable state (`@Published cards`, `gameState`, `elapsedTime`). Uses two `Task` properties (`previewTask`, `timerTask`) with explicit cancellation checks. `AVSpeechSynthesizer` and `UIImpactFeedbackGenerator` are lazy optionals initialized on first use and cleaned up in `deinit`.
- `CardView.swift` — stateless; receives a `Card` value and an `async` tap closure. The 3D flip is a `rotation3DEffect` on the Y-axis at the `ZStack` level; the back-face "?" has a counter-rotation to prevent mirroring.
- `ContentView.swift` — layout only; uses `GeometryReader` to compute fixed-width `GridItem` columns so all 16 cards fill the available width precisely.

### Key conventions
- All async work uses `Task` + `Task.sleep(for: Duration)` — no `Timer`, no `DispatchQueue.asyncAfter`.
- Card identity uses `UUID`; `ForEach` iterates by `vm.cards.indices` (not `Array(enumerated())`).
- All magic numbers live in `GameConstants` — add new constants there, not inline.
- Card text uses `Color(white: 0.3)` (fixed dark gray) — do **not** use `.primary` or adaptive colors for card face text, as cards have a white background that doesn't adapt to Dark Mode.
- Match detection: two cards match when their `emoji` strings are equal (one card has `isSpanish: false`, the other `isSpanish: true`).
