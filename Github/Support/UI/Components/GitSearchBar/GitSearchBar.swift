import SwiftUI

struct GitSearchBar: View {
    let actions: GitSearchBarActions
    let isFocused: FocusState<Bool>.Binding
    let props: GitSearchBarProps

    var body: some View {
        HStack(spacing: props.style.layout.stackSpacing) {
            GitSurfaceCard(style: props.style.surfaceStyle) {
                HStack(spacing: props.style.layout.fieldSpacing) {
                    Image(systemName: props.content.leadingSymbol.systemName)
                        .font(.system(size: props.style.icons.iconSize, weight: .medium))
                        .foregroundStyle(props.style.colors.iconColor)

                    TextField(
                        text: Binding(
                            get: { props.content.query },
                            set: actions.onQueryChange
                        ),
                        prompt: Text(props.content.placeholder)
                            .foregroundColor(props.style.colors.placeholderColor)
                    ) {
                        EmptyView()
                    }
                    .font(props.style.typography.textFont)
                    .foregroundStyle(props.style.colors.textColor)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .tint(props.style.colors.tintColor)
                    .focused(isFocused)

                    if !props.content.query.isEmpty {
                        Button {
                            actions.onQueryChange(.gitEmpty)
                        } label: {
                            Image(systemName: GitSymbol.clearCircleFill.systemName)
                                .font(.system(size: props.style.icons.clearIconSize, weight: .semibold))
                                .foregroundStyle(props.style.colors.clearIconColor)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, props.style.layout.horizontalPadding)
                .frame(height: props.style.layout.fieldHeight)
            }

            Button(props.content.cancelTitle) {
                actions.onCancel()
            }
            .font(props.style.typography.cancelFont)
            .foregroundStyle(props.style.colors.cancelColor)
        }
    }
}
