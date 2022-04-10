//
//  Environments.swift
//  
//
//  Created by Rico Crescenzio on 31/03/22.
//

import SwiftUI

private struct ResponderValueKey: EnvironmentKey {
    static let defaultValue: AnyHashable? = nil
}

private struct ResponderStorageKey: EnvironmentKey {
    static let defaultValue: ResponderStorage? = nil
}

private struct UIFontEnvironmentKey: EnvironmentKey {
    static let defaultValue: UIFont? = nil
}

private struct UIReturnKeyTypeEnvironmentKey: EnvironmentKey {
    static let defaultValue: UIReturnKeyType = .default
}

private struct UITextFieldSecureTextEntryEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

private struct UITextFieldClearButtonModeEnvironmentKey: EnvironmentKey {
    static let defaultValue: UITextField.ViewMode = .never
}

private struct UITextFieldBorderStyleEnvironmentKey: EnvironmentKey {
    static let defaultValue: UITextField.BorderStyle = .none
}

private struct UITextAutocapitalizationTypeEnvironmentKey: EnvironmentKey {
    static let defaultValue: UITextAutocapitalizationType = .none
}

private struct UITextAutocorrectionTypeEnvironmentKey: EnvironmentKey {
    static let defaultValue: UITextAutocorrectionType = .default
}

private struct UITextFieldKeyboardTypeEnvironmentKey: EnvironmentKey {
    static let defaultValue: UIKeyboardType = .default
}

private struct UITextFieldTextContentModeEnvironmentKey: EnvironmentKey {
    static let defaultValue: UITextContentType? = nil
}

private struct UITextFieldTextAlignmentEnvironmentKey: EnvironmentKey {
    static let defaultValue: NSTextAlignment = .left
}

private struct UITextFieldLeftViewModeEnvironmentKey: EnvironmentKey {
    static let defaultValue: UITextField.ViewMode = .never
}

private struct UITextFieldRightViewModeEnvironmentKey: EnvironmentKey {
    static let defaultValue: UITextField.ViewMode = .never
}

private struct UITextFieldDefaultTextAttributesEnvironmentKey: EnvironmentKey {
    static let defaultValue: [NSAttributedString.Key: Any] = [:]
}

private struct UITextFieldSpellCheckingTypeEnvironmentKey: EnvironmentKey {
    static let defaultValue = UITextSpellCheckingType.default
}

private struct UITextFieldPasswordRulesEnvironmentKey: EnvironmentKey {
    static let defaultValue: UITextInputPasswordRules? = nil
}

private struct UITextFieldAdjustsFontSizeToFitWidthEnvironmentKey: EnvironmentKey {
    static let defaultValue = FontSizeWidthAdjustment.disabled
}

extension EnvironmentValues {

    var responderValue: AnyHashable? {
        get { self[ResponderValueKey.self] }
        set { self[ResponderValueKey.self] = newValue }
    }

    var responderStorage: ResponderStorage? {
        get { self[ResponderStorageKey.self] }
        set { self[ResponderStorageKey.self] = newValue }
    }

    var uiFont: UIFont? {
        get { self[UIFontEnvironmentKey.self] }
        set { self[UIFontEnvironmentKey.self] = newValue?.copy() as? UIFont }
    }

    var uiReturnKeyType: UIReturnKeyType {
        get { self[UIReturnKeyTypeEnvironmentKey.self] }
        set { self[UIReturnKeyTypeEnvironmentKey.self] = newValue }
    }

    var uiTextFieldSecureTextEntry: Bool {
        get { self[UITextFieldSecureTextEntryEnvironmentKey.self] }
        set { self[UITextFieldSecureTextEntryEnvironmentKey.self] = newValue }
    }

    var uiTextFieldClearButtonMode: UITextField.ViewMode {
        get { self[UITextFieldClearButtonModeEnvironmentKey.self] }
        set { self[UITextFieldClearButtonModeEnvironmentKey.self] = newValue }
    }

    var uiTextFieldBorderStyle: UITextField.BorderStyle {
        get { self[UITextFieldBorderStyleEnvironmentKey.self] }
        set { self[UITextFieldBorderStyleEnvironmentKey.self] = newValue }
    }

    var uiTextAutocapitalizationType: UITextAutocapitalizationType {
        get { self[UITextAutocapitalizationTypeEnvironmentKey.self] }
        set { self[UITextAutocapitalizationTypeEnvironmentKey.self] = newValue }
    }

    var uiTextAutocorrectionType: UITextAutocorrectionType {
        get { self[UITextAutocorrectionTypeEnvironmentKey.self] }
        set { self[UITextAutocorrectionTypeEnvironmentKey.self] = newValue }
    }

    var uiTextFieldKeyboardType: UIKeyboardType {
        get { self[UITextFieldKeyboardTypeEnvironmentKey.self] }
        set { self[UITextFieldKeyboardTypeEnvironmentKey.self] = newValue }
    }

    var uiTextFieldTextContentMode: UITextContentType? {
        get { self[UITextFieldTextContentModeEnvironmentKey.self] }
        set { self[UITextFieldTextContentModeEnvironmentKey.self] = newValue }
    }

    var uiTextFieldTextAlignment: NSTextAlignment {
        get { self[UITextFieldTextAlignmentEnvironmentKey.self] }
        set { self[UITextFieldTextAlignmentEnvironmentKey.self] = newValue }
    }

    var uiTextFieldTextLeftViewMode: UITextField.ViewMode {
        get { self[UITextFieldLeftViewModeEnvironmentKey.self] }
        set { self[UITextFieldLeftViewModeEnvironmentKey.self] = newValue }
    }

    var uiTextFieldTextRightViewMode: UITextField.ViewMode {
        get { self[UITextFieldRightViewModeEnvironmentKey.self] }
        set { self[UITextFieldRightViewModeEnvironmentKey.self] = newValue }
    }

    var uiTextFieldDefaultTextAttributes: [NSAttributedString.Key: Any] {
        get { self[UITextFieldDefaultTextAttributesEnvironmentKey.self] }
        set { self[UITextFieldDefaultTextAttributesEnvironmentKey.self] = newValue }
    }

    var uiTextFieldSpellCheckingType: UITextSpellCheckingType {
        get { self[UITextFieldSpellCheckingTypeEnvironmentKey.self] }
        set { self[UITextFieldSpellCheckingTypeEnvironmentKey.self] = newValue }
    }

    var uiTextFieldPasswordRules: UITextInputPasswordRules? {
        get { self[UITextFieldPasswordRulesEnvironmentKey.self] }
        set { self[UITextFieldPasswordRulesEnvironmentKey.self] = newValue }
    }

    var uiTextFieldAdjustsFontSizeToFitWidth: FontSizeWidthAdjustment {
        get { self[UITextFieldAdjustsFontSizeToFitWidthEnvironmentKey.self] }
        set { self[UITextFieldAdjustsFontSizeToFitWidthEnvironmentKey.self] = newValue }
    }

}

public extension View {

    /// Sets the default `UIFont` for ``SUITextField`` in this view.
    ///
    /// Use `uiTextFieldFont(_:)` to apply a specific font to all of the ``SUITextField`` in a view.
    ///
    /// The example below shows the effects of applying fonts to individual
    /// views and to view hierarchies. Font information flows down the view
    /// hierarchy as part of the environment, and remains in effect unless
    /// overridden at the level of an individual view or view container.
    ///
    /// Here, the outermost `VStack` applies a 16-point system font as a
    /// default font to text fields contained in that `VStack`. Inside that stack,
    /// the example applies a 20-point bold system font to just the first text
    /// field; this explicitly overrides the default. The remaining stack and the
    /// views contained with it continue to use the 16-point system font set by
    /// their containing view:
    ///
    /// ```swift
    /// VStack {
    ///     SUITextField(text: $text, placeholder: "this text field has 20-point bold system font")
    ///         .uiTextFieldFont(.systemFont(ofSize: 20, weight: .bold))
    ///
    ///     VStack {
    ///         SUITextField(text: $text, placeholder: "this two text fields")
    ///         SUITextField(text: $text, placeholder: "have same font applied from modifier")
    ///     }
    /// }
    /// .uiTextFieldFont(.systemFont(ofSize: 16, weight: .light))
    /// ```
    ///
    /// - Parameter uiFont: The default font to use in this view.
    ///
    /// - Returns: A view with the default font set to the value you supply.
    func uiTextFieldFont(_ uiFont: UIFont?) -> some View {
        environment(\.uiFont, uiFont)
    }

    func uiTextFieldReturnKeyType(_ uiReturnKeyType: UIReturnKeyType) -> some View {
        environment(\.uiReturnKeyType, uiReturnKeyType)
    }

    func uiTextFieldSecureTextEntry(_ uiTextFieldSecureTextEntry: Bool) -> some View {
        environment(\.uiTextFieldSecureTextEntry, uiTextFieldSecureTextEntry)
    }

    func uiTextFieldClearButtonMode(_ uiTextFieldClearButtonMode: UITextField.ViewMode) -> some View {
        environment(\.uiTextFieldClearButtonMode, uiTextFieldClearButtonMode)
    }

    func uiTextFieldBorderStyle(_ uiTextFieldBorderStyle: UITextField.BorderStyle) -> some View {
        environment(\.uiTextFieldBorderStyle, uiTextFieldBorderStyle)
    }

    func uiTextFieldAutocapitalizationType(_ uiTextAutocapitalizationType: UITextAutocapitalizationType) -> some View {
        environment(\.uiTextAutocapitalizationType, uiTextAutocapitalizationType)
    }

    func uiTextFieldAutocorrectionType(_ uiTextAutocorrectionType: UITextAutocorrectionType) -> some View {
        environment(\.uiTextAutocorrectionType, uiTextAutocorrectionType)
    }

    func uiTextFieldKeyboardType(_ uiTextFieldKeyboardType: UIKeyboardType) -> some View {
        environment(\.uiTextFieldKeyboardType, uiTextFieldKeyboardType)
    }

    func uiTextFieldTextContentMode(_ uiTextFieldTextContentMode: UITextContentType?) -> some View {
        environment(\.uiTextFieldTextContentMode, uiTextFieldTextContentMode)
    }

    func uiTextFieldTextAlignment(_ uiTextFieldTextAlignment: NSTextAlignment) -> some View {
        environment(\.uiTextFieldTextAlignment, uiTextFieldTextAlignment)
    }

    func uiTextFieldTextLeftViewMode(_ uiTextFieldTextLeftViewMode: UITextField.ViewMode) -> some View {
        environment(\.uiTextFieldTextLeftViewMode, uiTextFieldTextLeftViewMode)
    }

    func uiTextFieldTextRightViewMode(_ uiTextFieldTextRightViewMode: UITextField.ViewMode) -> some View {
        environment(\.uiTextFieldTextRightViewMode, uiTextFieldTextRightViewMode)
    }

    func uiTextFieldDefaultTextAttributes(_ uiTextFieldDefaultTextAttributes: [NSAttributedString.Key: Any]) -> some View {
        environment(\.uiTextFieldDefaultTextAttributes, uiTextFieldDefaultTextAttributes)
    }

    func uiTextFieldSpellCheckingType(_ uiTextFieldSpellCheckingType: UITextSpellCheckingType) -> some View {
        environment(\.uiTextFieldSpellCheckingType, uiTextFieldSpellCheckingType)
    }

    func uiTextFieldPasswordRules(_ uiTextFieldPasswordRules: UITextInputPasswordRules) -> some View {
        environment(\.uiTextFieldPasswordRules, uiTextFieldPasswordRules)
    }

    func uiTextFieldAdjustsFontSizeToFitWidth(_ uiTextFieldAdjustsFontSizeToFitWidth: FontSizeWidthAdjustment) -> some View {
        environment(\.uiTextFieldAdjustsFontSizeToFitWidth, uiTextFieldAdjustsFontSizeToFitWidth)
    }
    
}
