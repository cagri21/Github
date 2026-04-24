import Foundation

public enum HTTPMethod<Body> {
    case get([URLQueryItem] = [])
    case post(Body)
    case put(Body)
    case patch(Body)
    case delete
    case head

    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        case .head:
            return "HEAD"
        }
    }
}
