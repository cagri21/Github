import Foundation

public protocol APIErrorListener {
    func errorOccurred(
        error: Error,
        requestURL: URL
    )
}
