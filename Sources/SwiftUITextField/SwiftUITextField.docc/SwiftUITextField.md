# ``SwiftUITextField``

A `SwiftUI` wrapper of `UITextField` that allows more customization and programmatic navigation between responders.

![Library logo](logo)

`SwiftUI` `TextField` (especially on iOS 14 and below) misses lot of APIs.

``SUITextField`` is a wrapper of `UITextField` that allows to navigate programmatically through responders,
allows to set a custom `inputView`, `inputAccessoryView` while editing, as well as `leftView` and `rightView`.

You can also use all the `UITextFieldDelegate` methods, all exposed as `SwiftUI` modifiers.

All these additional customization are passed as `SwiftUI` views/modifiers, allowing to use its lovely declarative API! 🎉

```swift
struct ContentView: View {

    enum Responder: Hashable {
        case first
        case second
    }

    @State private var text = "A test text"
    @ResponderState var focus: Responder?
    @State private var date = Date()

    var body: some View {
        ScrollView {
            VStack {
                SUITextField(text: $text, placeholder: "Insert a text...")
                    .inputAccessoryView {
                        MyAccessoryView() // add an accessory view 
                    }
                    .onReturnKeyPressed {
                        focus = nil // set focus to nil to close keyboard on return key tap
                    }
                    .leftView { // add a left view to clear text on tap
                        Button(action: { text = "" }) {
                            Image(systemName: "trash")
                        }
                        .padding(.horizontal, 2)
                    }
                    .responder($focus, equals: .first)
                    .uiTextFieldTextLeftViewMode(.whileEditing)
                SUITextField(text: .constant(date.description))
                    .inputAccessoryView {
                        ResponderNavigatorView(responder: $focus) // or use the provided responder view!
                    }
                    .inputView {
                        // Use a date picker as input view!
                        DatePicker("Select date", selection: $date)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                    }
                    .responder($focus, equals: .second)
            }
            .padding()
        }
        // apply style to all children text field!
        .uiTextFieldBorderStyle(.roundedRect)
    }

    // more code...
```

## Topics

### Essential views

- ``SUITextField``
- ``ResponderNavigatorView``

### Handling Responder Chain

- ``ResponderState``
- ``ResponderChainCoordinator``
