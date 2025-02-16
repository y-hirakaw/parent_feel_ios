import Foundation

enum Screen: Hashable {
    case home
    case detail(Emotion)
    case input(Emotion?)
}
