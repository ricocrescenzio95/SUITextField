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
        get { uiTextFieldDefaultTextAttributes?[.font] as? UIFont }
        set {
            if var attributes = uiTextFieldDefaultTextAttributes {
                attributes[.font] = newValue?.copy()
                uiTextFieldDefaultTextAttributes = attributes
            } else if let newValue = newValue {
                uiTextFieldDefaultTextAttributes = [.font: newValue.copy()]
            } else {
                uiTextFieldDefaultTextAttributes = nil
            }
        }
    }
    
    /// The `UIColor` of ``SUITextField``, applied using ``SUITextField/uiTextFieldFont(_:)``.
    var uiTextFieldTextColor: UIColor? {
        get { uiTextFieldDefaultTextAttributes?[.foregroundColor] as? UIColor }
        set {
            if var attributes = uiTextFieldDefaultTextAttributes {
                attributes[.foregroundColor] = newValue?.copy()
                uiTextFieldDefaultTextAttributes = attributes
            } else if let newValue = newValue {
                uiTextFieldDefaultTextAttributes = [.foregroundColor: newValue.copy()]
            } else {
                uiTextFieldDefaultTextAttributes = nil
            }
        }
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
    var uiTextFieldTextAlignment: NSTextAlignment? {
        get { (uiTextFieldDefaultTextAttributes?[.paragraphStyle] as? NSParagraphStyle)?.alignment }
        set {
            if var attributes = uiTextFieldDefaultTextAttributes {
                let paragraphStyle = (attributes[.paragraphStyle] as? NSParagraphStyle)?
                    .mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
                paragraphStyle.alignment = newValue ?? .left
                attributes[.paragraphStyle] = paragraphStyle
                uiTextFieldDefaultTextAttributes = attributes
            } else if let newValue = newValue {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = newValue
                uiTextFieldDefaultTextAttributes = [.paragraphStyle: paragraphStyle]
            } else {
                uiTextFieldDefaultTextAttributes = nil
            }
        }
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
    /// applied using ``SUITextField/uiTextFieldDefaultTextAttributes(_:mergePolicy:)``.
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
    /// Setting `nil` will restore the system font.
    ///
    /// - Note: This modifier overrides font in ``SUITextField/uiTextFieldDefaultTextAttributes(_:mergePolicy:)``
    ///
    /// - Parameter font: The default font to use in this view.
    /// - Returns: A view with the default font set to the value you supply.
    func uiTextFieldFont(_ font: UIFont?) -> some View {
        environment(\.uiTextFieldFont, font)
    }
    
    /// Sets the text color for all ``SUITextField`` in this view.
    ///
    /// Setting `nil` will restore the system color.
    ///
    /// - Note: This modifier has higher priority than ``SUITextField/uiTextFieldDefaultTextAttributes(_:mergePolicy:)``
    ///
    /// - Parameter color: The `UIColor` to be applied on all ``SUITextField`` in this view.
    /// - Returns: A view with the text color you supply.
    func uiTextFieldTextColor(_ color: UIColor?) -> some View {
        environment(\.uiTextFieldTextColor, color)
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
    /// - Note: This modifier has higher priority than ``SUITextField/uiTextFieldDefaultTextAttributes(_:mergePolicy:)``
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
    ///
    /// - Note: This modifier has low priority than font, color and text alignment modifiers.
    ///
    /// - Parameters:
    ///   - defaultTextAttributes: A dictionary of attributes applied to the `NSAttributedString` of text field.
    ///   - mergePolicy: Indicates how apply the new attributes. If you used this modifier in a container view and you
    ///   want to apply more styling, you can decided if the new style will merge with the old one and keep either new or old values
    ///   for same key (using ``DefaultAttributesMergePolicy/keepNew`` and ``DefaultAttributesMergePolicy/keepOld``).
    ///   If you want to apply **only** the new style and get rid of the old one,
    ///   use ``DefaultAttributesMergePolicy/rewriteAll``. Default is ``DefaultAttributesMergePolicy/rewriteAll``
    /// - Returns: A view with the chosen text attributes applied.
    func uiTextFieldDefaultTextAttributes(
        _ defaultTextAttributes: [NSAttributedString.Key: Any]?,
        mergePolicy: DefaultAttributesMergePolicy = .rewriteAll
    ) -> some View {
        transformEnvironment(\.uiTextFieldDefaultTextAttributes) { attributes in
            var newAttributes = attributes
            switch mergePolicy {
            case .keepOld:
                if let defaultTextAttributes = defaultTextAttributes {
                    newAttributes = (newAttributes ?? [:]).merging(defaultTextAttributes) { old, new in old }
                }
            case .keepNew:
                if let defaultTextAttributes = defaultTextAttributes {
                    newAttributes = (newAttributes ?? [:]).merging(defaultTextAttributes) { old, new in new }
                }
            case .rewriteAll: newAttributes = defaultTextAttributes
            }
            attributes = newAttributes
        }
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
    /// - Parameter fontSizeWidthAdjustment: The ``SwiftUITextField/FontSizeWidthAdjustment`` to be applied.
    /// - Returns: A view with the adjustment behavior you supply.
    ///
    /// - Note: When using ``SUITextField/uiTextFieldDefaultTextAttributes(_:mergePolicy:)``
    /// this modifier is ignored by the underlying `UITextField`.
    func uiTextFieldAdjustsFontSizeToFitWidth(_ fontSizeWidthAdjustment: FontSizeWidthAdjustment) -> some View {
        environment(\.uiTextFieldAdjustsFontSizeToFitWidth, fontSizeWidthAdjustment)
    }
    
}
