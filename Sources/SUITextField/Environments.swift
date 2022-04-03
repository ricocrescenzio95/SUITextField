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

}

public extension View {

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

}
