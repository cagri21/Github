import Foundation

public protocol ProfileService {
    func fetchProfile() async throws -> Profile
    func updateProfile(_ payload: UpdateProfilePayload) async throws -> Profile
}
