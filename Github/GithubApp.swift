//
//  GithubApp.swift
//  Github
//
//  Created by Yorukoglu, Cagri on 21.04.2026.
//

import GithubAPI
import Pulse
import PulseProxy
import SwiftUI
#if canImport(Resolver)
import Resolver
#endif

@main
struct GithubApp: App {
    private let searchUseCase: GithubSearchAutocompleteUseCase

    init() {
#if canImport(Resolver)
        Resolver.registerAllServices()
        let service = Resolver.resolve(SearchService.self)
        searchUseCase = GithubSearchAutocompleteUseCaseImpl(service: service)
#else
        let service = SearchModule.live(config: AppDataSourceConfig())
        searchUseCase = GithubSearchAutocompleteUseCaseImpl(service: service)
#endif
        Pulse.NetworkLogger.enableProxy()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: GithubSearchAutocompleteViewModel(
                    useCase: searchUseCase
                )
            )
            .gitShowPulseOnShake()
        }
    }
}
