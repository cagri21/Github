#if canImport(Resolver)
import CommonData
import GithubAPI
import Resolver

extension Resolver: @retroactive ResolverRegistering {
    public static func registerAllServices() {
        let config = AppConfig()

        Resolver.main.register(AppConfig.self) { config }
            .scope(.application)
        Resolver.main.register(AppDataSourceConfig.self) { config.dataSourceConfig }
            .scope(.application)
        Resolver.main.register(DataSourceConfig.self) {
            config.dataSourceConfig as DataSourceConfig
        }
            .scope(.application)
        Resolver.main.registerNetworkLogger(
            subsystem: config.bundleIdentifier
        )
        Resolver.main.registerNetworkClient()
        Resolver.main.register(ProfileService.self) {
            let config: DataSourceConfig = resolve()
            return ProfileModule.live(config: config)
        }
        .scope(.application)
        Resolver.main.register(SearchService.self) {
            let config: DataSourceConfig = resolve()
            return SearchModule.live(config: config)
        }
        .scope(.application)
    }
}
#endif
