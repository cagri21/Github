import Combine
import Foundation
@testable import Github
import SwiftUI
import Testing
import UIKit

@Suite("Support extensions")
struct GitSupportExtensionTests {
    @Test func stringHelpersNormalizeCommonInput() {
        #expect(String.gitEmpty.isEmpty)
        #expect("  \n ".gitIsBlank)
        #expect("hello ".gitRemovingTrailingSpace() == "hello")
        #expect(" hello".gitRemovingLeadingSpace() == "hello")
        #expect("hello   swift".gitRestrictingMultipleSpaces() == "hello swift")
        #expect("tel:+90 555-123".gitNumbersOnly() == "90555123")
        #expect("user@example.com".gitIsValidEmail())
        #expect(!"not an email".gitIsValidEmail())
        #expect("<strong>Hello</strong>".gitHTMLToPlainText.trimmingCharacters(in: .whitespacesAndNewlines) == "Hello")
        #expect("2024-02-03".gitTurkishDate() == "03.02.2024")
        #expect("03.02.2024".gitTurkishDate() == "03.02.2024")
        #expect("invalid".gitTurkishDate() == "invalid")
        #expect("1.234,50".gitParseDoubleAmount() == 1_234.5)
    }

    @Test func optionalStringTrimmingReturnsOnlyUsefulValues() {
        let blank: String? = "   "
        let value: String? = "  swift  "
        let missing: String? = nil

        #expect(blank.gitTrimmedNonEmpty == nil)
        #expect(value.gitTrimmedNonEmpty == "swift")
        #expect(missing.gitTrimmedNonEmpty == nil)
    }

    @Test func numberAndDataHelpersFormatStableValues() {
        #expect(NumberFormatter.gitCurrencyString(amount: 1_234.5, currency: "TRY") == "1.234,50 TRY")
        #expect(NumberFormatter.gitCurrencyString(amount: 1_234.5, currency: nil) == "-")
        #expect(1_234.5.gitMoneyFormatted == "1.234,50")
        #expect(Data([0, 15, 255]).gitHexString == "000fff")
    }

    @Test func collectionSafeSubscriptReturnsNilWhenOutOfBounds() {
        let values = ["a", "b", "c"]

        #expect(values[gitSafe: values.startIndex] == "a")
        #expect(values[gitSafe: values.endIndex] == nil)
    }

    @Test func urlHelpersAppendAndReadQueryItems() throws {
        let baseURL = try #require(URL(gitString: "https://example.com/search?q=swift"))
        let appendedURL = try #require(baseURL.gitAppending(name: "page", value: "2"))
        let parameters = try #require(appendedURL.gitQueryParameters)

        #expect(URL(gitString: nil) == nil)
        #expect(parameters["q"] == "swift")
        #expect(parameters["page"] == "2")
    }

    @Test func dateHelpersCompareAndFormatDates() throws {
        let calendar = Calendar(identifier: .gregorian)
        let firstDate = try #require(calendar.date(from: DateComponents(year: 2024, month: 2, day: 3, hour: 12)))
        let secondDate = try #require(calendar.date(from: DateComponents(year: 2024, month: 4, day: 9, hour: 12)))

        #expect(firstDate.gitIsEqual(to: secondDate, comparing: .year, in: calendar))
        #expect(!firstDate.gitIsEqual(to: secondDate, comparing: .month, in: calendar))
        #expect(!firstDate.gitFormatted(locale: Locale(identifier: "tr_TR")).isEmpty)
        #expect(!firstDate.formatted(.gitFullDateWithTime(locale: Locale(identifier: "en_US"))).isEmpty)
    }

    @Test func attributedStringHelpersApplyTextAttributes() {
        var linkedText = AttributedString.gitMarkdown("[Open](https://example.com)")
        linkedText.gitSetLinkAttributes(color: .blue, linkFont: .systemFont(ofSize: 14))

        var strongText = AttributedString.gitMarkdown("**Important** copy")
        strongText.gitSetStrongAttributes(font: .boldSystemFont(ofSize: 15), color: .red)

        let trimmedText = AttributedString("Line\n\n").gitTrimmingTrailingNewlines()
        let styledText = AttributedString.gitStyled(
            "Styled",
            font: .systemFont(ofSize: 12),
            color: .green
        )
        let highlightedText = AttributedString("Alpha Beta Gamma")
            .gitApplyingAttributes(to: "Beta") { text in
                text.foregroundColor = .orange
            }
        let multiHighlightedText = AttributedString("Alpha Beta Gamma")
            .gitApplyingAttributes(to: ["Alpha", "Gamma"]) { text in
                text.foregroundColor = .purple
            }

        #expect(String(linkedText.characters) == "Open")
        #expect(String(strongText.characters) == "Important copy")
        #expect(String(trimmedText.characters) == "Line")
        #expect(String(styledText.characters) == "Styled")
        #expect(String(highlightedText.characters) == "Alpha Beta Gamma")
        #expect(String(multiHighlightedText.characters) == "Alpha Beta Gamma")
    }

    @Test func colorAndFontHelpersHandleValidAndInvalidInputs() {
        #expect(Color(gitHex: "#336699") != nil)
        #expect(Color(gitHex: "#CC336699") != nil)
        #expect(Color(gitHex: "#12345") == nil)

        let font = UIFont.systemFont(ofSize: 16)
        let boldFont = font.gitBold()
        #expect(boldFont.pointSize == font.pointSize)
        #expect(boldFont.fontDescriptor.symbolicTraits.contains(.traitBold))
    }

    @Test func publisherGitFirstReturnsFirstValue() async throws {
        let value = try await Just("ready").gitFirst(timeout: 1)

        #expect(value == "ready")
    }

    @MainActor
    @Test func applicationAndDeviceHelpersExposeStableValues() {
        _ = UIApplication.gitAppVersion
        _ = UIApplication.gitAppBuild
        _ = UIApplication.shared.keyWindowInConnectedScenes
        UIApplication.shared.hideKeyboard()

        var notificationCount = 0
        let observer = NotificationCenter.default.addObserver(
            forName: UIDevice.gitShowPulse,
            object: nil,
            queue: nil
        ) { _ in
            notificationCount += 1
        }
        defer {
            NotificationCenter.default.removeObserver(observer)
        }

        UIDevice.gitPostShakeNotification()
        UIDevice.gitPostShakeNotification()

        #expect(notificationCount == 1)
    }
}
