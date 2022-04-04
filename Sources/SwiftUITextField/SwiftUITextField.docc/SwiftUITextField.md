# ``SwiftUITextField``

A `SwiftUI` wrapper of `UITextField` that allows more customization and programmatic navigation between responders.

## Overview

`SwiftUI` `TextField` (especially on iOS 14 and below) misses lot of APIs.

``SUITextField`` is a wrapper of `UITextField` that allows to navigate programmatically through responders,
allows to set a custom `inputView`, `inputAccessoryView` while editing, as well as `leftView` and `rightView`.

You can also use all the `UITextFieldDelegate` methods, all exposed as `SwiftUI` modifiers.

All these additional customization are passed as `SwiftUI` views, allowing to use its lovely declarative API! 🎉

## Topics

### Essentials

These modifiers set an environment to style the text field.

- ``SUITextField``

### Handling Responder Chain

- ``ResponderState``
