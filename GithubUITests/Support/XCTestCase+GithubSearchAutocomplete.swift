import XCTest

typealias GithubUITestID = GithubSearchAutocompleteUITestID

extension XCTestCase {
    @MainActor
    func launchGithubSearchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = [
            "-github-search-ui-testing",
            "-AppleLanguages",
            "(en)",
            "-AppleLocale",
            "en_US"
        ]
        app.launch()
        return app
    }

    @MainActor
    func githubElement(
        _ identifier: String,
        in app: XCUIApplication
    ) -> XCUIElement {
        app.descendants(matching: .any)[identifier]
    }

    @MainActor
    func typeSearchText(
        _ text: String,
        in app: XCUIApplication,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let searchField = githubElement(GithubUITestID.searchField, in: app)
        XCTAssertTrue(searchField.waitForExistence(timeout: 2), file: file, line: line)
        searchField.tap()
        searchField.typeText(text)
    }
}
