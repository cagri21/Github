@testable import Github
import SwiftUI
import Testing
import UIKit

@MainActor
@Suite("Support UI components")
struct GitSupportUIComponentTests {
    @Test func spacingAndShapeHelpersProduceExpectedValues() {
        #expect(GitSpacing.base() == GitSpacing.xxSmall)
        #expect(GitSpacing.base(times: GitSpacing.Multiplier.divider) == 24)

        let path = GitRoundedCorner(
            radius: 8,
            corners: [.topLeft, .bottomRight]
        )
        .path(in: CGRect(x: 0, y: 0, width: 40, height: 20))

        #expect(!path.isEmpty)
    }

    @Test func dividerBuildsBothOrientations() {
        let horizontal = GitDivider(
            orientation: .horizontal,
            thickness: 1,
            spacing: 8,
            color: .gray
        )
        let vertical = GitDivider(
            orientation: .vertical,
            thickness: 2,
            spacing: 6,
            color: .blue
        )

        _ = horizontal.body
        _ = vertical.body
        render(horizontal)
        render(vertical)
    }

    @Test func commonSupportViewsBuildBodies() {
        render(GitGradientBackground(colors: [.red, .blue]))
        render(GitDisclosureIndicator(
            style: .init(
                color: .secondary,
                font: .body,
                symbol: .chevronRight
            )
        ))
        render(GitSurfaceCard(
            style: .init(
                shape: .init(cornerRadius: 8),
                fill: .init(color: .black.opacity(0.2)),
                border: .init(color: .white.opacity(0.2), width: 1),
                shadow: .init(color: .black.opacity(0.2), radius: 8)
            )
        ) {
            Text("Surface")
        })
    }

    @Test func viewExtensionsCanBeComposedSafely() {
        defer {
            UIScrollView.appearance().bounces = true
        }

        var height: CGFloat = 0
        let sheetItem = Binding<TestSheetItem?>(
            get: { nil },
            set: { _ in }
        )

        render(Text("Support")
            .gitRoundedBorder(radius: 8)
            .gitHidden(false)
            .gitCornerRadius(8, corners: [.topLeft])
            .gitOnViewDidLoad()
            .gitHideListContentBackground()
            .gitKeyboardAvoiding(isActive: false)
            .gitUnderline(color: .blue)
            .gitDisableBounces()
            .gitOnFirstAppear(resetOnDisappear: true) {}
            .gitSyncHeight(with: Binding(get: { height }, set: { height = $0 }))
            .gitOverlayBorder(color: .gray, cornerRadius: 8)
            .gitShadow()
            .gitDismissKeyboardOnTap()
            .gitBlurredSheet(item: sheetItem) { item in
                Text(item.title)
            }
            .gitShowPulseOnShake()
            .gitDoneToolbar(active: true)
        )

        var actionWasCalled = false
        Text("No animation").gitWithoutAnimation {
            actionWasCalled = true
        }

        #expect(actionWasCalled)
    }
}

@MainActor
@discardableResult
private func render<Content: View>(
    _ content: Content
) -> UIHostingController<Content> {
    let controller = UIHostingController(rootView: content)
    controller.view.frame = CGRect(
        x: 0,
        y: 0,
        width: 320,
        height: 640
    )
    controller.loadViewIfNeeded()
    controller.view.setNeedsLayout()
    controller.view.layoutIfNeeded()
    return controller
}

private struct TestSheetItem: Identifiable {
    let id: Int
    let title: String
}
