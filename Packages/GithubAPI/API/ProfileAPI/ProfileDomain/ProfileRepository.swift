import Foundation

public protocol ProfileRepository {
    func fetchProfile() async throws -> Profile
    func updateProfile(_ payload: UpdateProfilePayload) async throws -> Profile
}
