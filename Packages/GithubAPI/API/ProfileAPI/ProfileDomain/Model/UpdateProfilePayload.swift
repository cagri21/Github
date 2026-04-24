import Foundation

public struct UpdateProfilePayload: Codable, Equatable {
    public let displayName: String
    public let bio: String

    public init(
        displayName: String,
        bio: String
    ) {
        self.displayName = displayName
        self.bio = bio
    }
}
