import XCTest

@MainActor
final class GithubSearchAutocompleteFlowUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testShortQueryShowsHintWithoutResults() throws {
        let app = launchGithubSearchApp()

        typeSearchText("sw", in: app)

        XCTAssertTrue(githubElement(GithubUITestID.hintState, in: app).waitForExistence(timeout: 2))
        XCTAssertFalse(githubElement(GithubUITestID.resultsCount, in: app).waitForExistence(timeout: 0.5))
    }

    func testSearchShowsDeterministicMergedResults() throws {
        let app = launchGithubSearchApp()

        typeSearchText("swift", in: app)

        XCTAssertTrue(githubElement(GithubUITestID.resultsCount, in: app).waitForExistence(timeout: 2))
        XCTAssertTrue(githubElement(GithubUITestID.resultRow("repository-100"), in: app).exists)
        XCTAssertTrue(githubElement(GithubUITestID.resultRow("user-200"), in: app).exists)
        XCTAssertTrue(githubElement(GithubUITestID.resultRow("repository-101"), in: app).exists)
    }

    func testLoadingStateAppearsBeforeSlowResults() throws {
        let app = launchGithubSearchApp()

        typeSearchText("loading", in: app)

        XCTAssertTrue(githubElement(GithubUITestID.loadingState, in: app).waitForExistence(timeout: 1))
        XCTAssertTrue(githubElement(GithubUITestID.resultRow("repository-100"), in: app).waitForExistence(timeout: 3))
    }

    func testEmptySearchShowsEmptyState() throws {
        let app = launchGithubSearchApp()

        typeSearchText("empty", in: app)

        XCTAssertTrue(githubElement(GithubUITestID.emptyState, in: app).waitForExistence(timeout: 2))
        XCTAssertFalse(githubElement(GithubUITestID.resultsCount, in: app).exists)
    }

    func testErrorSearchShowsRetryState() throws {
        let app = launchGithubSearchApp()

        typeSearchText("error", in: app)

        XCTAssertTrue(githubElement(GithubUITestID.errorState, in: app).waitForExistence(timeout: 2))
        XCTAssertFalse(githubElement(GithubUITestID.resultsCount, in: app).exists)
    }

    func testClearButtonReturnsToHintState() throws {
        let app = launchGithubSearchApp()

        typeSearchText("swift", in: app)
        XCTAssertTrue(githubElement(GithubUITestID.resultsCount, in: app).waitForExistence(timeout: 2))

        githubElement(GithubUITestID.clearButton, in: app).tap()

        XCTAssertTrue(githubElement(GithubUITestID.hintState, in: app).waitForExistence(timeout: 2))
        XCTAssertFalse(githubElement(GithubUITestID.resultsCount, in: app).exists)
    }
}
