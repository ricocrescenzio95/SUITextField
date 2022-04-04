# ``SwiftUITextField``

A `SwiftUI` wrapper of `UITextField` that allows more customization and programmatic navigation between responders.

![A sloth hanging off a tree.](logo)

`SwiftUI` `TextField` (especially on iOS 14 and below) misses lot of APIs.

``SUITextField`` is a wrapper of `UITextField` that allows to navigate programmatically through responders,
allows to set a custom `inputView`, `inputAccessoryView` while editing, as well as `leftView` and `rightView`.

You can also use all the `UITextFieldDelegate` methods, all exposed as `SwiftUI` modifiers.

All these additional customization are passed as `SwiftUI` views/modifiers, allowing to use its lovely declarative API! 🎉

## Topics

### Essentials

- ``SUITextField``

### Handling Responder Chain

- ``ResponderState``


