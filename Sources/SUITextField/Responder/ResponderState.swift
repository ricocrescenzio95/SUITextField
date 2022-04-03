//
//  ResponderState.swift
//  
//
//  Created by Rico Crescenzio on 01/04/22.
//

import SwiftUI

class ResponderStorage: ObservableObject {

    static let responderQueue = OperationQueue()

    var erasedValue: AnyHashable? {
        get { fatalError("Must subclass") }
        set { objectWillChange.send() }
    }

    var values = Set<AnyHashable>()

    let defaultValue: Any

    init(defaultValue: Any) {
        self.defaultValue = defaultValue
    }

}

class AnyHashableResponderStorage: ResponderStorage {

    @Published var value: Any

    override var erasedValue: AnyHashable? {
        get { value as? AnyHashable }
        set {
            value = newValue ?? defaultValue
            super.erasedValue = newValue
        }
    }

    init<Value>(value: Value) where Value: Hashable {
        self.value = value

        super.init(defaultValue: value)
    }

}

class BoolResponderStorage: ResponderStorage {

    @Published var value: Bool = false

    override var erasedValue: AnyHashable? {
        get { value }
        set {
            value = newValue as? Bool ?? false
            super.erasedValue = newValue
        }
    }

}

/// A property wrapper type that you can use to drive the responder of ``SUITextField``.
///
/// Use this property wrapper in conjunction with ``View/responder(_:equals:)``
/// and ``View/responder(_:)`` to tell which text field is the first responder.
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

    @propertyWrapper public struct Binding: DynamicProperty {

        @ObservedObject var storage: ResponderStorage

        public var wrappedValue: Value {
            get { storage.erasedValue as? Value ?? storage.defaultValue as! Value }
            nonmutating set { storage.erasedValue = newValue }
        }

        public var projectedValue: Binding { self }

    }

    @ObservedObject private var storage: ResponderStorage

    public init<T>() where Value == T?, T : Hashable {
        storage = AnyHashableResponderStorage(value: nil as Value)
    }

    public init() where Value == Bool {
        storage = BoolResponderStorage(defaultValue: false)
    }

    public var wrappedValue: Value {
        get { storage.erasedValue as? Value ?? storage.defaultValue as! Value }
        nonmutating set { storage.erasedValue = newValue }
    }

    public var projectedValue: Binding { .init(storage: storage) }

}
