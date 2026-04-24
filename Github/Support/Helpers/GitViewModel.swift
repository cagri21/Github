import Combine
import Foundation

@MainActor
class GitViewModel<State>: ObservableObject {
    @Published private(set) var state: State

    var task: Task<Void, Never>? {
        didSet {
            oldValue?.cancel()
        }
    }

    init(
        initialState: State
    ) {
        state = initialState
    }

    deinit {
        task?.cancel()
    }

    func setState(
        _ newState: State
    ) {
        state = newState
    }
}
