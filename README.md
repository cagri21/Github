# Github Search Challenge

This project is an iOS SwiftUI case study that implements a reusable GitHub search autocomplete experience. The feature lets a user type a query, waits until the query is meaningful, searches GitHub users and repositories, merges both result types into one list, and handles loading, empty, error, retry, and pagination states.

The implementation is intentionally structured as a production-style feature rather than a single-screen prototype. Most of the project decisions are about keeping the UI reusable, keeping networking isolated, and making async search behavior testable.

## What the Feature Does

- Starts searching only after the query reaches 3 trimmed characters.
- Debounces typing by 300 milliseconds before calling the API.
- Searches both GitHub repositories and GitHub users.
- Requests 50 repositories and 50 users per remote page.
- Merges both result types into one alphabetically sorted autocomplete list.
- Shows repository metadata such as owner, description, language, and star count.
- Shows user results with avatars and profile destinations.
- Opens the selected GitHub result URL.
- Supports first-page loading, empty results, full search failure, partial endpoint failure, retry, and next-page loading.
- Ignores stale responses when the user types a newer query before an older response returns.

## Challenge Requirements Checklist

| Requirement | Covered? | Where / How |
| --- | --- | --- |
| Do not use an existing autocomplete library. | Yes | The autocomplete is custom SwiftUI code in `Github/Features/SearchAutocomplete`. Shared project UI components are used for styling, but no third-party autocomplete package is used. |
| Minimum 3 characters to start search. | Yes | `GithubSearchAutocompleteConfiguration.Search.minimumQueryLength` is `3`, and `GithubSearchAutocompleteViewModel` returns hint states before that limit. |
| Fetch both users and repositories. | Yes | `GithubSearchAutocompleteUseCaseImpl` calls `searchRepositories` and `searchUsers`. |
| Combine results into one list and sort alphabetically using repository name and profile/login name. | Yes | Repositories map their `name` to the suggestion title, users map their `login` to the suggestion title, and the merged suggestions are sorted by `sortValue`. |
| Limit results to 50 items per request. | Yes | Each GitHub endpoint request uses `perEndpointResultCount = 50`, sent as `per_page=50`. Because the brief also requires both users and repositories, a search makes one 50-item repository request and one 50-item user request. |
| Show visual feedback for loading, empty results, and error state. | Yes | `GithubSearchAutocompleteState` has `loading`, `empty`, and `error` cases, rendered by dedicated SwiftUI state views. |
| Handle rapid input changes sensibly. | Yes | The view model cancels active tasks, debounces input, and verifies the response still matches the latest normalized query before applying results. |
| The component should be reusable, not hardcoded to a single screen. | Yes | `GithubSearchAutocompleteView` receives a view model and an `onSelect` callback. The container separates props and actions, and the feature depends on a use-case protocol. |
| Include a meaningful snippet showing how the code is tested. | Yes | See the Testing section below; the tests cover request limits, sorting, partial failure, minimum character gating, stale-response handling, and pagination. |

## How to Run

Open the project in Xcode:

```sh
open Github.xcodeproj
```

Then select the `GitDev` scheme and run the app on an iOS simulator.

The project file is generated from `project.yml`. If the project needs to be regenerated and XcodeGen is installed, run:

```sh
./BuildScripts/xcodegen.sh
```

To build from the command line:

```sh
./scripts/build_git.sh dev
```

The build script also accepts `qa`, `prod`, or `all`.

## Optional GitHub Token

The app can call GitHub search without a token, but unauthenticated requests have stricter rate limits. For local authenticated requests, create an ignored secrets file:

```xcconfig
// Github/Core/Configs/Secrets.xcconfig
GIT_API_KEY = your_github_token_here
```

Real tokens should never be committed. If a token is ever shared in chat or committed by accident, rotate it before using the project again.

## Project Structure

The project is split into app code, API code, and shared networking code:

```text
Github/
  Features/SearchAutocomplete/
    Boundary/
    Components/
    Config/
    Model/
    State/
    View/
    ViewModel/

Packages/
  GithubAPI/
    API/SearchAPI/
      SearchDomain/
      SearchData/
  CommonData/
    Sources/CommonData/Networking/

GithubTests/
  SearchAutocomplete/
    Accessibility/
    Components/
    UseCase/
    View/
    ViewModel/
    Language/
  Support/
    Extensions/
    Helpers/
    SearchAutocomplete/
    UI/

GithubUITests/
  SearchAutocomplete/
  Launch/
  Support/
```

The main app target owns composition and presentation. `GithubAPI` owns GitHub-specific services, repositories, entities, requests, and mapping. `CommonData` owns reusable transport concerns such as request execution, validation, logging, and network client configuration.

## Architecture Decisions

### 1. Keep the autocomplete feature inside `Github/Features`

The SwiftUI feature lives under `Github/Features/SearchAutocomplete` because it is app-facing presentation code. It contains the view, view model, state, UI components, configuration, and boundary models needed by the screen.

This keeps the feature easy to inspect during review: the reviewer can open one folder and understand the UI behavior without jumping through unrelated app files. It also keeps the feature reusable inside the app because the root `GithubSearchAutocompleteView` only needs a view model and an `onSelect` callback.

### 2. Use a feature boundary instead of calling the API directly from the view model

The view model depends on `GithubSearchAutocompleteUseCase`, not directly on a network client or concrete GitHub repository. That boundary is small:

```swift
protocol GithubSearchAutocompleteUseCase {
    func search(query: String, page: Int) async throws -> GithubSearchAutocompleteBatch
}
```

This decision makes the view model testable without network calls. Tests can provide a stub use case that returns slow, failed, empty, or paginated responses. It also prevents the UI layer from knowing how many endpoints are called or how API entities are mapped.

### 3. Put GitHub API details in a local Swift package

GitHub search code lives in `Packages/GithubAPI/API/SearchAPI` instead of the app target. The package is split into:

- `SearchDomain`: public domain models and service protocols.
- `SearchData`: request construction, network implementation, entity decoding, and entity-to-domain mapping.
- `SearchAPI`: the module facade that exposes a live search module to the app.

The reason for this layering is separation of concerns. The app should not care whether data comes from URLSession, a mock, or another transport later. The API package can evolve independently and can be reused by another target if needed.

### 4. Reuse `CommonData` as the transport layer

The project already has `CommonData` for networking primitives. The search API uses that instead of creating a second networking stack.

This keeps behavior consistent across APIs: request construction, validation, logging, headers, and URLSession execution follow the same path as the rest of the project. It also avoids duplicating low-level networking logic inside the challenge feature.

### 5. Fetch users and repositories concurrently

The use case searches repositories and users with `async let`:

```swift
async let repositorySearch = searchRepositoriesResult(...)
async let userSearch = searchUsersResult(...)
```

This is faster than waiting for repositories and then starting users. The two GitHub endpoints are independent, so there is no benefit to serial execution. Running them concurrently reduces perceived latency while keeping the code simple and structured.

### 6. Allow partial success

Each endpoint result is captured as a `Result` instead of immediately throwing. If repository search fails but user search succeeds, the UI still shows the user results. If user search fails but repository search succeeds, the UI still shows repositories.

This is a deliberate UX decision. Autocomplete should be useful whenever it has useful data. A full-screen error is reserved for cases where no suggestions can be shown and at least one endpoint failed.

### 7. Normalize and gate the query before searching

The view model trims whitespace and requires 3 characters before it searches. Empty input shows an initial hint, and short input shows a "keep typing" hint.

This decision prevents noisy API calls for very broad queries such as `a` or `ab`. It also gives the user immediate feedback instead of showing an empty state before a real search has happened.

### 8. Debounce input changes

Search is delayed by 300 milliseconds. Rapid typing cancels the previous task and schedules a new one.

This protects the GitHub API from unnecessary requests and makes the UI feel calmer. The delay is injected through `GithubSearchAutocompleteViewModelRuntime`, so tests can replace it with a no-op sleep and remain fast.

### 9. Ignore stale async responses

The view model checks that the response still belongs to the current normalized query before applying it:

```swift
normalizedQuery == self.normalizedQuery(from: query)
```

This handles a common autocomplete race condition. If a slow request for `swift` finishes after a faster request for `swiftui`, the old `swift` results are ignored and cannot overwrite the newer list.

### 10. Keep UI state explicit

The feature state is modeled as:

```swift
enum GithubSearchAutocompleteState {
    case hint(message: String)
    case loading
    case loaded(results: [GithubSearchAutocompleteItem])
    case empty(message: String)
    case error(message: String)
}
```

Explicit states make the UI easier to reason about. Each state maps to a concrete view: hint, loading, results, empty, or error. This avoids boolean combinations such as `isLoading && results.isEmpty && error == nil`, which become harder to maintain as the feature grows.

### 11. Separate container props and actions

`GithubSearchAutocompleteContainerView` receives `props` and `actions` instead of directly reaching into business logic everywhere.

This keeps the view declarative. The container describes what to render and what callbacks exist. The view model owns behavior. The split also makes previews and component-level testing easier because empty actions and static props can be supplied without constructing the full live feature.

### 12. Use a paging session to separate pagination bookkeeping

Pagination state lives in `GithubSearchAutocompletePagingSession`. It tracks:

- buffered suggestions that were fetched but not displayed yet,
- the current remote page,
- whether another remote page may exist.

The reason for this object is to keep pagination math out of the main view model flow. The view model decides when to load; the paging session decides what has already been fetched, what should be displayed next, and what page comes after the current one.

### 13. Fetch 100 remote results but display 50 at a time

Each remote page asks for 50 repositories and 50 users, so a single merged batch can contain up to 100 suggestions. The UI displays 50 at a time and buffers the rest.

This gives the user a mixed, alphabetized result set while avoiding an overly long initial render. It also means scrolling can reveal already-fetched results before the app needs another remote request.

### 14. Sort at the repository and merged-suggestion levels

Repository and user API responses are sorted individually in the data layer. The use case then merges both result types and sorts the combined suggestions by display title.

The final merged sort is the important user-facing sort because the UI presents repositories and users in one list. The lower-level sort keeps each endpoint deterministic before mapping and merging.

### 15. Use stable IDs with result-type prefixes

Suggestion IDs are prefixed with `repository-` or `user-`.

GitHub repository IDs and user IDs are from different domains. Prefixing them avoids accidental collisions in a single SwiftUI list and makes debugging easier because the ID itself communicates the result type.

### 16. Keep GitHub-specific headers close to GitHub requests

The search request layer adds GitHub headers such as:

- `Accept: application/vnd.github+json`
- `X-GitHub-Api-Version: 2022-11-28`
- optional `Authorization: Bearer ...`

The API key is read through the app configuration, but the header construction is kept near the GitHub search requests because these headers are specific to GitHub's API contract.

### 17. Use dependency registration for live services

The app uses Resolver to register `DataSourceConfig`, the network client, and live `SearchService` composition in `Github/Core/DI/App+Resolver.swift`.

This keeps object creation out of SwiftUI views. Views receive already-composed dependencies, while tests can bypass the live dependency graph and inject stubs directly.

### 18. Use custom UI components for consistency

The search screen uses project-level UI pieces such as `GitSearchBar`, `GitSurfaceCard`, `GitAsyncAvatar`, `GitCapsuleBadge`, and `GitMessageStateView`.

The decision here is consistency. The challenge feature should feel like part of the app rather than a pasted-in demo screen. Shared components also centralize style decisions such as spacing, typography, colors, shadows, avatar behavior, and badges.

### 19. Prefer localized strings and generated resources

User-facing text is defined through the localization flow and accessed through generated `L10n` values. Color and font resources are also generated.

This keeps strings out of the view logic and makes the feature easier to localize. It also reduces typo-prone resource references.

### 20. Keep case-study behavior covered with Swift Testing

The Swift Testing target is grouped by responsibility:

- `GithubTests/SearchAutocomplete/Accessibility` covers stable accessibility identifiers used by both SwiftUI and UI automation.
- `GithubTests/SearchAutocomplete/Components` covers state-to-symbol, state-to-color, and status presentation mapping.
- `GithubTests/SearchAutocomplete/UseCase` covers merging GitHub users and repositories, sorting, per-endpoint limits, partial failure, empty batches, and stable suggestion IDs.
- `GithubTests/SearchAutocomplete/View` covers reusable container actions and safe default callbacks.
- `GithubTests/SearchAutocomplete/ViewModel` covers query gating, whitespace trimming, empty/error states, retry, stale responses, clear behavior, and pagination.
- `GithubTests/SearchAutocomplete/Language` covers repository language normalization used by the UI.
- `GithubTests/Support/Extensions` covers reusable string, URL, date, attributed string, publisher, application, device, color, font, collection, number, and data helpers.
- `GithubTests/Support/Helpers` covers common state helpers used across reusable UI patterns.
- `GithubTests/Support/UI` covers shared SwiftUI support components and view-extension composition.
- `GithubTests/Support/SearchAutocomplete` keeps fixtures, spies, and stubs out of the behavior specs so the test intent stays readable.

The tests focus on the behavior most likely to regress:

- minimum query length prevents early searches,
- repository and user results are requested with the expected limits,
- merged suggestions are sorted,
- partial endpoint failure still returns available results,
- a full page reports that more results may exist,
- stale responses from older queries do not replace newer results,
- pagination loads the next page when the last visible item appears,
- repository language names are normalized for UI display,
- shared support components keep building safely as reusable UI pieces.

These tests are intentionally closer to behavior than implementation. For example, the stale-response test does not care exactly how cancellation is implemented; it cares that only the latest query remains visible.

## Error Handling Decisions

The feature separates initial search errors from pagination errors.

For the first page, a failure with no usable suggestions becomes a full error state with retry. This is appropriate because there is no existing content to keep on screen.

For next-page loading, a failure is stored in `nextPageErrorMessage` while existing results remain visible. This avoids punishing the user by removing already-loaded results just because loading more failed. The user can retry pagination separately.

## Configuration Decisions

Search behavior is centralized in `GithubSearchAutocompleteConfiguration`:

```swift
static let displayPageSize = 50
static let initialPage = 1
static let minimumQueryLength = 3
static let perEndpointResultCount = 50
static let searchDelay: Duration = .milliseconds(300)
```

Keeping these values in one place makes the challenge requirements visible and makes later tuning easier. It also keeps magic numbers out of the view model and tests.

## Testing

Run tests from Xcode with the `GitDev` scheme using Product > Test.

A command-line test run can also be executed with an available iOS simulator:

```sh
xcodebuild \
  -project Github.xcodeproj \
  -scheme GitDev \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  test
```

The main test folders are:

- `GithubTests/SearchAutocomplete/Accessibility`
- `GithubTests/SearchAutocomplete/Components`
- `GithubTests/SearchAutocomplete/UseCase`
- `GithubTests/SearchAutocomplete/View`
- `GithubTests/SearchAutocomplete/ViewModel`
- `GithubTests/SearchAutocomplete/Language`
- `GithubTests/Support/Extensions`
- `GithubTests/Support/Helpers`
- `GithubTests/Support/SearchAutocomplete`
- `GithubTests/Support/UI`
- `GithubUITests/SearchAutocomplete`
- `GithubUITests/Launch`
- `GithubUITests/Support`

The latest verified coverage run used:

```sh
xcodebuild \
  -project Github.xcodeproj \
  -scheme GitDev \
  -destination 'platform=iOS Simulator,id=113B9A5E-8D38-4BC7-89C1-9DD169E8B1FE' \
  -derivedDataPath /tmp/GithubDerivedData \
  -resultBundlePath /tmp/GithubCoverage7.xcresult \
  -enableCodeCoverage YES \
  test
```

Latest verified coverage from that result bundle:

| Target / Area | Coverage |
| --- | ---: |
| `Github.app` | 84.59% |
| `Github/Support` | 79.96% |
| `Github/Features/SearchAutocomplete` | 92.20% |
| `Github/Features/SearchAutocomplete` without previews | 97.33% |
| `GithubTests.xctest` | 95.60% |
| `GithubUITests.xctest` | 100.00% |

The same run executed 43 Swift Testing tests and 7 UI tests successfully.

This is one of the most important behavior tests. It proves that rapid input changes do not allow an older, slower response to overwrite the newer query's results:

```swift
@Test func keepsOnlyLatestResultsDuringRapidInputChanges() async throws {
    let useCase = SearchUseCaseStub { query, _ in
        if query == "swift" {
            try await Task.sleep(for: .milliseconds(80))
            return GithubSearchAutocompleteBatch(
                suggestions: [
                    GithubSearchSuggestion(
                        avatarURL: nil,
                        destinationURL: URL(string: "https://github.com/apple/swift")!,
                        detailText: nil,
                        id: "repository-swift",
                        kind: .repository,
                        primaryLanguage: "Swift",
                        starCount: 68_000,
                        subtitle: "apple",
                        title: "Swift"
                    )
                ],
                hasMoreResults: false
            )
        }

        return GithubSearchAutocompleteBatch(
            suggestions: [
                GithubSearchSuggestion(
                    avatarURL: nil,
                    destinationURL: URL(string: "https://github.com/apple/swiftui")!,
                    detailText: nil,
                    id: "repository-swiftui",
                    kind: .repository,
                    primaryLanguage: "Swift",
                    starCount: 45_000,
                    subtitle: "apple",
                    title: "SwiftUI"
                )
            ],
            hasMoreResults: false
        )
    }

    let viewModel = GithubSearchAutocompleteViewModel(
        useCase: useCase,
        policy: .init(searchDelay: .zero),
        runtime: .init(sleep: { _ in })
    )

    viewModel.updateQuery("swift")
    viewModel.updateQuery("swiftui")

    try await waitForViewModelTasks()

    if case let .loaded(results: items) = viewModel.state {
        #expect(items.map(\.title) == ["SwiftUI"])
    } else {
        Issue.record("Expected only the latest result set to remain visible.")
    }
}
```

The UI test target also launches the app with a debug-only deterministic search use case. That keeps UI automation independent from GitHub network availability and rate limits while still exercising the real SwiftUI search field, state transitions, result rows, empty state, loading state, and clear action.

## Tradeoffs and Limitations

- The GitHub Search API can rate-limit unauthenticated requests. A local token is supported, but the app should still behave gracefully without one.
- `hasMoreResults` is inferred from receiving a full endpoint page. This is simple and sufficient for the challenge, but a deeper implementation could inspect GitHub pagination links or total counts.
- The UI displays a combined alphabetical list. This makes the autocomplete predictable, but it does not rank by GitHub relevance after merging. A production search product might combine GitHub score, stars, exact matches, and recent activity.
- Repository and user results share one list. This keeps the component compact, but future versions could add filters or grouped sections if users need clearer separation.
- The app opens result URLs externally. A larger app could add in-app detail screens for repositories and users.

## What I Would Improve With More Time

- Add snapshot or visual regression coverage for the search states.
- Add integration tests around live request decoding using recorded GitHub API fixtures.
- Add deeper accessibility checks for spoken row labels and VoiceOver ordering.
- Add better relevance ranking for mixed repository/user suggestions.
- Add clearer handling for GitHub rate-limit responses with a specific message.
- Add offline caching for recent successful searches.

## Key Files for Review

- `Github/Features/SearchAutocomplete/ViewModel/GithubSearchAutocompleteViewModel.swift`
- `Github/Features/SearchAutocomplete/Boundary/GithubSearchAutocompleteUseCase.swift`
- `Github/Features/SearchAutocomplete/View/GithubSearchAutocompleteContainerView.swift`
- `Github/Features/SearchAutocomplete/Components/GithubSearchAutocompleteRowView.swift`
- `Packages/GithubAPI/API/SearchAPI/SearchData/SearchRepositoryImpl.swift`
- `Packages/GithubAPI/API/SearchAPI/SearchData/Network/SearchNetworkImpl.swift`
- `GithubTests/SearchAutocomplete/UseCase/GithubSearchAutocompleteUseCaseTests.swift`
- `GithubTests/SearchAutocomplete/ViewModel/GithubSearchAutocompleteViewModelTests.swift`
- `GithubUITests/SearchAutocomplete/GithubSearchAutocompleteFlowUITests.swift`

This README is written to explain not only what was built, but why the implementation is shaped this way.
