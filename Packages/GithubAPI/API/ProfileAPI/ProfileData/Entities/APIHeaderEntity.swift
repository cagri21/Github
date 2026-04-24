import CommonData
import Foundation

public struct APIHeaderEntity: Decodable, APIHeaderProtocol {
    public let message: String?
    public let messageCode: String?
    public let statusCode: Int?

    public init(
        message: String?,
        messageCode: String?,
        statusCode: Int?
    ) {
        self.message = message
        self.messageCode = messageCode
        self.statusCode = statusCode
    }
}
