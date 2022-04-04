//
//  ResponderModifier.swift
//  
//
//  Created by Rico Crescenzio on 01/04/22.
//

import SwiftUI

private struct ResponderModifier<Value>: ViewModifier where Value: Hashable {

    @ResponderState.Binding var binding: Value
    private let value: Value

    init(binding: ResponderState<Value>.Binding, equals value: Value) {
        self.value = value
        _binding = binding
        _ = binding.storage.values.insert(value)
    }

    func body(content: Content) -> some View {
        content
            .environment(\.responderValue, value)
            .environment(\.responderStorage, $binding.storage)
    }

}

public extension SUITextField {

    /// Modifies this view by binding its responder state to the given state value.
    ///
    /// Use this modifier to cause the ``SUITextField`` to become first responder when
    /// the `binding` equals the `value`. Typically, you create an enumeration
    /// of fields that may receive focus, bind an instance of this enumeration,
    /// and assign its cases to responder views.
    ///
    /// The following example uses the cases of a `LoginForm` enumeration to
    /// bind the responder state of two ``SUITextField`` views. A sign-in button
    /// validates the fields and sets the bound `focusedField` value to
    /// any field that requires the user to correct a problem.
    ///
    /// ```swift
    /// struct LoginForm {
    ///     enum Field: Hashable {
    ///         case usernameField
    ///         case passwordField
    ///     }
    ///
    ///     @State private var username = ""
    ///     @State private var password = ""
    ///     @ResponderState private var focusedField: Field?
    ///
    ///     var body: some View {
    ///         Form {
    ///             SUITextField(text: $username, placeholder: "Username")
    ///                 .responder($focusedField, equals: .usernameField)
    ///
    ///             SUITextField(text: $password, placeholder: "Password")
    ///                 .responder($focusedField, equals: .passwordField)
    ///                 .uiTextFieldSecureTextEntry(true)
    ///
    ///             Button("Sign In") {
    ///                 if username.isEmpty {
    ///                     focusedField = .usernameField
    ///                 } else if password.isEmpty {
    ///                     focusedField = .passwordField
    ///                 } else {
    ///                     handleLogin(username, password)
    ///                 }
    ///             }
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// To control focus using a Boolean, use the `View/responder(_:)` method
    /// instead.
    ///
    /// - Parameters:
    ///   - binding: The state binding to register. When text field becomes to the
    ///     first responder, the binding sets the bound value to the corresponding
    ///     match value. If a caller sets the state value programmatically to the
    ///     matching value, then the text field becomes first responder. When text field
    ///     resign first responder, the binding sets the bound value to
    ///     `nil`. If a caller sets the value to `nil`, text field resign first responder.
    ///   - value: The value to match against when determining whether the
    ///     binding should change.
    /// - Returns: The modified view.
    func responder<Value>(_ binding: ResponderState<Value>.Binding, equals value: Value) -> some View where Value: Hashable {
        modifier(ResponderModifier(binding: binding, equals: value))
    }

    /// Modifies this view by binding its responder state to the given Boolean state
    /// value.
    ///
    /// Use this modifier to cause the ``SwiftUITextField/SUITextField`` to become first responder
    /// whenever the the `condition` value is `true`. You can use this modifier to
    /// observe the responder state of a single view, or programmatically set and
    /// remove focus from the view.
    ///
    /// In the following example, a single ``SwiftUITextField/SUITextField`` accepts a user's
    /// desired `username`. The text field binds its focus state to the
    /// Boolean value `usernameFieldIsFocused`. A "Submit" button's action
    /// verifies whether the name is available. If the name is unavailable, the
    /// button sets `usernameFieldIsFocused` to `true`, which causes focus to
    /// return to the text field, so the user can enter a different name.
    ///
    /// ```swift
    /// @State private var username: String = ""
    /// @ResponderState private var usernameFieldIsFocused: Bool
    /// @State private var showUsernameTaken = false
    ///
    /// var body: some View {
    ///     VStack {
    ///         SUITextField(text: $username, placeholder: "Choose a username")
    ///             .responder($usernameFieldIsFocused)
    ///         if showUsernameTaken {
    ///             Text("That username is taken. Please choose another.")
    ///         }
    ///         Button("Submit") {
    ///             showUsernameTaken = false
    ///             if !isUserNameAvailable(username: username) {
    ///                 usernameFieldIsFocused = true
    ///                 showUsernameTaken = true
    ///             }
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// To control focus by matching a value, use the
    /// `View/responder(_:equals:)` method instead.
    ///
    /// - Parameter condition: The responder state to bind. When text field becomes
    ///   first responder, the binding sets the bound value to `true`. If a caller
    ///   sets the value to  `true` programmatically, then the text field become the
    ///   first responder. When resign first responder gets called, the binding
    ///   sets the value to `false`. If a caller sets the value to `false`,
    ///   resign first responder will be called on the text field.
    ///
    /// - Returns: The modified view.
    func responder(_ binding: ResponderState<Bool>.Binding) -> some View {
        modifier(ResponderModifier(binding: binding, equals: true))
    }

}
