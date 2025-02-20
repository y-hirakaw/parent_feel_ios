import SwiftUI

class ActionSelectionViewState<T: ActionType>: ObservableObject {
    @Published var selectedActions: Set<T> = []

    func insert(_ action: T) {
        selectedActions.insert(action)
    }

    func remove(_ action: T) {
        selectedActions.remove(action)
    }

    func toggle(_ action: T) {
        if selectedActions.contains(action) {
            remove(action)
        } else {
            insert(action)
        }
    }

    func contains(_ action: T) -> Bool {
        return selectedActions.contains(action)
    }
}
