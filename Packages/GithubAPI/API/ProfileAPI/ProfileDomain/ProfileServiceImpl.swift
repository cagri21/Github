import Foundation

public struct ProfileServiceImpl: ProfileService {
    private let repository: ProfileRepository

    public init(repository: ProfileRepository) {
        self.repository = repository
    }

    public func fetchProfile() async throws -> Profile {
        try await repository.fetchProfile()
    }

    public func updateProfile(_ payload: UpdateProfilePayload) async throws -> Profile {
        try await repository.updateProfile(payload)
    }
}
