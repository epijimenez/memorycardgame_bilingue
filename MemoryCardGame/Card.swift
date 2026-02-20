import Foundation
import SwiftUI

struct Card: Identifiable, Equatable {
    let id = UUID()
    let emoji: String
    let englishName: String
    let spanishName: String
    let isSpanish: Bool
    var isFaceUp: Bool = false
    var isMatched: Bool = false

    var displayName: String {
        isSpanish ? spanishName : englishName
    }

    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id && 
        lhs.isFaceUp == rhs.isFaceUp && 
        lhs.isMatched == rhs.isMatched
    }
}

struct EmojiItem: Codable {
    let emoji: String
    let english: String
    let spanish: String
}

enum GameConstants {
    static let previewDuration: Duration = .seconds(5)
    static let mismatchDelay: Duration = .milliseconds(800)
    static let flipAnimationDuration: TimeInterval = 0.3
    static let cardCornerRadius: CGFloat = 12
    static let cardAspectRatio: CGFloat = 0.72
    static let timerUpdateInterval: Duration = .milliseconds(100)
    static let gridSpacing: CGFloat = 8
    static let speechRate: Float = 0.5

    // Andy's Mode
    static let andysModePreviewDuration: Duration = .seconds(2)
    static let andysModeMismatchDelay: Duration = .milliseconds(300)

    // Colors
    static let cardTextColor = Color(white: 0.3) // Dark gray - readable in both light and dark mode
}

let emojiPool: [EmojiItem] = [
    EmojiItem(emoji: "🍎", english: "Apple", spanish: "Manzana"),
    EmojiItem(emoji: "🚙", english: "Car", spanish: "Carro"),
    EmojiItem(emoji: "✈️", english: "Airplane", spanish: "Avión"),
    EmojiItem(emoji: "⚾️", english: "Baseball", spanish: "Béisbol"),
    EmojiItem(emoji: "🍪", english: "Cookie", spanish: "Galleta"),
    EmojiItem(emoji: "🥕", english: "Carrot", spanish: "Zanahoria"),
    EmojiItem(emoji: "🥑", english: "Avocado", spanish: "Aguacate"),
    EmojiItem(emoji: "🍓", english: "Strawberry", spanish: "Fresa"),
    EmojiItem(emoji: "🐶", english: "Dog", spanish: "Perro"),
    EmojiItem(emoji: "🦁", english: "Lion", spanish: "León"),
    EmojiItem(emoji: "🐵", english: "Monkey", spanish: "Mono"),
    EmojiItem(emoji: "📱", english: "Phone", spanish: "Teléfono"),
    EmojiItem(emoji: "📸", english: "Camera", spanish: "Cámara"),
    EmojiItem(emoji: "⏰", english: "Clock", spanish: "Reloj"),
    EmojiItem(emoji: "💡", english: "Light Bulb", spanish: "Bombilla"),
    EmojiItem(emoji: "🌮", english: "Taco", spanish: "Taco"),
    EmojiItem(emoji: "🎸", english: "Guitar", spanish: "Guitarra"),
    EmojiItem(emoji: "🏠", english: "House", spanish: "Casa"),
    EmojiItem(emoji: "⭐️", english: "Star", spanish: "Estrella"),
    EmojiItem(emoji: "🌙", english: "Moon", spanish: "Luna"),
    EmojiItem(emoji: "🔑", english: "Key", spanish: "Llave"),
    EmojiItem(emoji: "📚", english: "Books", spanish: "Libros"),
    EmojiItem(emoji: "🎩", english: "Hat", spanish: "Sombrero"),
    EmojiItem(emoji: "🐱", english: "Cat", spanish: "Gato"),
    EmojiItem(emoji: "🍕", english: "Pizza", spanish: "Pizza"),
]
