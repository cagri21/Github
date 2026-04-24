import Foundation
import GithubAPI

enum APIContainer {
    static let config = AppDataSourceConfig()
    static let profileService = ProfileModule.live(config: config)
}
