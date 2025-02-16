import Foundation

protocol ActionType: Identifiable, Hashable, CaseIterable, RawRepresentable where RawValue == Int {
    var id: Int { get }
    var displayText: String { get }
}

extension ActionType {
    var id: Int {
        return rawValue
    }
}
