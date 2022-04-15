<h1 align="center">
  <br>
<img src="./Sources/SwiftUITextField/SwiftUITextField.docc/Resources/logo.png" alt="Markdownify" width="200">
</h1>

# SwiftUI Text Field

### A SwiftUI wrapper of UITextField that allows more customization

<p>
  <a href="https://app.bitrise.io/app/e9993c1a127d5a26#">
    <img src="https://app.bitrise.io/app/e9993c1a127d5a26/status.svg?token=WZGzlJfxkVPPq7MernCdVg&branch=master">
  </a>
  <a href="https://github.com/ricocrescenzio95/SUITextField/releases">
    <img src="https://img.shields.io/github/v/release/ricocrescenzio95/SUITextField?include_prereleases&label=Swift%20Package%20Manager">
  </a>
  <a href="https://swiftpackageindex.com/ricocrescenzio95/SUITextField">
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fricocrescenzio95%2FSUITextField%2Fbadge%3Ftype%3Dswift-versions">
  </a>
  <a href="https://swiftpackageindex.com/ricocrescenzio95/SUITextField">
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fricocrescenzio95%2FSUITextField%2Fbadge%3Ftype%3Dplatforms">
  </a>
  <a href="https://saythanks.io/to/rico.crescenzio">
    <img src="https://img.shields.io/badge/SayThanks.io-%E2%98%BC-1EAEDB.svg">
  </a>
  <a href="https://www.paypal.com/donate/?hosted_button_id=RWDBC8TS5CNVA">
    <img src="https://img.shields.io/badge/$-donate-ff69b4.svg?maxAge=2592000&amp;style=flat">
  </a>
</p>

<p>
  <a href="#key-features">Key Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#documentation">Documentation</a> •
  <a href="#license">License</a>
  <br><br><br>
</p>

<p align="center">
  <img src="readme-res/main-example.gif">
 </p>

## Key Features

* `InputView` and `InputAccessoryView`
* `LeftView` and `RightView`
* All `UITextFieldDelegate` methods exposed as `SwiftUI` modifiers
* Programmatic navigation similar to iOS 15 `FocusState`
* A default `ResponderNavigatorView` usable as an `InputAccessoryView` to navigate through text fields
* Attributed placeholder
* `ParseableFormatStyle` when using `iOS 15`
* `Foundation.Formatter` when using `pre-iOS 15`
* DocC documented!

## Installation

`SUITextField` can be installed using Swift Package Manager.

1. In Xcode open **File/Swift Packages/Add Package Dependency...** menu.

2. Copy and paste the package URL:

```
https://github.com/ricocrescenzio95/SUITextField
```

For more details refer to [Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) documentation.

## Usage

Just use it as you would use any other `SwiftUI` view!

```swift
struct ContentView: View {

    enum Responder {
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
                        ResponderNavigatorView(responder: $focus) // add default ResponderNavigatorView as input accessory view
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
                        MyAccessoryView() // add a custom accessory view 
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

## Documentation

Use Apple `DocC` generated documentation, from Xcode, `Product > Build Documentation`.

<img src="readme-res/docc.png" width="500"/>

## Known Issues

- When an external keyboard is connected and the software keyboard is hidden, 
on iOS 13/15 there are small layout jumps when switching from a text fields
- On iOS 14 this behavior is worse: the system tries to re-layout the component infinitely! Need to understand what actually happens under the hood...

Check this [issue](https://github.com/ricocrescenzio95/SUITextField/issues/5).

## Found a bug or want new feature?

If you found a bug, you can open an issue as a bug [here](https://github.com/ricocrescenzio95/SUITextField/issues/new?assignees=ricocrescenzio95&labels=bug&template=bug_report.md&title=%5BBUG%5D)

Want a new feature? Open an issue [here](https://github.com/ricocrescenzio95/SUITextField/issues/new?assignees=ricocrescenzio95&labels=enhancement&template=feature_request.md&title=%5BNEW%5D)

### Yu can also open your own PR and contribute to the project! [Contributing](CONTRIBUTING.md) 🤝

## License

This software is provided under the [MIT](LICENSE.md) license

---

Thanks Bebisim ❤️ 
