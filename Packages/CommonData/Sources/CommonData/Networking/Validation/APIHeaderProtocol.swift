public protocol APIHeaderProtocol {
    var message: String? { get }
    var messageCode: String? { get }
    var statusCode: Int? { get }
}
