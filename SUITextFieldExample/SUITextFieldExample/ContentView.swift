//
//  ContentView.swift
//  SUITextFieldExample
//
//  Created by Rico Crescenzio on 31/03/22.
//

import SwiftUI
import SwiftUITextField

struct ContentView: View {

    enum Responder: CaseIterable {
        case first
        case second
        case third
        case fourth
    }

    @State private var toggleFont = false
    @State private var text = "A test text"
    @ResponderState var focus: Responder?
    @ResponderState var isFocused: Bool
    @State private var toggle = false
    @State private var date = Date()
    @State private var myDouble: Double? = 0.0

    let attributes: [NSAttributedString.Key: Any] = [
        .kern: 5,
        .foregroundColor: UIColor.systemOrange
    ]

    let placeholderAttributes: [NSAttributedString.Key: Any] = [
        .kern: 5,
        .foregroundColor: UIColor.systemGray
    ]

    var body: some View {
      VStack {
        SUITextField(text: $text, placeholder: "Hello")
          .onReturnKeyPressed { isFocused = false }
          .responder($isFocused)
      }
      .uiTextFieldTextAlignment(.right)
      .uiTextFieldBorderStyle(.roundedRect)
    }

    private var navigator: some View {
        ResponderNavigatorView(responder: $focus)
            .centerView {
                Text(text)
            }
    }

    private var datePicker: some View {
        DatePicker("Select date", selection: $date)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .datePickerStyle(.wheel)
            .labelsHidden()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
