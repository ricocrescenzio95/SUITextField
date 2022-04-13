# Environment Modifiers

Apply style and behaviors to ``SUITextField``s.

## Overview

Following modifiers can be applied to any view in order to add style/behaviors to all
``SUITextField`` contained in that view or children.
You could, for instance, set a ``SUITextField/uiTextFieldFont(_:)`` at `App` level to setup a default
`UIFont` to be used in the whole app.

```swift
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .uiTextFieldFont(.systemFont(ofSize: 14, weight: .light))
        }
    }
}

struct ContentView: View {

    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            SUITextField(text: $username, placeholder: "Username")
            SUITextField(text: $password, placeholder: "Password")
            Button(action: performLogin) {
                Text("Login")
            }
        }
    }
}
```

## Override environment

The example below shows the effects of applying fonts to individual
views and to view hierarchies. Font information flows down the view
hierarchy as part of the environment, and remains in effect unless
overridden at the level of an individual view or view container.

Here, the outermost `VStack` applies a 16-point system font as a
default font to text fields contained in that `VStack`. Inside that stack,
the example applies a 20-point bold system font to just the first text
field; this explicitly overrides the default. The remaining stack and the
views contained with it continue to use the 16-point system font set by
their containing view:

```swift
VStack {
    SUITextField(text: $text, placeholder: "this text field has 20-point bold system font")
        .uiTextFieldFont(.systemFont(ofSize: 20, weight: .bold))

    VStack {
        SUITextField(text: $text, placeholder: "this two text fields")
        SUITextField(text: $text, placeholder: "have same font applied from modifier")
    }
}
.uiTextFieldFont(.systemFont(ofSize: 16, weight: .light))
```

## Dive deep into Default Text Attributes

Using ``SUITextField/uiTextFieldDefaultTextAttributes(_:mergePolicy:)`` you can specify how to apply default attributes
to every text field. 
Since this modifier works using environment, another modifier at higher view hierarchy might
have been applied. 

Following example apply `kern`, `foregroundColor` and `font` to text fields which bind `password` and `repeatPassoword`;
the text field which bind `username` apply **only** the new kern and get rid of previously set attributes:

```swift
let attributes: [NSAttributedString.Key: Any] = [
    .kern: 5,
    .foregroundColor: UIColor.systemOrange,
    .font: UIFont.systemFont(ofSize: 20, weight: .black),
]

let moreKern: [NSAttributedString.Key: Any] = [
    .kern: 15,
]

var body: some View {
    VStack {
        SUITextField(text: $username)
            .uiTextFieldDefaultTextAttributes(kern)
        SUITextField(text: $password)
        SUITextField(text: $repeatPassword)
    }
    .uiTextFieldDefaultTextAttributes(attributes)
}
```

If you want to override `kern` and keep other old attributes, you will use ``DefaultAttributesMergePolicy`` like:

```swift
SUITextField(text: $username)
    .uiTextFieldDefaultTextAttributes(kern, mergePolicy: .keepNew)
```

Finally, there are cases where you might merge new attributes but keep old ones when same key is found,
you can use `.keepOld`. Following example apply a `font`, a `textColor` and then the default attributes
applies **only** the `kern` becuase policy is `.keepOld`

```swift
SUITextField(text: $text)
    .uiTextFieldDefaultTextAttributes(attributes, mergePolicy: .keepOld)
    .uiTextFieldTextColor(.systemRed)
    .uiTextFieldFont(.italicSystemFont(ofSize: 12))
```

## Get the environment value
 
Each modifier apply an environment, so you can get this value using `@Environment` property wrapper.

```swift
struct MyView: View {
    @Environment(\.uiTextFieldFont) private var font
    
    var body: some View {
        Text("Hello World")
    }
}
```

## Topics

### Modify appearence

- ``SUITextField/uiTextFieldFont(_:)``
- ``SUITextField/uiTextFieldTextColor(_:)``
- ``SUITextField/uiTextFieldTextAlignment(_:)``
- ``SUITextField/uiTextFieldDefaultTextAttributes(_:mergePolicy:)``
- ``DefaultAttributesMergePolicy``

### Modify behavior

- ``SUITextField/uiTextFieldReturnKeyType(_:)``
- ``SUITextField/uiTextFieldSecureTextEntry(_:)``
- ``SUITextField/uiTextFieldClearButtonMode(_:)``
- ``SUITextField/uiTextFieldBorderStyle(_:)``
- ``SUITextField/uiTextFieldAutocapitalizationType(_:)``
- ``SUITextField/uiTextFieldAutocorrectionType(_:)``
- ``SUITextField/uiTextFieldKeyboardType(_:)``
- ``SUITextField/uiTextFieldTextContentType(_:)``
- ``SUITextField/uiTextFieldTextLeftViewMode(_:)``
- ``SUITextField/uiTextFieldTextRightViewMode(_:)``
- ``SUITextField/uiTextFieldSpellCheckingType(_:)``
- ``SUITextField/uiTextFieldPasswordRules(_:)``
- ``SUITextField/uiTextFieldAdjustsFontSizeToFitWidth(_:)``
