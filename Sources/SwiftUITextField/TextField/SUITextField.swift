//
//  SUITextField.swift
//
//
//  Created by Rico Crescenzio on 31/03/22.
//

import SwiftUI
import UIKit
import Combine

/// A SwiftUI wrapper of `UITextField` that enable more control and customization.
///
/// You create a text field with a placeholder and a binding to a value. If the value is a string,
/// the text field updates this value continuously as the user types or otherwise edits the text in the field.
/// For non-string types (only available on `iOS 15`), it updates the value on each change.
///
/// The following example shows a text field to accept a username, and a `Text` view below it that shadows
/// the continuously updated value of username. The Text view changes color as the user begins and ends editing.
/// When the user submits their completed entry to the text field, the `onReturnKeyPressed(_:)` modifier execute the `validate(name:)`
///
///```swift
///@State private var username: String = ""
///@ResponderState private var emailFieldIsFocused: Bool = false
///
///var body: some View {
///    SUITextField(
///        text: $username,
///        placeholder: "User name (email address)"
///    )
///    .responder($emailFieldIsFocused)
///    .onReturnKeyPressed {
///        validate(name: username)
///    }
///
///    Text(username)
///        .foregroundColor(emailFieldIsFocused ? .red : .blue)
///}
///```
///
/// **iOS 15 only**
///
/// The bound value doesn’t have to be a string. By using a `FormatStyle`, you can bind the text field to a nonstring type,
/// using the format style to convert the typed text into an instance of the bound type.
/// The following example uses a `PersonNameComponents.FormatStyle` to convert the name typed in the text field to
/// a `PersonNameComponents` instance. A Text view below the text field shows the debug description string of this instance.
///
///```swift
///@State private var nameComponents = PersonNameComponents()
///
///var body: some View {
///    SUITextField(
///        value: $nameComponents,
///        format: .name(style: .medium)
///        placeholder: "Proper name"
///    )
///    .onReturnKeyPressed {
///        validate(components: nameComponents)
///    }
///    Text(nameComponents.debugDescription)
///}
///```
///
/// **Styling Text Fields**
///
/// All available style and behavior modifiers can be applied to any view that contains one or more `SUITextField`.
/// This enables you to customize at higher view hierarchy level all text fields to keep the style consistent.
/// As any other modifier, you can apply further customization at lower level.
///
///```swift
///@State private var givenName: String = ""
///@State private var familyName: String = ""
///
///var body: some View {
///    VStack {
///        SUITextField(
///            text: $givenName,
///            placeholder: "Given name"
///        )
///        .uiTextFieldAutocorrectionType(.no)
///        SUITextField(
///            text: $familyName,
///            placeholder: "Family name"
///        )
///        .uiTextFieldAutocorrectionType(.no)
///    }
///    .uiTextFieldBorderStyle(.roundedRect)
///}
///```
///
/// Check <doc:EnvironmentModifiers> for the list of environment modifiers.
public struct SUITextField<InputView, InputAccessoryView, LeftView, RightView>: UIViewRepresentable
where InputView: View, InputAccessoryView: View, LeftView: View, RightView: View {

    // MARK: - Properties

    @Binding private var text: String
    private var placeholder: TextType?
    private var autoSizeInputView: Bool
    private var inputView: InputView
    private var inputAccessoryView: InputAccessoryView
    private var leftView: LeftView
    private var rightView: RightView

    private var makeProxy: ((UITextField) -> Void)? = nil
    private var updateProxy: ((UITextField) -> Void)? = nil
    private var shouldBeginEditingAction: (() -> Bool)? = nil
    private var shouldEndEditingAction: (() -> Bool)? = nil
    private var shouldClearAction: (() -> Bool)? = nil
    private var onBeginEditingAction: (() -> Void)? = nil
    private var onEndEditingAction: ((UITextField.DidEndEditingReason) -> Void)? = nil
    private var onReturnKeyPressedAction: (() -> Void)? = nil
    private var onSelectionChangedAction: ((UITextField) -> Void)? = nil
    private var shouldChangeCharactersInAction: ((CharacterReplacement) -> Bool)? = nil

    init(
        text: Binding<String>,
        placeholder: TextType? = nil,
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

// MARK: - Initializers

public extension SUITextField {

    /// Creates a text field with given bound text and a plain placeholder.
    /// - Parameters:
    ///   - text: The text binding.
    ///   - placeholder: A plain placeholder string.
    init(text: Binding<String>, placeholder: String? = nil)
    where InputView == EmptyView, InputAccessoryView == EmptyView, LeftView == EmptyView, RightView == EmptyView {
        self.init(
            text: text,
            placeholder: placeholder.map { .plain($0) },
            autoSizeInputView: false,
            leftView: { EmptyView() },
            rightView: { EmptyView() },
            inputView: { EmptyView() },
            inputAccessoryView: { EmptyView() }
        )
    }

    /// Creates a text field with given bound text and an attributed placeholder.
    /// - Parameters:
    ///   - text: The text binding.
    ///   - placeholder: An attributed placeholder using `NSAttributedString`.
    init(text: Binding<String>, placeholder: NSAttributedString)
    where InputView == EmptyView, InputAccessoryView == EmptyView, LeftView == EmptyView, RightView == EmptyView {
        self.init(
            text: text,
            placeholder: .attributed(placeholder),
            autoSizeInputView: false,
            leftView: { EmptyView() },
            rightView: { EmptyView() },
            inputView: { EmptyView() },
            inputAccessoryView: { EmptyView() }
        )
    }

}

@available(iOS 15, *)
public extension SUITextField {

    /// Creates a text field with given bound text and an attributed placeholder.
    /// - Parameters:
    ///   - text: The text binding.
    ///   - placeholder: An attributed placeholder using `AttributedString`
    init(text: Binding<String>, placeholder: AttributedString)
    where InputView == EmptyView, InputAccessoryView == EmptyView, LeftView == EmptyView, RightView == EmptyView {
        self.init(text: text, placeholder: .init(placeholder))
    }

    private init<F>(value: Binding<F.FormatInput>, format: F, placeholder: TextType? = nil, defaultValue: F.FormatInput? = nil)
    where F: ParseableFormatStyle, F.FormatOutput == String, InputView == EmptyView,
    InputAccessoryView == EmptyView, LeftView == EmptyView, RightView == EmptyView {
        let binding = Binding<String>.init {
            format.format(value.wrappedValue)
        } set: { newValue in
            guard let newValue = (try? format.parseStrategy.parse(newValue)) ?? defaultValue else { return }
            value.wrappedValue = newValue
        }
        self.init(
            text: binding,
            placeholder: placeholder,
            autoSizeInputView: false,
            leftView: { EmptyView() },
            rightView: { EmptyView() },
            inputView: { EmptyView() },
            inputAccessoryView: { EmptyView() }
        )
    }

    /// Creates a text field that applies a format style to a bound value and a plain placeholder.
    ///
    /// Use this initializer to create a text field that binds to a bound value, using a `ParseableFormatStyle` to convert to and from this type.
    /// Changes to the bound value update the string displayed by the text field.
    /// Editing the text field updates the bound value, as long as the format style can parse the text.
    /// If the format style can’t parse the input, the bound value remains unchanged.
    ///
    /// The following example uses a Double as the bound value, and a `FloatingPointFormatStyle`
    /// instance to convert to and from a string representation. As the user types, the bound value updates,
    /// which in turn updates three `Text` views that use different format styles.
    /// If the user enters text that doesn’t represent a valid `Double`, the bound value doesn’t update.
    ///
    ///```swift
    ///@State private var myDouble: Double = 0.673
    ///var body: some View {
    ///    VStack {
    ///        SUITextField(
    ///            value: $myDouble,
    ///            format: .number
    ///        )
    ///        Text(myDouble, format: .number)
    ///        Text(myDouble, format: .number.precision(.significantDigits(5)))
    ///        Text(myDouble, format: .number.notation(.scientific))
    ///    }
    ///}
    ///```
    /// - Parameters:
    ///   - value: The underlying value to edit.
    ///   - format: A format style of type F to use when converting between the string the user edits and the
    ///   underlying value of type F.FormatInput. If format can’t perform the conversion, the text field leaves binding.value unchanged.
    ///   If the user stops editing the text in an invalid state, the text field updates the field’s text to the last known valid value.
    ///   - placeholder: The plain string placeholder
    ///   - defaultValue: A default value to apply if conversion fails. Default is `nil` which mean bound value doesn't update in case of failure.
    init<F>(value: Binding<F.FormatInput>, format: F, placeholder: String? = nil, defaultValue: F.FormatInput? = nil)
    where F: ParseableFormatStyle, F.FormatOutput == String, InputView == EmptyView,
    InputAccessoryView == EmptyView, LeftView == EmptyView, RightView == EmptyView {
        self.init(
            value: value,
            format: format,
            placeholder: placeholder.map { .plain($0) },
            defaultValue: defaultValue
        )
    }

    /// Creates a text field that applies a format style to a bound value and an attributed placeholder.
    ///
    /// Use this initializer to create a text field that binds to a bound value, using a `ParseableFormatStyle` to convert to and from this type.
    /// Changes to the bound value update the string displayed by the text field.
    /// Editing the text field updates the bound value, as long as the format style can parse the text.
    /// If the format style can’t parse the input, the bound value remains unchanged.
    ///
    /// The following example uses a Double as the bound value, and a `FloatingPointFormatStyle`
    /// instance to convert to and from a string representation. As the user types, the bound value updates,
    /// which in turn updates three `Text` views that use different format styles.
    /// If the user enters text that doesn’t represent a valid `Double`, the bound value doesn’t update.
    ///
    ///```swift
    ///@State private var myDouble: Double = 0.673
    ///var body: some View {
    ///    VStack {
    ///        SUITextField(
    ///            value: $myDouble,
    ///            format: .number,
    ///            placeholder: AttributedString("Insert a number")
    ///        )
    ///        Text(myDouble, format: .number)
    ///        Text(myDouble, format: .number.precision(.significantDigits(5)))
    ///        Text(myDouble, format: .number.notation(.scientific))
    ///    }
    ///}
    ///```
    /// - Parameters:
    ///   - value: The underlying value to edit.
    ///   - format: A format style of type F to use when converting between the string the user edits and the
    ///   underlying value of type F.FormatInput. If format can’t perform the conversion, the text field leaves binding.value unchanged.
    ///   If the user stops editing the text in an invalid state, the text field updates the field’s text to the last known valid value.
    ///   - placeholder: An `AttributedString` placeholder.
    ///   - defaultValue: A default value to apply if conversion fails. Default is `nil` which mean bound value doesn't update in case of failure.
    init<F>(value: Binding<F.FormatInput>, format: F, placeholder: AttributedString, defaultValue: F.FormatInput? = nil)
    where F: ParseableFormatStyle, F.FormatOutput == String, InputView == EmptyView,
    InputAccessoryView == EmptyView, LeftView == EmptyView, RightView == EmptyView {
        self.init(
            value: value,
            format: format,
            placeholder: .attributed(.init(placeholder)),
            defaultValue: defaultValue
        )
    }

    private init<F>(value: Binding<F.FormatInput?>, format: F, placeholder: TextType? = nil)
    where F: ParseableFormatStyle, F.FormatOutput == String, InputView == EmptyView,
    InputAccessoryView == EmptyView, LeftView == EmptyView, RightView == EmptyView {
        let binding = Binding<String>.init {
            value.wrappedValue.map { format.format($0) } ?? ""
        } set: { newValue in
            value.wrappedValue = try? format.parseStrategy.parse(newValue)
        }
        self.init(
            text: binding,
            placeholder: placeholder,
            autoSizeInputView: false,
            leftView: { EmptyView() },
            rightView: { EmptyView() },
            inputView: { EmptyView() },
            inputAccessoryView: { EmptyView() }
        )
    }

    /// Creates a text field that applies a format style to a bound value and a plain placeholder.
    ///
    /// Use this initializer to create a text field that binds to a bound value, using a `ParseableFormatStyle` to convert to and from this type.
    /// Changes to the bound value update the string displayed by the text field.
    /// Editing the text field updates the bound value, as long as the format style can parse the text.
    /// If the format style can’t parse the input, the bound value is set to `nil`
    ///
    /// The following example uses a Double as the bound value, and a `FloatingPointFormatStyle`
    /// instance to convert to and from a string representation. As the user types, the bound value updates,
    /// which in turn updates three `Text` views that use different format styles.
    /// If the user enters an invalid currency value, like letters or emoji, the console output is `Optional(nil)`.
    ///
    ///```swift
    ///@State private var myMoney: Double? = 300.0
    ///var body: some View {
    ///    SUITextField(
    ///        value: $myMoney,
    ///        format: .currency(code: "USD"),
    ///    )
    ///    .onChange(of: myMoney) { newValue in
    ///        print ("myMoney: \(newValue)")
    ///    }
    ///}
    ///```
    /// - Parameters:
    ///   - value: The underlying value to edit.
    ///   - format: A format style of type F to use when converting between the string the user edits and the
    ///   underlying value of type F.FormatInput. If format can’t perform the conversion, the text field set binding.value to `nil`.
    ///   If the user stops editing the text in an invalid state, the text field updates the field’s text to the last known valid value.
    ///   - placeholder: The plain string placeholder.
    init<F>(value: Binding<F.FormatInput?>, format: F, placeholder: String? = nil)
    where F: ParseableFormatStyle, F.FormatOutput == String, InputView == EmptyView,
    InputAccessoryView == EmptyView, LeftView == EmptyView, RightView == EmptyView {
        self.init(
            value: value,
            format: format,
            placeholder: placeholder.map { .plain($0) }
        )
    }

    /// Creates a text field that applies a format style to a bound value and an attributed placeholder.
    ///
    /// Use this initializer to create a text field that binds to a bound value, using a `ParseableFormatStyle` to convert to and from this type.
    /// Changes to the bound value update the string displayed by the text field.
    /// Editing the text field updates the bound value, as long as the format style can parse the text.
    /// If the format style can’t parse the input, the bound value is set to `nil`
    ///
    /// The following example uses a Double as the bound value, and a `FloatingPointFormatStyle`
    /// instance to convert to and from a string representation. As the user types, the bound value updates,
    /// which in turn updates three `Text` views that use different format styles.
    /// If the user enters an invalid currency value, like letters or emoji, the console output is `Optional(nil)`.
    ///
    ///```swift
    ///@State private var myMoney: Double? = 300.0
    ///var body: some View {
    ///    SUITextField(
    ///        value: $myMoney,
    ///        format: .currency(code: "USD"),
    ///        placeholder: AttributedString("Attributed placeholder")
    ///    )
    ///    .onChange(of: myMoney) { newValue in
    ///        print ("myMoney: \(newValue)")
    ///    }
    ///}
    ///```
    /// - Parameters:
    ///   - value: The underlying value to edit.
    ///   - format: A format style of type F to use when converting between the string the user edits and the
    ///   underlying value of type F.FormatInput. If format can’t perform the conversion, the text field set binding.value to `nil`.
    ///   If the user stops editing the text in an invalid state, the text field updates the field’s text to the last known valid value.
    ///   - placeholder: The attributed string placeholder.
    init<F>(value: Binding<F.FormatInput?>, format: F, placeholder: AttributedString)
    where F: ParseableFormatStyle, F.FormatOutput == String, InputView == EmptyView,
    InputAccessoryView == EmptyView, LeftView == EmptyView, RightView == EmptyView {
        self.init(
            value: value,
            format: format,
            placeholder: .attributed(.init(placeholder))
        )
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
    /// Here's an example if the input accessory view is ``ResponderNavigatorView``.
    ///
    /// ![Example image](responder-view)
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
        .applyAll(from: self)
    }

}

public extension SUITextField where InputView == EmptyView {

    /// Attaches an input view to this text field.
    ///
    /// When the text field becomes first responder, it shows a view instead of the default software keyboard.
    ///
    /// Here's an example using a date picker as an input view.
    ///
    /// ```swift
    /// var body: some View {
    ///     SUITextField(text: .constant(date.description)) // use a constant binding as a result of the $date state.
    ///         .inputView(autoSize: true) { // you can omit autoSize, true by default
    ///             DatePicker("Select date", selection: $date)
    ///                 .frame(maxWidth: .infinity, maxHeight: .infinity)
    ///                 .datePickerStyle(.wheel)
    ///                 .labelsHidden()
    ///         }
    /// }
    /// ```
    ///
    /// ![Example image](date-picker-input-view)
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
        .applyAll(from: self)
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
    /// - Important: ``SUITextField/uiTextFieldTextLeftViewMode(_:)`` should not be set to `.never` to show the view.
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
        .applyAll(from: self)
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
    /// - Important: ``SUITextField/uiTextFieldTextRightViewMode(_:)`` should not be set to `.never` to show the view.
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
        .applyAll(from: self)
    }

}

public extension SUITextField {

    private func applyAll<InputView, InputAccessoryView, LeftView, RightView>(
        from textField: SUITextField<InputView, InputAccessoryView, LeftView, RightView>
    ) -> Self where InputView: View, InputAccessoryView: View, LeftView:View, RightView: View {
        apply(value: textField.makeProxy, to: \.makeProxy)
            .apply(value: textField.updateProxy, to: \.updateProxy)
            .apply(value: textField.shouldBeginEditingAction, to: \.shouldBeginEditingAction)
            .apply(value: textField.shouldEndEditingAction, to: \.shouldEndEditingAction)
            .apply(value: textField.shouldClearAction, to: \.shouldClearAction)
            .apply(value: textField.onBeginEditingAction, to: \.onBeginEditingAction)
            .apply(value: textField.onEndEditingAction, to: \.onEndEditingAction)
            .apply(value: textField.onReturnKeyPressedAction, to: \.onReturnKeyPressedAction)
            .apply(value: textField.onSelectionChangedAction, to: \.onSelectionChangedAction)
            .apply(value: textField.shouldChangeCharactersInAction, to: \.shouldChangeCharactersInAction)
    }

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

    /// Called when the text field's text is about to change.
    ///
    /// The text field calls the action whenever user actions cause its text to change.
    /// Use this method to validate text as it is typed by the user. For example, you could use
    /// this action to prevent the user from entering anything but numerical values.
    ///
    /// - Parameters:
    ///     - action: A block that is executed when the text is about to change. The action block provides you a ``CharacterReplacement``.
    ///         This block should return `true` to allow the replacement or `false` to keep the old text.
    ///
    /// - Returns: The modified text field.
    func shouldChangeCharacters(
        _ action: @escaping (CharacterReplacement) -> Bool
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
            context.coordinator.leftView = .init(rootView: leftView, ignoreSafeArea: true)
            context.coordinator.leftView?.view.backgroundColor = .clear
            textField.leftView = context.coordinator.leftView?.view
        }

        if RightView.self != EmptyView.self {
            context.coordinator.rightView = .init(rootView: rightView, ignoreSafeArea: true)
            context.coordinator.rightView?.view.backgroundColor = .clear
            textField.rightView = context.coordinator.rightView?.view
        }

        makeProxy?(textField)

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        func applyIfDifferent<V>(value: V, at keyPath: ReferenceWritableKeyPath<UITextField, V>) where V: Equatable {
            if uiView[keyPath: keyPath] != value {
                uiView[keyPath: keyPath] = value
            }
        }
        uiView.text = text
        switch placeholder {
        case .attributed(let text): applyIfDifferent(value: text, at: \.attributedPlaceholder)
        case .plain(let text): applyIfDifferent(value: text, at: \.placeholder)
        case nil: applyIfDifferent(value: nil, at: \.placeholder)
        }
        applyIfDifferent(value: context.environment.uiTextFieldFont, at: \.font)
        applyIfDifferent(value: context.environment.uiReturnKeyType, at: \.returnKeyType)
        applyIfDifferent(value: context.environment.uiTextFieldSecureTextEntry, at: \.isSecureTextEntry)
        applyIfDifferent(value: context.environment.uiTextFieldClearButtonMode, at: \.clearButtonMode)
        applyIfDifferent(value: context.environment.uiTextFieldBorderStyle, at: \.borderStyle)
        applyIfDifferent(value: context.environment.uiTextAutocorrectionType, at: \.autocorrectionType)
        applyIfDifferent(value: context.environment.uiTextAutocapitalizationType, at: \.autocapitalizationType)
        applyIfDifferent(value: context.environment.uiTextFieldTextContentType, at: \.textContentType)
        applyIfDifferent(value: context.environment.uiTextFieldKeyboardType, at: \.keyboardType)
        applyIfDifferent(value: context.environment.uiTextFieldTextAlignment, at: \.textAlignment)
        applyIfDifferent(value: context.environment.uiTextFieldTextLeftViewMode, at: \.leftViewMode)
        applyIfDifferent(value: context.environment.uiTextFieldTextRightViewMode, at: \.rightViewMode)
        applyIfDifferent(value: context.environment.isEnabled, at: \.isEnabled)
        applyIfDifferent(value: context.environment.uiTextFieldSpellCheckingType, at: \.spellCheckingType)
        applyIfDifferent(value: context.environment.uiTextFieldPasswordRules, at: \.passwordRules)

        if let attributes = context.environment.uiTextFieldDefaultTextAttributes {
            uiView.defaultTextAttributes = attributes
        }

        switch context.environment.uiTextFieldAdjustsFontSizeToFitWidth {
        case .disabled:
            applyIfDifferent(value: false, at: \.adjustsFontSizeToFitWidth)
            applyIfDifferent(value: .zero, at: \.minimumFontSize)
        case .enabled(let minSize):
            applyIfDifferent(value: true, at: \.adjustsFontSizeToFitWidth)
            applyIfDifferent(value: minSize, at: \.minimumFontSize)
        }

        DispatchQueue.main.async {
            context.coordinator.inputViewController?.rootView = inputView
            context.coordinator.inputAccessoryViewController?.rootView = inputAccessoryView

            context.coordinator.leftView?.rootView = leftView
            context.coordinator.rightView?.rootView = rightView
        }

        updateProxy?(uiView)
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

        public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { uiKitTextField.shouldBeginEditingAction?() ?? true }

        public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { uiKitTextField.shouldEndEditingAction?() ?? true }

        public func textFieldShouldClear(_ textField: UITextField) -> Bool { uiKitTextField.shouldClearAction?() ?? true }

        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let action = uiKitTextField.shouldChangeCharactersInAction else { return true }
            let nsString = (textField.text ?? "") as NSString
            let newString = nsString.replacingCharacters(in: range, with: string)
            let replacement = CharacterReplacement(
                originString: textField.text ?? "",
                newString: newString,
                range: range,
                replacementString: string
            )
            return action(replacement)
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            applyCustomViews(to: textField)
            onViewBecomeFirstResponder()
            uiKitTextField.onBeginEditingAction?()
        }

        public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            removeCustomViews(to: textField)
            onViewResignFirstResponder()
            uiKitTextField.onEndEditingAction?(reason)
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            uiKitTextField.onReturnKeyPressedAction?()
            return false
        }

        public func textFieldDidChangeSelection(_ textField: UITextField) {
            uiKitTextField.onSelectionChangedAction?(textField)
        }

    }

}
