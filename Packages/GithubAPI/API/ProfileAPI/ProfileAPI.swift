import CommonData
import Foundation
import ProfileData
@_exported import ProfileDomain

public enum ProfileModule {
    public static func live(
        config: DataSourceConfig,
        session: URLSession? = nil
    ) -> ProfileService {
        let client = NetworkClientFactory.live(
            config: config,
            session: session
        )
        let network = ProfileNetworkImpl(
            client: client,
            config: config
        )
        let repository = ProfileRepositoryImpl(network: network)

        return ProfileServiceImpl(repository: repository)
    }
}
