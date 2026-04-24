import Foundation
import ProfileDomain

public protocol ProfileNetwork {
    func fetchProfile() async throws -> ProfileEnvelopeEntity
    func updateProfile(_ payload: UpdateProfilePayload) async throws -> ProfileEnvelopeEntity
}
