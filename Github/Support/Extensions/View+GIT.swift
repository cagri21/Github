import SwiftUI

extension View {
    func gitRoundedBorder(
        radius: CGFloat,
        color: Color = .secondary.opacity(0.2),
        lineWidth: CGFloat = 1
    ) -> some View {
        clipShape(RoundedRectangle(cornerRadius: radius))
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }

    func gitHidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }

    func gitCornerRadius(
        _ radius: CGFloat,
        corners: UIRectCorner
    ) -> some View {
        clipShape(
            GitRoundedCorner(
                radius: radius,
                corners: corners
            )
        )
    }

    func gitOnViewDidLoad(
        perform action: (() -> Void)? = nil
    ) -> some View {
        modifier(
            GitDidLoadModifier(action: action)
        )
    }

    func gitHideListContentBackground() -> some View {
        modifier(GitHideListContentBackgroundModifier())
    }

    func gitKeyboardAvoiding(
        isActive: Bool
    ) -> some View {
        modifier(
            GitKeyboardAvoidingModifier(
                isActive: isActive
            )
        )
    }

    func gitUnderline(
        color: Color,
        lineHeight: CGFloat = 1,
        bottomSpacing: CGFloat = 2
    ) -> some View {
        modifier(
            GitUnderlineModifier(
                color: color,
                lineHeight: lineHeight,
                bottomSpacing: bottomSpacing
            )
        )
    }

    func gitDisableBounces() -> some View {
        modifier(GitDisableBouncesModifier())
    }

    func gitOnFirstAppear(
        resetOnDisappear: Bool = false,
        _ perform: @escaping () -> Void
    ) -> some View {
        modifier(
            GitFirstAppearModifier(
                perform: perform,
                resetOnDisappear: resetOnDisappear
            )
        )
    }

    func gitSyncHeight(
        with height: Binding<CGFloat>
    ) -> some View {
        modifier(
            GitHeightSyncModifier(
                height: height
            )
        )
    }

    func gitOverlayBorder(
        color: Color,
        lineWidth: CGFloat = 1,
        cornerRadius: CGFloat
    ) -> some View {
        modifier(
            GitBorderOverlayModifier(
                color: color,
                lineWidth: lineWidth,
                cornerRadius: cornerRadius
            )
        )
    }

    func gitShadow(
        color: Color = .black.opacity(0.06),
        radius: CGFloat = 3,
        x: CGFloat = 0,
        y: CGFloat = 0
    ) -> some View {
        modifier(
            GitShadowModifier(
                color: color,
                radius: radius,
                x: x,
                y: y
            )
        )
    }

    func gitDismissKeyboardOnTap() -> some View {
        modifier(GitDismissKeyboardOnTapModifier())
    }

    func gitBlurredSheet<Item: Identifiable, SheetContent: View>(
        item: Binding<Item?>,
        blurRadius: CGFloat = 2,
        overlayColor: Color = .black.opacity(0.08),
        @ViewBuilder content: @escaping (Item) -> SheetContent
    ) -> some View {
        modifier(
            GitBlurredSheetModifier(
                item: item,
                blurRadius: blurRadius,
                overlayColor: overlayColor,
                sheetContent: content
            )
        )
    }

    func gitShowPulseOnShake() -> some View {
        modifier(GitShakeDetectionModifier())
    }

    func gitDoneToolbar(
        active: Bool,
        buttonTitle: String = "Done",
        perform: (() -> Void)? = nil
    ) -> some View {
        modifier(
            GitDoneToolbarModifier(
                isActive: active,
                buttonTitle: buttonTitle,
                perform: perform
            )
        )
    }

    func gitWithoutAnimation(
        action: @escaping () -> Void
    ) {
        var transaction = Transaction()
        transaction.disablesAnimations = true

        withTransaction(transaction) {
            action()
        }
    }
}
