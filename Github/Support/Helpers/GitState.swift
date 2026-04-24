import Foundation

enum GitState<Value> {
    case idle(message: String)
    case loading
    case empty(message: String)
    case error(message: String)
    case data(Value)
}

extension GitState: Equatable where Value: Equatable {}

extension GitState {
    var isLoading: Bool {
        if case .loading = self {
            return true
        }

        return false
    }

    var value: Value? {
        guard case let .data(value) = self else {
            return nil
        }

        return value
    }

    var message: String? {
        switch self {
        case let .idle(message), let .empty(message), let .error(message):
            return message
        case .loading, .data:
            return nil
        }
    }
}
