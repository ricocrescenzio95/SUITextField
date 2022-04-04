//
//  SUITextField.swift
//
//
//  Created by Rico Crescenzio on 31/03/22.
//

import SwiftUI
import UIKit
import Combine

/// A `SwiftUI` wrapper of `UITextField` that enable more control and customization.
///
/// For example this text field allows to set an input view or an input accessory view. Also it allows to set
/// a left view and a right view like any other `UITextField`.
///
/// By using ``ResponderState``, you can enable responder navigation through states.
public struct SUITextField<InputView, InputAccessoryView, LeftView, RightView>: UIViewRepresentable
where InputView: View, InputAccessoryView: View, LeftView: View, RightView: View {

    // MARK: - Properties

    @Binding private var text: String
    private var placeholder: String?
    private var autoSizeInputView: Bool
    private var inputView: InputView
    private var inputAccessoryView: InputAccessoryView
    private var leftView: LeftView
    private var rightView: RightView

    private var makeProxy: (UITextField) -> Void = { _ in }
    private var updateProxy: (UITextField) -> Void = { _ in }
    private var shouldBeginEditingAction: () -> Bool = { true }
    private var shouldEndEditingAction: () -> Bool = { true }
    private var shouldClearAction: () -> Bool = { true }
    private var onBeginEditingAction: () -> Void = {}
    private var onEndEditingAction: (UITextField.DidEndEditingReason) -> Void = { _ in }
    private var onReturnKeyPressedAction: () -> Void = {}
    private var onSelectionChangedAction: (UITextField) -> Void = { _ in }

    private var shouldChangeCharactersInAction: (_ originString: String,
                                                 _ range: NSRange,
                                                 _ string: String) -> Bool = { _, _, _ in true }

    // MARK: - Initializers

    public init(text: Binding<String>, placeholder: String? = nil)
    where InputView == EmptyView, InputAccessoryView == EmptyView, LeftView == EmptyView, RightView == EmptyView {
        self._text = text
        self.placeholder = placeholder
        inputView = EmptyView()
        inputAccessoryView = EmptyView()
        leftView = EmptyView()
        rightView = EmptyView()
        autoSizeInputView = false
    }

    init(
        text: Binding<String>,
        placeholder: String? = nil,
        autoSizeInputView: Bool,
        @ViewBuilder leftView: () -> LeftView,
        @ViewBuilder rightView: () -> RightView,
        @ViewBuilder inputView: () -> InputView,
        @ViewBuilder inputAccessoryView: () -> InputAccessoryView
    ) {
        self._text = text
        self.placeholder = placeholder
        self.autoSizeInputView = autoSizeInputView
        self.leftView = leftView()
        self.rightView = rightView()
        self.inputView = inputView()
        self.inputAccessoryView = inputAccessoryView()
    }

}

// MARK: - Modifiers

public extension SUITextField where InputAccessoryView == EmptyView {

    /// Attaches an input accessory view to this text field.
    ///
    /// When the text field becomes first responder, it shows a view on top
    /// of the keyboard or bottom of the window if no software keyboard is shown (i.e in iPads).
    ///
    /// ```swift
    /// var body: some View {
    ///     SUITextField(text: $text)
    ///         .inputAccessoryView {
    ///             MyCustomBar()
    ///         }
    /// }
    /// ```
    ///
    /// - Note: This api restricts the number of `inputAccessoryView` modifier to 1 (since a text field
    /// can have 1 and only 1 accessory view at same time). This means that if you try to apply 2 times this modifier
    /// the compiler will throw an error.
    ///
    /// - Parameter view: A `@ViewBuilder` that returns the view to be shown.
    ///
    /// - Returns: The modified text field.
    func inputAccessoryView<Content>(
        @ViewBuilder view: () -> Content
    ) -> SUITextField<InputView, Content, LeftView, RightView> where Content: View {
        SUITextField<InputView, Content, LeftView, RightView>(
            text: $text,
            placeholder: placeholder,
            autoSizeInputView: autoSizeInputView,
            leftView: { leftView },
            rightView: { rightView },
            inputView: { inputView },
            inputAccessoryView: view
        )
    }

}

public extension SUITextField where InputView == EmptyView {

    /// Attaches an input view to this text field.
    ///
    /// When the text field becomes first responder, it shows a view instead of the default software keyboard.
    ///
    /// ```swift
    /// var body: some View {
    ///     SUITextField(text: $text)
    ///         .inputView(autoSize: true) { // you can omit autoSize, true by default
    ///             MyCustomKeyboard()
    ///         }
    /// }
    /// ```
    ///
    /// - Note: This api restricts the number of `inputView` modifier to 1 (since a text field
    /// can have 1 and only 1 input view at same time). This means that if you try to apply 2 times this modifier
    /// the compiler will throw an error.
    ///
    /// - Parameter autoSize: When `true`, the size of the container of the view is sized according to the view size itself.
    /// When `false`, the size of the container is decided by the system (it is usually the default keyboard container size). Default is `true`.
    ///
    /// - Parameter view: A `@ViewBuilder` that returns the view to be shown.
    ///
    /// - Returns: The modified text field.
    func inputView<Content>(
        autoSize: Bool = true,
        @ViewBuilder view: () -> Content
    ) -> SUITextField<Content, InputAccessoryView, LeftView, RightView> where Content: View {
        SUITextField<Content, InputAccessoryView, LeftView, RightView>(
            text: $text,
            placeholder: placeholder,
            autoSizeInputView: autoSize,
            leftView: { leftView },
            rightView: { rightView },
            inputView: view,
            inputAccessoryView: { inputAccessoryView }
        )
    }

}

public extension SUITextField where LeftView == EmptyView {

    /// Attaches a left view to this text field.
    ///
    /// This example insert a left view into the text field that allows the user to clear all text.
    ///
    /// ```swift
    /// var body: some View {
    ///     SUITextField(text: $text)
    ///         .leftView {
    ///             Button(action: { text = "" }) {
    ///                 Image(systemName: "trash")
    ///             }
    ///         }
    ///         .uiTextFieldTextLeftViewMode(.whileEditing)
    /// }
    /// ```
    /// - Important: `uiTextFieldTextLeftViewMode` should not be set to `.never` to show the view.
    ///
    /// - Note: This api restricts the number of `leftView` modifier to 1 (since a text field
    /// can have 1 and only 1 left view at same time). This means that if you try to apply 2 times this modifier
    /// the compiler will throw an error.
    ///
    /// - Parameter view: A `@ViewBuilder` that returns the view to be shown.
    ///
    /// - Returns: The modified text field.
    func leftView<Content>(
        @ViewBuilder view: () -> Content
    ) -> SUITextField<InputView, InputAccessoryView, Content, RightView> where Content: View {
        SUITextField<InputView, InputAccessoryView, Content, RightView>(
            text: $text,
            placeholder: placeholder,
            autoSizeInputView: autoSizeInputView,
            leftView: view,
            rightView: { rightView },
            inputView: { inputView },
            inputAccessoryView: { inputAccessoryView }
        )
    }

}

public extension SUITextField where RightView == EmptyView {

    /// Attaches a right view to this text field.
    ///
    /// This example insert a right view into the text field that allows the user to clear all text.
    ///
    /// ```swift
    /// var body: some View {
    ///     SUITextField(text: $text)
    ///         .rightView {
    ///             Button(action: { text = "" }) {
    ///                 Image(systemName: "trash")
    ///             }
    ///         }
    ///         .uiTextFieldTextRightViewMode(.whileEditing)
    /// }
    /// ```
    /// - Important: `uiTextFieldTextRightViewMode` should not be set to `.never` to show the view.
    ///
    /// - Note: This api restricts the number of `rightView` modifier to 1 (since a text field
    /// can have 1 and only 1 right view at same time). This means that if you try to apply 2 times this modifier
    /// the compiler will throw an error.
    ///
    /// - Parameter view: A `@ViewBuilder` that returns the view to be shown.
    ///
    /// - Returns: The modified text field.
    func rightView<Content>(
        @ViewBuilder view: () -> Content
    ) -> SUITextField<InputView, InputAccessoryView, LeftView, Content> where Content: View {
        SUITextField<InputView, InputAccessoryView, LeftView, Content>(
            text: $text,
            placeholder: placeholder,
            autoSizeInputView: autoSizeInputView,
            leftView: { leftView },
            rightView: view,
            inputView: { inputView },
            inputAccessoryView: { inputAccessoryView }
        )
    }

}

public extension SUITextField {

    private func apply<T>(value: T, to path: WritableKeyPath<Self, T>) -> Self {
        var view = self
        view[keyPath: path] = value
        return view
    }

    /// Called when the underlying `UITextField` has been created.
    ///
    /// You can use this proxy to apply all changes you need when the text field is created.
    ///
    /// - Important: You should use this modifier to customize the underlying `UITextField` only
    /// if there's no `SUITextField` modifier for your purpose. Avoid customizing everything in this
    /// proxy method.
    ///
    /// - Parameter action: A block executed after the text field is created.
    /// - Returns: The modified text field.
    func onCreate(_ action: @escaping (UITextField) -> Void) -> Self {
        apply(value: action, to: \.makeProxy)
    }

    /// Called every time the underlying `UITextField` needs to update its values.
    ///
    /// You can use this proxy to apply all changes you need when a state has changed.
    ///
    /// - Important: Since this function is called during a state update, you should be sure
    /// to avoid modifying the state, for instance by using `DispatchQueue.main.async`.
    /// `SwiftUI` will emit a runtime warning, in case.
    ///
    /// - Parameter action: A block executed after the text field is created.
    /// - Returns: The modified text field.
    func onUpdate(_ action: @escaping (UITextField) -> Void) -> Self {
        apply(value: action, to: \.updateProxy)
    }

    /// Called when the text field is about to start editing.
    ///
    /// Returning `false` doesn't allow the text field to start editing.
    ///
    /// - Parameter action: A block that is executed before the text field become first responder.
    /// You return `true`/`false` to tell the text field if it can become or not the first responder.
    ///
    /// - Returns: The modified text field.
    func shouldBeginEditingAction(_ action: @escaping () -> Bool) -> Self {
        apply(value: action, to: \.shouldBeginEditingAction)
    }

    /// Called when the text field is about to end editing.
    ///
    /// Returning `false` doesn't allow the text field to end editing.
    ///
    /// - Parameter action: A block that is executed before the text field resign first responder.
    /// You return `true`/`false` to tell the text field if it can resign or not the first responder.
    ///
    /// - Returns: The modified text field.
    func shouldEndEditingAction(_ action: @escaping () -> Bool) -> Self {
        apply(value: action, to: \.shouldEndEditingAction)
    }

    /// Called when the text field is about to clear its text content.
    ///
    /// Returning `false` doesn't allow the text field to clear the content.
    ///
    /// - Parameter action: A block that is executed before the text field clears its content.
    /// You return `true`/`false` to tell the text field if it can clear or not the content.
    ///
    /// - Returns: The modified text field.
    func shouldClearAction(_ action: @escaping () -> Bool) -> Self {
        apply(value: action, to: \.shouldClearAction)
    }

    /// Called when the text field become first responder.
    ///
    /// - Parameter action: A block that is executed after the text field become first responder.
    ///
    /// - Returns: The modified text field.
    func onBeginEditing(_ action: @escaping () -> Void) -> Self {
        apply(value: action, to: \.onBeginEditingAction)
    }

    /// Called when the text field resign first responder.
    ///
    /// - Parameter action: A block that is executed after the text field resign first responder.
    ///
    /// - Returns: The modified text field.
    func onEndEditing(_ action: @escaping (UITextField.DidEndEditingReason) -> Void) -> Self {
        apply(value: action, to: \.onEndEditingAction)
    }

    /// Called when the return key is pressed.
    ///
    /// - Parameter action: A block that is executed when the return key is pressed.
    ///
    /// - Returns: The modified text field.
    func onReturnKeyPressed(_ action: @escaping () -> Void) -> Self {
        apply(value: action, to: \.onReturnKeyPressedAction)
    }

    /// Called when the selected text into the text field is changed.
    ///
    /// - Parameter action: A block that is executed when the selected text is changed.
    /// The block provides you the underlying `UITextField` so you can inspect it.
    ///
    /// - Important: Although the block gives you the underlying `UITextField`, you shouldn't directly mutate it.
    /// You should use only to **get** information you need.
    ///
    /// - Returns: The modified text field.
    func onSelectionChanged(_ action: @escaping (UITextField) -> Void) -> Self {
        apply(value: action, to: \.onSelectionChangedAction)
    }

    func shouldChangeCharacters(
        _ action: @escaping (_ originString: String,
                             _ range: NSRange,
                             _ string: String) -> Bool
    ) -> Self {
        apply(value: action, to: \.shouldChangeCharactersInAction)
    }

}

// MARK: - UIViewRepresentable

public extension SUITextField {

    func makeUIView(context: Context) -> UITextField {
        let textField = _SUITextField()
        textField.setContentHuggingPriority(.required, for: .vertical)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.delegate = context.coordinator

        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.editingChanged),
            for: .editingChanged
        )

        context.coordinator.onMakeUIView(textField, with: context)

        if LeftView.self != EmptyView.self {
            context.coordinator.leftView = .init(rootView: leftView)
            context.coordinator.leftView?.view.backgroundColor = .clear
            textField.leftView = context.coordinator.leftView?.view
        }

        if RightView.self != EmptyView.self {
            context.coordinator.rightView = .init(rootView: rightView)
            context.coordinator.rightView?.view.backgroundColor = .clear
            textField.rightView = context.coordinator.rightView?.view
        }

        makeProxy(textField)

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        func applyIfDifferent<V>(value: V, at keyPath: ReferenceWritableKeyPath<UITextField, V>) where V: Equatable {
            if uiView[keyPath: keyPath] != value {
                uiView[keyPath: keyPath] = value
            }
        }
        uiView.text = text
        applyIfDifferent(value: placeholder, at: \.placeholder)
        applyIfDifferent(value: context.environment.uiFont, at: \.font)
        applyIfDifferent(value: context.environment.uiReturnKeyType, at: \.returnKeyType)
        applyIfDifferent(value: context.environment.uiTextFieldSecureTextEntry, at: \.isSecureTextEntry)
        applyIfDifferent(value: context.environment.uiTextFieldClearButtonMode, at: \.clearButtonMode)
        applyIfDifferent(value: context.environment.uiTextFieldBorderStyle, at: \.borderStyle)
        applyIfDifferent(value: context.environment.uiTextAutocorrectionType, at: \.autocorrectionType)
        applyIfDifferent(value: context.environment.uiTextAutocapitalizationType, at: \.autocapitalizationType)
        applyIfDifferent(value: context.environment.uiTextFieldTextContentMode, at: \.textContentType)
        applyIfDifferent(value: context.environment.uiTextFieldKeyboardType, at: \.keyboardType)
        applyIfDifferent(value: context.environment.uiTextFieldTextAlignment, at: \.textAlignment)
        applyIfDifferent(value: context.environment.uiTextFieldTextLeftViewMode, at: \.leftViewMode)
        applyIfDifferent(value: context.environment.uiTextFieldTextRightViewMode, at: \.rightViewMode)
        applyIfDifferent(value: context.environment.isEnabled, at: \.isEnabled)

        DispatchQueue.main.async {
            context.coordinator.inputViewController?.rootView = inputView
            context.coordinator.inputAccessoryViewController?.rootView = inputAccessoryView

            context.coordinator.leftView?.rootView = leftView
            context.coordinator.rightView?.rootView = rightView
        }

        updateProxy(uiView)
    }

    static func dismantleUIView(_ uiView: UITextField, coordinator: Coordinator) {
        uiView.resignFirstResponder()
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    // MARK: - Coordinator

    /// The coordinator class that is responsible to bridge the `UITextField` into `SwiftUI`.
    final class Coordinator: ResponderChainCoordinator, UITextFieldDelegate  {

        private let uiKitTextField: SUITextField
        var inputViewController: SUIInputViewController<InputView>?
        var inputAccessoryViewController: SUIInputViewController<InputAccessoryView>?
        var leftView: UIHostingController<LeftView>?
        var rightView: UIHostingController<RightView>?

        init(_ uiKitTextField: SUITextField) {
            self.uiKitTextField = uiKitTextField

            super.init()
        }

        @objc func editingChanged(_ textField: UITextField) {
            uiKitTextField.text = textField.text ?? ""
        }

        private func applyCustomViews(to textField: UITextField) {
            if InputView.self != EmptyView.self {
                inputViewController = SUIInputViewController<InputView>()
                inputViewController?.allowSelfSizing = uiKitTextField.autoSizeInputView
                inputViewController?.controller = .init(rootView: uiKitTextField.inputView)
                (textField as! _SUITextField).inputViewController = inputViewController
            }
            if InputAccessoryView.self != EmptyView.self {
                inputAccessoryViewController = SUIInputViewController<InputAccessoryView>()
                inputAccessoryViewController?.controller = .init(rootView: uiKitTextField.inputAccessoryView)
                (textField as! _SUITextField).inputAccessoryViewController = inputAccessoryViewController
            }
        }

        private func removeCustomViews(to textField: UITextField) {
            (textField as! _SUITextField).inputViewController = nil
            (textField as! _SUITextField).inputAccessoryViewController = nil
            inputViewController = nil
            inputAccessoryViewController = nil
        }

        // MARK: - UITextFieldDelegate

        public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { uiKitTextField.shouldBeginEditingAction() }

        public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { uiKitTextField.shouldEndEditingAction() }

        public func textFieldShouldClear(_ textField: UITextField) -> Bool { uiKitTextField.shouldClearAction() }

        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            uiKitTextField.shouldChangeCharactersInAction(textField.text ?? "", range, string)
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            applyCustomViews(to: textField)
            onViewBecomeFirstResponder()
            uiKitTextField.onBeginEditingAction()
        }

        public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            removeCustomViews(to: textField)
            onViewResignFirstResponder()
            uiKitTextField.onEndEditingAction(reason)
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            uiKitTextField.onReturnKeyPressedAction()
            return false
        }

        public func textFieldDidChangeSelection(_ textField: UITextField) {
            uiKitTextField.onSelectionChangedAction(textField)
        }

    }

}
