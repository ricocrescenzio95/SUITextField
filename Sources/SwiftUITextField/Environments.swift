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

private struct UITextFieldTextContentTypeEnvironmentKey: EnvironmentKey {
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
    static let defaultValue: [NSAttributedString.Key: Any]? = nil
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
  
}

public extension EnvironmentValues {

    /// The `UIFont` of ``SUITextField``, applied using ``SUITextField/uiTextFieldFont(_:)``.
    var uiTextFieldFont: UIFont? {
        get { self[UIFontEnvironmentKey.self] }
        set { self[UIFontEnvironmentKey.self] = newValue?.copy() as? UIFont }
    }

    /// The `UIReturnKeyType` of ``SUITextField``, applied using ``SUITextField/uiTextFieldReturnKeyType(_:)``.
    var uiReturnKeyType: UIReturnKeyType {
        get { self[UIReturnKeyTypeEnvironmentKey.self] }
        set { self[UIReturnKeyTypeEnvironmentKey.self] = newValue }
    }

    /// Indicates whether the ``SUITextField`` should hide chrarcters, applied using ``SUITextField/uiTextFieldSecureTextEntry(_:)``.
    var uiTextFieldSecureTextEntry: Bool {
        get { self[UITextFieldSecureTextEntryEnvironmentKey.self] }
        set { self[UITextFieldSecureTextEntryEnvironmentKey.self] = newValue }
    }

    /// The `UITextField.ViewMode` of the clear button of ``SUITextField``,
    /// applied using ``SUITextField/uiTextFieldClearButtonMode(_:)``.
    var uiTextFieldClearButtonMode: UITextField.ViewMode {
        get { self[UITextFieldClearButtonModeEnvironmentKey.self] }
        set { self[UITextFieldClearButtonModeEnvironmentKey.self] = newValue }
    }
  
    /// The `UITextField.BorderStyle` of the border  of ``SUITextField``,
    /// applied using ``SUITextField/uiTextFieldBorderStyle(_:)``.
    var uiTextFieldBorderStyle: UITextField.BorderStyle {
        get { self[UITextFieldBorderStyleEnvironmentKey.self] }
        set { self[UITextFieldBorderStyleEnvironmentKey.self] = newValue }
    }

    /// The `UITextAutocapitalizationType` of the ``SUITextField``,
    /// applied using ``SUITextField/uiTextFieldBorderStyle(_:)``.
    var uiTextAutocapitalizationType: UITextAutocapitalizationType {
        get { self[UITextAutocapitalizationTypeEnvironmentKey.self] }
        set { self[UITextAutocapitalizationTypeEnvironmentKey.self] = newValue }
    }

    /// The `UITextAutocorrectionType` of the ``SUITextField``,
    /// applied using ``SUITextField/uiTextAutocorrectionType(_:)``.
    var uiTextAutocorrectionType: UITextAutocorrectionType {
        get { self[UITextAutocorrectionTypeEnvironmentKey.self] }
        set { self[UITextAutocorrectionTypeEnvironmentKey.self] = newValue }
    }

    /// The `UIKeyboardType` of the ``SUITextField``,
    /// applied using ``SUITextField/uiTextFieldKeyboardType(_:)``.
    var uiTextFieldKeyboardType: UIKeyboardType {
        get { self[UITextFieldKeyboardTypeEnvironmentKey.self] }
        set { self[UITextFieldKeyboardTypeEnvironmentKey.self] = newValue }
    }

    /// The `UITextContentType` of the ``SUITextField``,
    /// applied using ``SUITextField/uiTextFieldTextContentType(_:)``.
    var uiTextFieldTextContentType: UITextContentType? {
        get { self[UITextFieldTextContentTypeEnvironmentKey.self] }
        set { self[UITextFieldTextContentTypeEnvironmentKey.self] = newValue }
    }

    /// The `NSTextAlignment` of the ``SUITextField``,
    /// applied using ``SUITextField/uiTextFieldTextAlignment(_:)``.
    var uiTextFieldTextAlignment: NSTextAlignment {
        get { self[UITextFieldTextAlignmentEnvironmentKey.self] }
        set { self[UITextFieldTextAlignmentEnvironmentKey.self] = newValue }
    }

    /// The `UITextField.ViewMode` of  the ``SUITextField/leftView(view:)``,
    /// applied using ``SUITextField/uiTextFieldTextLeftViewMode(_:)``.
    var uiTextFieldTextLeftViewMode: UITextField.ViewMode {
        get { self[UITextFieldLeftViewModeEnvironmentKey.self] }
        set { self[UITextFieldLeftViewModeEnvironmentKey.self] = newValue }
    }

    /// The `UITextField.ViewMode` of  the ``SUITextField/rightView(view:)``,
    /// applied using ``SUITextField/uiTextFieldTextRightViewMode(_:)``.
    var uiTextFieldTextRightViewMode: UITextField.ViewMode {
        get { self[UITextFieldRightViewModeEnvironmentKey.self] }
        set { self[UITextFieldRightViewModeEnvironmentKey.self] = newValue }
    }

    /// The attributes dictionary of the ``SUITextField`` that styles active text,
    /// applied using ``SUITextField/uiTextFieldDefaultTextAttributes(_:)``.
    var uiTextFieldDefaultTextAttributes: [NSAttributedString.Key: Any]? {
        get { self[UITextFieldDefaultTextAttributesEnvironmentKey.self] }
        set { self[UITextFieldDefaultTextAttributesEnvironmentKey.self] = newValue }
    }

    /// The `UITextSpellCheckingType` of  the ``SUITextField``,
    /// applied using ``SUITextField/uiTextFieldSpellCheckingType(_:)``.
    var uiTextFieldSpellCheckingType: UITextSpellCheckingType {
        get { self[UITextFieldSpellCheckingTypeEnvironmentKey.self] }
        set { self[UITextFieldSpellCheckingTypeEnvironmentKey.self] = newValue }
    }

    /// The `UITextInputPasswordRules` of  the ``SUITextField``,
    /// applied using ``SUITextField/uiTextFieldPasswordRules(_:)``.
    var uiTextFieldPasswordRules: UITextInputPasswordRules? {
        get { self[UITextFieldPasswordRulesEnvironmentKey.self] }
        set { self[UITextFieldPasswordRulesEnvironmentKey.self] = newValue }
    }

    /// The ``FontSizeWidthAdjustment`` of  the ``SUITextField``,
    /// applied using ``SUITextField/uiTextFieldAdjustsFontSizeToFitWidth(_:)``.
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
    /// - Parameter font: The default font to use in this view.
    ///
    /// - Returns: A view with the default font set to the value you supply.
    func uiTextFieldFont(_ font: UIFont?) -> some View {
        environment(\.uiTextFieldFont, font)
    }
  
    /// Sets the return key type of the keyboard for all ``SUITextField`` in this view.
    ///
    /// - Parameter returnKeyType: The `UIReturnKeyType` to be applied on all ``SUITextField`` in this view.
    /// - Returns: A view with the return key type you supply.
    func uiTextFieldReturnKeyType(_ returnKeyType: UIReturnKeyType) -> some View {
        environment(\.uiReturnKeyType, returnKeyType)
    }

    /// Sets whether or not to hide characters for all ``SUITextField`` in this view.
    ///
    /// - Parameter isEnabled: A bool indicating whether or not to hide characters.
    /// - Returns: A view with the showing/hiding modifier applied.
    func uiTextFieldSecureTextEntry(_ isEnabled: Bool) -> some View {
        environment(\.uiTextFieldSecureTextEntry, isEnabled)
    }

    /// Sets the view mode of the clear button for all ``SUITextField`` in this view.
    ///
    /// By default this value is `.never`.
    ///
    /// - Parameter clearButtonMode: A bool indicating whether or not to hide characters.
    /// - Returns: A view with the clear button mode applied.
    func uiTextFieldClearButtonMode(_ clearButtonMode: UITextField.ViewMode) -> some View {
        environment(\.uiTextFieldClearButtonMode, clearButtonMode)
    }

    /// Sets the border for all ``SUITextField`` in this view.
    ///
    /// - Parameter borderStyle: The `UITextField.BorderStyle` to be applied.
    /// - Returns: A view with the chosen border style applied.
    func uiTextFieldBorderStyle(_ borderStyle: UITextField.BorderStyle) -> some View {
        environment(\.uiTextFieldBorderStyle, borderStyle)
    }

    /// Sets the autocapitalization type for all ``SUITextField`` in this view.
    ///
    /// If the keyboard doesn’t support capitalization, the system  ignores this modifier. See ``SUITextField/uiTextFieldKeyboardType(_:)``.
    ///
    /// - Parameter autocapitalizationType: The `UITextAutocapitalizationType` to be applied.
    /// - Returns: A view with the chosen autocapitalization type applied.
    func uiTextFieldAutocapitalizationType(_ autocapitalizationType: UITextAutocapitalizationType) -> some View {
        environment(\.uiTextAutocapitalizationType, autocapitalizationType)
    }

    /// Sets the autocorrection type for all ``SUITextField`` in this view.
    ///
    /// - Parameter autocorrectionType: The `UITextAutocorrectionType` to be applied.
    /// - Returns: A view with the chosen autocorrection type applied.
    func uiTextFieldAutocorrectionType(_ autocorrectionType: UITextAutocorrectionType) -> some View {
        environment(\.uiTextAutocorrectionType, autocorrectionType)
    }

    /// Sets the keyboard type for all ``SUITextField`` in this view.
    ///
    /// See also ``SUITextField/uiTextFieldAutocapitalizationType(_:)``.
    ///
    /// - Parameter keyboardType: The `UIKeyboardType` to be applied.
    /// - Returns: A view with the chosen autocapitalization type applied.
    func uiTextFieldKeyboardType(_ keyboardType: UIKeyboardType) -> some View {
        environment(\.uiTextFieldKeyboardType, keyboardType)
    }

    /// Sets the text content type for all ``SUITextField`` in this view.
    ///
    /// - Parameter textContentType: The `UITextContentType` to be applied or `nil`.
    /// - Returns: A view with the chosen text content type applied.
    func uiTextFieldTextContentType(_ textContentType: UITextContentType?) -> some View {
        environment(\.uiTextFieldTextContentType, textContentType)
    }

    /// Sets the text alignment for all ``SUITextField`` in this view.
    ///
    /// - Parameter textAlignment: The `NSTextAlignment` to be applied.
    /// - Returns: A view with the chosen text alignment applied.
    func uiTextFieldTextAlignment(_ textAlignment: NSTextAlignment) -> some View {
        environment(\.uiTextFieldTextAlignment, textAlignment)
    }

    /// Sets the left view mode for all ``SUITextField`` in this view.
    ///
    /// This modifier works in conjuction with ``SUITextField/leftView(view:)``.
    ///
    /// - Parameter leftViewMode: The `UITextField.ViewMode` to be applied.
    /// - Returns: A view with the chosen left view mode applied.
    func uiTextFieldTextLeftViewMode(_ leftViewMode: UITextField.ViewMode) -> some View {
        environment(\.uiTextFieldTextLeftViewMode, leftViewMode)
    }

    /// Sets the right view mode for all ``SUITextField`` in this view.
    ///
    /// This modifier works in conjuction with ``SUITextField/rightView(view:)``.
    ///
    /// - Parameter uiTextFieldTextRightViewMode: The `UITextField.ViewMode` to be applied.
    /// - Returns: A view with the chosen right view mode applied.
    func uiTextFieldTextRightViewMode(_ uiTextFieldTextRightViewMode: UITextField.ViewMode) -> some View {
        environment(\.uiTextFieldTextRightViewMode, uiTextFieldTextRightViewMode)
    }

    /// Sets attributes to the generated `NSAttributedString` for all ``SUITextField`` in this view.
    ///
    /// You can style the text/font using this modifier, allowing the text fields to be high customized.
    /// Setting this modifier will override default styling of font, color and text alignment.
    ///
    /// - Parameter defaultTextAttributes: A dictionary of attributes applied to the `NSAttributedString` of text field.
    /// - Returns: A view with the chosen text attributes applied.
    func uiTextFieldDefaultTextAttributes(_ defaultTextAttributes: [NSAttributedString.Key: Any]?) -> some View {
        environment(\.uiTextFieldDefaultTextAttributes, defaultTextAttributes)
    }

    /// Sets the spell checking type for all ``SUITextField`` in this view.
    ///
    /// - Parameter spellCheckingType: The `UITextSpellCheckingType` to be applied.
    /// - Returns: A view with the spell checking type you supply.
    func uiTextFieldSpellCheckingType(_ spellCheckingType: UITextSpellCheckingType) -> some View {
        environment(\.uiTextFieldSpellCheckingType, spellCheckingType)
    }

    /// Sets the password rules for all ``SUITextField`` in this view.
    ///
    /// - Parameter passwordRules: The `UITextInputPasswordRules` to be applied.
    /// - Returns: A view with the password rules you supply.
    func uiTextFieldPasswordRules(_ passwordRules: UITextInputPasswordRules) -> some View {
        environment(\.uiTextFieldPasswordRules, passwordRules)
    }

    /// Sets whether or not all ``SUITextField`` in this view should resize text based on text field width.
    ///
    /// - Parameter fontSizeWidthAdjustment: The ``FontSizeWidthAdjustment`` to be applied.
    /// - Returns: A view with the adjustment behavior you supply.
    func uiTextFieldAdjustsFontSizeToFitWidth(_ fontSizeWidthAdjustment: FontSizeWidthAdjustment) -> some View {
        environment(\.uiTextFieldAdjustsFontSizeToFitWidth, fontSizeWidthAdjustment)
    }
    
}
