import CommonData
import Foundation
import SearchData
@_exported import SearchDomain

public enum SearchModule {
    public static func live(
        config: DataSourceConfig,
        session: URLSession? = nil
    ) -> SearchService {
        let client = NetworkClientFactory.live(
            config: config,
            session: session
        )
        let network = SearchNetworkImpl(
            client: client,
            config: config
        )
        let repository = SearchRepositoryImpl(network: network)

        return SearchServiceImpl(repository: repository)
    }
}
