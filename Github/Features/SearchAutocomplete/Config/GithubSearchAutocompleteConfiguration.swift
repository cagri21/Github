import Foundation
import SwiftUI

enum GithubSearchAutocompleteConfiguration {
    enum Search {
        static let displayPageSize = 50
        static let initialPage = 1
        static let initialPageIndex = 0
        static let minimumQueryLength = 3
        static let nextPageIncrement = 1
        static let perEndpointResultCount = 50
        static let searchDelay: Duration = .milliseconds(300)
    }

    enum SuggestionIdentifierPrefix: String {
        case repository
        case user

        func makeID(
            _ value: some CustomStringConvertible
        ) -> String {
            "\(rawValue)-\(value)"
        }
    }

    enum StarCount {
        static let thousand = 1_000
        static let million = 1_000_000
    }

    enum Preview {
        static let emptyQuery = "zzzzxyz"
        static let hintQuery = "sw"
        static let minimumCharacterCount = Search.minimumQueryLength
        static let resultsQuery = "swiftui"

        enum Device: String {
            case iPhone15Pro = "iPhone 15 Pro"

            var previewDevice: PreviewDevice {
                PreviewDevice(rawValue: rawValue)
            }
        }

        enum FrameName: String {
            case empty = "futuristic_empty 1"
            case error = "futuristic_error 1"
            case hint = "futuristic_hint 1"
            case loading = "futuristic_loading 1"
            case results = "futuristic_results 1"
        }
    }
}
