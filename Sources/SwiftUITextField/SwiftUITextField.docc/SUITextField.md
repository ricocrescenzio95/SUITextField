# ``SwiftUITextField/SUITextField``

## Topics

### Creating a text field with a string

- ``SUITextField/init(text:placeholder:)-5btu0``
- ``SUITextField/init(text:placeholder:)-7334w``
- ``SUITextField/init(text:placeholder:)-9p6by``

### Creating a text field with a value (iOS 15)

- ``SUITextField/init(value:format:formatPolicy:placeholder:defaultValue:)-3i36v``
- ``SUITextField/init(value:format:formatPolicy:placeholder:defaultValue:)-5fdb3``
- ``SUITextField/init(value:format:formatPolicy:placeholder:)-9l23l``
- ``SUITextField/init(value:format:formatPolicy:placeholder:)-2bhgs``
- ``FormatPolicy``

### Creating a text field with a value (pre-iOS 15)

- ``SUITextField/init(value:formatter:formatPolicy:placeholder:defaultValue:)-3wopi``
- ``SUITextField/init(value:formatter:formatPolicy:placeholder:defaultValue:)-1cub1``

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
