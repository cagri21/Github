import Foundation
import SearchDomain

extension GithubRepositorySummary {
    init(entity: GithubRepositoryEntity) {
        self.init(
            id: entity.id,
            name: entity.name,
            ownerLogin: entity.owner.login,
            description: entity.description,
            primaryLanguage: entity.language,
            repositoryURL: entity.htmlURL,
            ownerAvatarURL: entity.owner.avatarURL,
            starCount: entity.stargazersCount
        )
    }
}
