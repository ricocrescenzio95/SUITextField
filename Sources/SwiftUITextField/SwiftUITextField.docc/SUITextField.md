# ``SwiftUITextField/SUITextField``

## Topics

### Modify style and behaviors

- <doc:EnvironmentModifiers>

### Custom views

Apply custom views and input views

- ``SUITextField/inputAccessoryView(view:)``
- ``SUITextField/inputView(autoSize:view:)``
- ``SUITextField/leftView(view:)``
- ``SUITextField/rightView(view:)``

### Handling responder

Modify the first responder with ``ResponderState``

- ``SUITextField/responder(_:)``
- ``SUITextField/responder(_:equals:)``

### Responding to events

Events triggered by `UITextFieldDelegate`

- ``SUITextField/shouldBeginEditingAction(_:)``
- ``SUITextField/shouldEndEditingAction(_:)``
- ``SUITextField/shouldClearAction(_:)``
- ``SUITextField/onBeginEditing(_:)``
- ``SUITextField/onEndEditing(_:)``
- ``SUITextField/onReturnKeyPressed(_:)``
- ``SUITextField/onSelectionChanged(_:)``
- ``SUITextField/shouldChangeCharacters(_:)``

### Advanced customization

Use this modifiers only if there are no built-in ones.

- ``SUITextField/onCreate(_:)``
- ``SUITextField/onUpdate(_:)``
