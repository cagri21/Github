import Foundation

public struct GithubRepositoryOwnerEntity: Decodable {
    let avatarURL: URL?
    let login: String

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatarUrl"
        case login
    }
}

public struct GithubRepositoryEntity: Decodable {
    let description: String?
    let htmlURL: URL
    let id: Int
    let language: String?
    let name: String
    let owner: GithubRepositoryOwnerEntity
    let stargazersCount: Int

    enum CodingKeys: String, CodingKey {
        case description
        case htmlURL = "htmlUrl"
        case id
        case language
        case name
        case owner
        case stargazersCount
    }
}

public struct GithubRepositorySearchResponseEntity: Decodable {
    let items: [GithubRepositoryEntity]
}
