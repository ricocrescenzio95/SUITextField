//
//  ResponderState.swift
//  
//
//  Created by Rico Crescenzio on 01/04/22.
//

import SwiftUI

/// A property wrapper type that you can use to drive the responder of ``SUITextField``.
///
/// Use this property wrapper in conjunction with ``SUITextField/responder(_:equals:)``
/// and ``SUITextField/responder(_:)`` modifiers to tell which text field is the first responder.
///
/// When the modified view becomes first responder, the wrapped value
/// of this property updates to match a given prototype value. Similarly, when
/// focus leaves, the wrapped value of this property resets to `nil`
/// or `false`. Setting the property's value programmatically has the reverse
/// effect, causing the view associated to become first responder.
///
/// In the following example of a simple login screen, when the user presses the
/// Sign In button and one of the fields is still empty, focus moves to that
/// field. Otherwise, the sign-in process proceeds.
///
/// ```swift
/// struct LoginForm {
///     enum Field: Hashable {
///         case username
///         case password
///     }
///
///     @State private var username = ""
///     @State private var password = ""
///     @ResponderState private var focusedField: Field?
///
///     var body: some View {
///         Form {
///             SUITextField(text: $username, placeholder: "Username")
///                 .responder($focusedField, equals: .username)
///
///             SUITextField(text: $password, placeholder: "Password")
///                 .uiTextFieldSecureTextEntry(true)
///                 .responder($focusedField, equals: .password)
///
///             Button("Sign In") {
///                 if username.isEmpty {
///                     focusedField = .username
///                 } else if password.isEmpty {
///                     focusedField = .password
///                 } else {
///                     handleLogin(username, password)
///                 }
///             }
///         }
///     }
/// }
/// ```
///
/// To allow for cases where focus is completely absent from a view tree, the
/// wrapped value must be either an optional or a Boolean. Set the focus binding
/// to `false` or `nil` as appropriate to remove focus from all bound fields.
/// You can also use this to remove focus from a ``SUITextField`` and thereby
/// dismiss the keyboard.
///
@propertyWrapper public struct ResponderState<Value>: DynamicProperty where Value: Hashable {

    /// A property wrapper type that can read and write a value that indicates the current focus location.
    @propertyWrapper public struct Binding: DynamicProperty {

        @ObservedObject var storage: ResponderStorage

        private let getBlock: () -> Value
        private let setBlock: (Value) -> Void

        init(storage: ResponderStorage, get: @escaping () -> Value, set: @escaping (Value) -> Void) {
            self.storage = storage
            getBlock = get
            setBlock = set
        }

        /// The underlying value referenced by the bound property.
        public var wrappedValue: Value {
            get { getBlock() }
            nonmutating set { setBlock(newValue) }
        }

        /// A projection of the binding value that returns a binding.
        ///
        /// Use the projected value to pass a binding value down a view hierarchy.
        public var projectedValue: Binding { self }

    }

    @ObservedObject private var storage: ResponderStorage

    /// Creates a state that binds an optional `Hashable` value.
    public init<T>() where Value == T?, T : Hashable {
        storage = AnyHashableResponderStorage(value: nil as Value)
    }

    /// Creates a state that binds boolean  value.
    public init() where Value == Bool {
        storage = BoolResponderStorage(defaultValue: false)
    }

    /// The current state value, that changes when new text field becomes first responder (or resign).
    ///
    /// When no text field is first responder, the wrapped value will be nil (for optional-typed state) or false (for Bool- typed state).
    public var wrappedValue: Value {
        get { storage.erasedValue as? Value ?? storage.defaultValue as! Value }
        nonmutating set { storage.erasedValue = newValue }
    }

    /// A projection of the focus state value that returns a binding.
    ///
    /// When no ``SUITextField`` is not first responder, the wrapped value is nil for optional-typed state or false for Boolean state.
    /// In the following example of a simple navigation sidebar, when the user presses the Filter Sidebar Contents button,
    /// focus moves to the sidebar’s filter text field. Conversely, if the user moves focus to the sidebar’s filter manually,
    /// then the value of isFiltering automatically becomes true, and the sidebar view updates.
    ///
    ///
    /// ```swift
    ///struct Sidebar: View {
    ///    @State private var filterText = ""
    ///    @ResponderState private var isFiltering: Bool
    ///    var body: some View {
    ///        VStack {
    ///            Button("Filter Sidebar Contents") {
    ///                isFiltering = true
    ///            }
    ///            SUITextField("Filter", text: $filterText)
    ///                .responder($isFiltering)
    ///        }
    ///    }
    ///}
    ///```
    ///
    public var projectedValue: Binding {
        .init(storage: storage) {
            wrappedValue
        } set: {
            wrappedValue = $0
        }
    }

}
