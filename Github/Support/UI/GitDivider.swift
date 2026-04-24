import SwiftUI

struct GitDivider: View {
    enum Orientation {
        case horizontal
        case vertical
    }

    let orientation: Orientation
    let thickness: CGFloat
    let spacing: CGFloat
    let color: Color

    init(
        orientation: Orientation = .horizontal,
        thickness: CGFloat = GitAppTheme.BorderWidth.regular,
        spacing: CGFloat = GitSpacing.base(times: GitSpacing.Multiplier.divider),
        color: Color = .secondary.opacity(GitAppTheme.Opacity.divider)
    ) {
        self.orientation = orientation
        self.thickness = thickness
        self.spacing = spacing
        self.color = color
    }

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(
                width: orientation == .vertical ? thickness : nil,
                height: orientation == .horizontal ? thickness : nil
            )
            .padding(
                orientation == .horizontal ? .horizontal : .vertical,
                spacing
            )
    }
}
