import Foundation

protocol GitStateRepresentable {
    associatedtype Value

    var gitState: GitState<Value> { get }
}

extension GitState: GitStateRepresentable {
    var gitState: GitState<Value> {
        self
    }
}

extension GitStateRepresentable {
    var isLoading: Bool {
        gitState.isLoading
    }

    var message: String? {
        gitState.message
    }

    var value: Value? {
        gitState.value
    }
}
