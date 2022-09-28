//
//  ResponderChainCoordinator.swift
//  
//
//  Created by Rico Crescenzio on 03/04/22.
//

import SwiftUI
import Combine

/// A coordinator that provides some basics behavior to handle responder when using `UIViewRepresentable`.
///
/// ``SUITextField`` uses a subclass of this as its own coordinator to handle the responder chain.
///
/// If you create your own `UIViewRepresentable` view, whose underlying `UIView` can become first responder,
/// you can subclass this coordinator and set it up to handle first responder.
///
/// If you do so, call ``onMakeUIView(_:with:)`` in `makeUIView(context:)` method after you
/// created and properly setup your `UIView`. Doing that, the coordinator is already able to make your view as first responder, or resign it when a
/// ``ResponderState`` value changes.
///
/// You still have to tell the coordinator when a view become/resign first responder as consequence of a user input, by calling
/// ``onViewBecomeFirstResponder()`` and ``onViewResignFirstResponder()``.
/// This will properly set the value to the bound ``ResponderState``.
/// For example, in a custom `UITextField`, you might call these two
/// methods on `textFieldDidBeginEditing` and `textFieldDidEndEditing` delegate method.
///
/// ```swift
/// struct MyTextField: UIViewRepresentable {
///
///     func makeUIView(context: Context) -> UITextField {
///         let textField = UITextField()
///         textField.delegate = context.coordinator
///         context.coordinator.onMakeUIView(textField, with: context) // 1. make your uiView and call onMakeUIView
///         return textField
///     }
///
///     func updateUIView(_ uiView: UITextField, context: Context) {}
///
///     func makeCoordinator() -> CustomCoordinator { CustomCoordinator() }
///
///     // CustomCoordinator inherits ResponderChainCoordinator
///     class CustomCoordinator: ResponderChainCoordinator, UITextFieldDelegate {
///
///         func textFieldDidBeginEditing(_ textField: UITextField) {
///             onViewBecomeFirstResponder() // 2. Call onViewBecomeFirstResponder when text field start editing
///         }
///
///         func textFieldDidEndEditing(_ textField: UITextField) {
///             onViewResignFirstResponder() // 3. Call onViewResignFirstResponder  when text field end editing
///         }
///     }
/// }
/// ```
///
/// - Warning: Be sure you call ``onViewBecomeFirstResponder()`` and ``onViewResignFirstResponder()`` at appropriate time
/// in your custom implementation otherwise you might break the responder chain system.
/// 
public class ResponderChainCoordinator: NSObject {

    private var responderValue: AnyHashable?
    private var responderStorage: ResponderStorage?
    private var cancellable: AnyCancellable?

    /// To be called on your custom `UIViewRepresentable` implementation within `makeUIView(context:)` function, after you
    /// created and setup your `UIView`.
    ///
    /// - Parameters:
    ///   - uiView: The `UIView` that can become and resign first responder bound to a ``ResponderState``.
    ///   - context: The `UIViewRepresentableContext` given by `SwiftUI` while creating your uiView.
    public func onMakeUIView<UIViewType>(_ uiView: UIView, with context: UIViewRepresentableContext<UIViewType>) {
        guard let value = context.environment.responderValue else {
            cancellable = nil
            return
        }

        let applyResponder: (Bool) -> Void = { isFirstResponder in
            if isFirstResponder && !uiView.isFirstResponder {
                DispatchQueue.main.async {
                    uiView.becomeFirstResponder()
                }
            } else if !isFirstResponder && uiView.isFirstResponder {
                DispatchQueue.main.async {
                    uiView.resignFirstResponder()
                }
            }
        }

        if let responderStorage = context.environment.responderStorage as? BoolResponderStorage {
            cancellable = responderStorage.$value
                .sink(receiveValue: { selectedValue in
                    applyResponder(selectedValue)
                })
        } else if let responderStorage = context.environment.responderStorage as? AnyHashableResponderStorage {
            cancellable = responderStorage.$value
                .compactMap { $0 as? (any Hashable) }
                .sink(receiveValue: { selectedValue in
                    applyResponder(value.hashValue == selectedValue.hashValue)
                })
        }
        responderStorage = context.environment.responderStorage
        responderValue = context.environment.responderValue
    }

    /// Apply the correct value to the bound ``ResponderState`` when view become first responder.
    ///
    /// This function needs to be called when as a result of user or system event, your uiView become first responder.
    /// For example, if your view is `UITextField`, your should set up its `UITextFieldDelegate` and call this function
    /// from within `textFieldDidBeginEditing(_:)`.
    ///
    /// - Warning: Be sure you call this in your custom implementation. Avoiding it, can break the responder chain system.
    public func onViewBecomeFirstResponder() {
        if responderStorage?.erasedValue != responderValue {
            responderStorage?.erasedValue = responderValue
        }
    }

    /// Apply the correct value to the bound ``ResponderState`` when view resign first responder.
    ///
    /// This function needs to be called when as a result of user or system event, your uiView resign first responder.
    /// For example, if your view is `UITextField`, your should set up its `UITextFieldDelegate` and call this function
    /// from within `textFieldDidEndEditing(_:)`.
    ///
    /// - Warning: Be sure you call this in your custom implementation. Avoiding it, can break the responder chain system.
    public func onViewResignFirstResponder() {
        if responderStorage?.erasedValue == responderValue {
            if let responderStorage = responderStorage as? BoolResponderStorage {
                responderStorage.value = false
            } else if let responderStorage = responderStorage as? AnyHashableResponderStorage {
                responderStorage.value = responderStorage.defaultValue
            }
        }
    }

}
