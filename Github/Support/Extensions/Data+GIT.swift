import Foundation

extension Data {
    var gitHexString: String {
        map { String(format: "%02.2hhx", $0) }
            .joined()
    }
}
