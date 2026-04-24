import XCTest

@MainActor
final class GithubLaunchUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunchShowsInitialHintState() throws {
        let app = launchGithubSearchApp()

        XCTAssertTrue(githubElement(GithubUITestID.hintState, in: app).waitForExistence(timeout: 2))

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
