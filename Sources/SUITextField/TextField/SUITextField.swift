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
    private var inputView: InputView
    private var inputAccessoryView: InputAccessoryView
    private var leftView: LeftView
    private var rightView: RightView

    private var shouldBeginEditingAction: () -> Bool = { true }
    private var shouldEndEditingAction: () -> Bool = { true }
    private var shouldClearAction: () -> Bool = { true }
    private var onBeginEditingAction: () -> Void = {}
    private var onEndEditingAction: (UITextField.DidEndEditingReason) -> Void = { _ in }
    private var onReturnKeyPressedAction: () -> Void = {}
    private var onSelectionChangedAction: (UITextRange?) -> Void = { _ in }

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
    }

    init(
        text: Binding<String>,
        placeholder: String? = nil,
        @ViewBuilder leftView: () -> LeftView,
        @ViewBuilder rightView: () -> RightView,
        @ViewBuilder inputView: () -> InputView,
        @ViewBuilder inputAccessoryView: () -> InputAccessoryView
    ) {
        self._text = text
        self.placeholder = placeholder
        self.leftView = leftView()
        self.rightView = rightView()
        self.inputView = inputView()
        self.inputAccessoryView = inputAccessoryView()
    }

}

// MARK: - Modifiers

public extension SUITextField where InputAccessoryView == EmptyView {

    func inputAccessoryView<Content>(
        @ViewBuilder _ view: () -> Content
    ) -> SUITextField<InputView, Content, LeftView, RightView> where Content: View {
        SUITextField<InputView, Content, LeftView, RightView>(
            text: $text,
            placeholder: placeholder,
            leftView: { leftView },
            rightView: { rightView },
            inputView: { inputView },
            inputAccessoryView: view
        )
    }

}

public extension SUITextField where InputView == EmptyView {

    func inputView<Content>(
        @ViewBuilder _ view: () -> Content
    ) -> SUITextField<Content, InputAccessoryView, LeftView, RightView> where Content: View {
        SUITextField<Content, InputAccessoryView, LeftView, RightView>(
            text: $text,
            placeholder: placeholder,
            leftView: { leftView },
            rightView: { rightView },
            inputView: view,
            inputAccessoryView: { inputAccessoryView }
        )
    }

}

public extension SUITextField where LeftView == EmptyView {

    func leftView<Content>(
        @ViewBuilder _ view: () -> Content
    ) -> SUITextField<InputView, InputAccessoryView, Content, RightView> where Content: View {
        SUITextField<InputView, InputAccessoryView, Content, RightView>(
            text: $text,
            placeholder: placeholder,
            leftView: view,
            rightView: { rightView },
            inputView: { inputView },
            inputAccessoryView: { inputAccessoryView }
        )
    }

}

public extension SUITextField where RightView == EmptyView {

    func rightView<Content>(
        @ViewBuilder _ view: () -> Content
    ) -> SUITextField<InputView, InputAccessoryView, LeftView, Content> where Content: View {
        SUITextField<InputView, InputAccessoryView, LeftView, Content>(
            text: $text,
            placeholder: placeholder,
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

    func shouldBeginEditingAction(_ action: @escaping () -> Bool) -> Self {
        apply(value: action, to: \.shouldBeginEditingAction)
    }

    func shouldEndEditingAction(_ action: @escaping () -> Bool) -> Self {
        apply(value: action, to: \.shouldEndEditingAction)
    }

    func shouldClearAction(_ action: @escaping () -> Bool) -> Self {
        apply(value: action, to: \.shouldClearAction)
    }

    func onBeginEditing(_ action: @escaping () -> Void) -> Self {
        apply(value: action, to: \.onBeginEditingAction)
    }

    func onEndEditing(_ action: @escaping (UITextField.DidEndEditingReason) -> Void) -> Self {
        apply(value: action, to: \.onEndEditingAction)
    }

    func onReturnKeyPressed(_ action: @escaping () -> Void) -> Self {
        apply(value: action, to: \.onReturnKeyPressedAction)
    }

    func onSelectionChanged(_ action: @escaping (UITextRange?) -> Void) -> Self {
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

        context.coordinator.responderStorage = context.environment.responderStorage
        context.coordinator.responderValue = context.environment.responderValue

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

        guard let value = context.environment.responderValue else {
            context.coordinator.cancellable = nil
            return textField
        }

        let applyResponder = { (isFirstResponder: Bool) -> Void in
            if isFirstResponder && !textField.isFirstResponder {
                DispatchQueue.main.async {
                    textField.becomeFirstResponder()
                }
            } else if !isFirstResponder && textField.isFirstResponder {
                DispatchQueue.main.async {
                    textField.resignFirstResponder()
                }
            }
        }
        if let responderStorage = context.environment.responderStorage as? BoolResponderStorage {
            context.coordinator.cancellable = responderStorage.$value
                .sink(receiveValue: { selectedValue in
                    applyResponder(selectedValue)
                })
        } else if let responderStorage = context.environment.responderStorage as? AnyHashableResponderStorage {
            context.coordinator.cancellable = responderStorage.$value
                .compactMap { $0 as? Hashable }
                .sink(receiveValue: { selectedValue in
                    applyResponder(value.hashValue == selectedValue.hashValue)
                })
        }

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        func applyIfDifferent<V>(value: V, at keyPath: ReferenceWritableKeyPath<UITextField, V>) where V: Equatable {
            if uiView[keyPath: keyPath] != value {
                uiView[keyPath: keyPath] = value
            }
        }
        applyIfDifferent(value: text, at: \.text)
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
    }

    static func dismantleUIView(_ uiView: UITextField, coordinator: Coordinator) {
        uiView.resignFirstResponder()
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    // MARK: - Coordinator

    final class Coordinator: NSObject, UITextFieldDelegate {

        private let uiKitTextField: SUITextField
        var inputViewController: SUIInputViewController<InputView>?
        var inputAccessoryViewController: SUIInputViewController<InputAccessoryView>?
        var leftView: UIHostingController<LeftView>?
        var rightView: UIHostingController<RightView>?
        var responderValue: AnyHashable?
        weak var responderStorage: ResponderStorage?
        var cancellable: AnyCancellable?

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
            if responderStorage?.erasedValue != responderValue {
                responderStorage?.erasedValue = responderValue
            }
            uiKitTextField.onBeginEditingAction()
        }

        public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            removeCustomViews(to: textField)
            if responderStorage?.erasedValue == responderValue {
                if let responderStorage = responderStorage as? BoolResponderStorage {
                    responderStorage.value = false
                } else if let responderStorage = responderStorage as? AnyHashableResponderStorage {
                    responderStorage.value = responderStorage.defaultValue
                }
            }
            uiKitTextField.onEndEditingAction(reason)
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            uiKitTextField.onReturnKeyPressedAction()
            return false
        }

        public func textFieldDidChangeSelection(_ textField: UITextField) {
            uiKitTextField.onSelectionChangedAction(textField.selectedTextRange)
        }

    }

}
