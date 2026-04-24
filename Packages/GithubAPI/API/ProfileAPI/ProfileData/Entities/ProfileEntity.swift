import Foundation

public struct ProfileEnvelopeEntity: Decodable {
    public let header: APIHeaderEntity?
    public let data: ProfileEntity

    public init(
        header: APIHeaderEntity?,
        data: ProfileEntity
    ) {
        self.header = header
        self.data = data
    }
}

public struct ProfileEntity: Decodable {
    public let id: Int
    public let username: String
    public let displayName: String?
    public let bio: String?

    public init(
        id: Int,
        username: String,
        displayName: String?,
        bio: String?
    ) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.bio = bio
    }
}
