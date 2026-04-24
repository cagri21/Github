import Foundation

public struct GithubUserProfileEntity: Decodable {
    let avatarURL: URL?
    let htmlURL: URL
    let id: Int
    let login: String

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatarUrl"
        case htmlURL = "htmlUrl"
        case id
        case login
    }
}

public struct GithubUserSearchResponseEntity: Decodable {
    let items: [GithubUserProfileEntity]
}
