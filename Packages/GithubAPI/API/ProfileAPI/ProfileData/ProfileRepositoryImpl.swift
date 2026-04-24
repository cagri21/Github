import CommonData
import Foundation
import ProfileDomain

public struct ProfileRepositoryImpl: ProfileRepository {
    private let network: ProfileNetwork

    public init(network: ProfileNetwork) {
        self.network = network
    }

    public func fetchProfile() async throws -> Profile {
        let response = try await network.fetchProfile()
        try APIResponseValidator.validate(header: response.header)
        return Profile(entity: response.data)
    }

    public func updateProfile(_ payload: UpdateProfilePayload) async throws -> Profile {
        let response = try await network.updateProfile(payload)
        try APIResponseValidator.validate(header: response.header)
        return Profile(entity: response.data)
    }
}
