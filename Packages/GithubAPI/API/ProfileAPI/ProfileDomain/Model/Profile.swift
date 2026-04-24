import Foundation

public struct Profile: Codable, Equatable {
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
