import SwiftUI
import UIKit

extension AttributedString {
    static func gitMarkdown(_ text: String) -> AttributedString {
        (try? AttributedString(
            markdown: text,
            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )) ?? AttributedString(text)
    }

    mutating func gitSetLinkAttributes(
        color: Color = .accentColor,
        linkFont: UIFont? = nil,
        isUnderlined: Bool = true
    ) {
        for run in runs {
            guard run.link != nil else { continue }
            self[run.range].foregroundColor = color

            if let linkFont {
                self[run.range].font = linkFont
            }

            if isUnderlined {
                self[run.range].underlineStyle = .single
            }
        }
    }

    mutating func gitSetStrongAttributes(
        font: UIFont,
        color: Color
    ) {
        var newAttributes = AttributeContainer()
        newAttributes.font = font
        newAttributes.foregroundColor = color

        var defaultAttributes = AttributeContainer()
        defaultAttributes.inlinePresentationIntent = .stronglyEmphasized

        replaceAttributes(defaultAttributes, with: newAttributes)
    }

    func gitTrimmingTrailingNewlines() -> AttributedString {
        var result = self

        while let lastCharacter = result.characters.last,
              lastCharacter == "\n" || lastCharacter == "\r" {
            let endIndex = result.characters.index(
                before: result.characters.endIndex
            )
            result.removeSubrange(endIndex..<result.characters.endIndex)
        }

        return result
    }

    static func gitStyled(
        _ string: String,
        font: UIFont,
        color: Color
    ) -> AttributedString {
        var text = AttributedString.gitMarkdown(string)
        text.font = font
        text.foregroundColor = color
        return text
    }

    func gitApplyingAttributes(
        to substring: String,
        attributes: (inout AttributedString) -> Void
    ) -> AttributedString {
        var copy = self

        guard let range = copy.range(of: substring) else {
            return copy
        }

        var slice = AttributedString(copy[range])
        attributes(&slice)
        copy.replaceSubrange(range, with: slice)
        return copy
    }

    func gitApplyingAttributes(
        to substrings: [String],
        attributes: (inout AttributedString) -> Void
    ) -> AttributedString {
        var copy = self

        for substring in substrings {
            guard let range = copy.range(of: substring) else { continue }
            var slice = AttributedString(copy[range])
            attributes(&slice)
            copy.replaceSubrange(range, with: slice)
        }

        return copy
    }
}
