import Foundation
import SearchDomain

extension GithubUserProfile {
    init(entity: GithubUserProfileEntity) {
        self.init(
            id: entity.id,
            login: entity.login,
            avatarURL: entity.avatarURL,
            profileURL: entity.htmlURL
        )
    }
}
