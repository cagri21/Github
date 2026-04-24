import Foundation
import ProfileDomain

extension Profile {
    init(entity: ProfileEntity) {
        self.init(
            id: entity.id,
            username: entity.username,
            displayName: entity.displayName,
            bio: entity.bio
        )
    }
}
