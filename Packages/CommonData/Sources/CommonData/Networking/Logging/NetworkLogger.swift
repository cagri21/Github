import Foundation

public protocol NetworkLogger {
    func requestDidStart(_ request: URLRequest)

    func requestDidSucceed(
        _ request: URLRequest,
        response: HTTPURLResponse,
        data: Data,
        duration: TimeInterval
    )

    func requestDidFail(
        _ request: URLRequest?,
        error: Error,
        duration: TimeInterval?
    )

    func requestInterceptionDidFail(
        requestURL: URL,
        error: Error
    )
}
