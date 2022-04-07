//
//  ContentView.swift
//  SUITextFieldExample
//
//  Created by Rico Crescenzio on 31/03/22.
//

import SwiftUI
import SwiftUITextField

struct ContentView: View {

    enum Responder: Hashable, CaseIterable {
        case first
        case second
        case third
    }

    @State private var toggleFont = false
    @State private var text = "A test text"
    @ResponderState var focus: Responder?
    @ResponderState var isFocused: Bool
    @State private var toggle = false
    @State private var date = Date()
    @State private var myDouble = 0.0

    var body: some View {
        NavigationView {
            ScrollView {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .padding(.vertical, 50)
                VStack {
                    SUITextField(text: $text)
                        .shouldChangeCharacters { replacement in
                            replacement.newString.trimmingCharacters(in: CharacterSet.decimalDigits).isEmpty
                        }
                        .inputAccessoryView {
                            navigator
                        }
                        .onReturnKeyPressed {
                            focus = nil
                        }
                        .leftView {
                            Button(action: { text = "" }) {
                                Image(systemName: "trash")
                            }
                            .padding(.horizontal, 2)
                        }
                        .responder($focus, equals: .first)
                        .uiTextFieldTextLeftViewMode(.whileEditing)
                    SUITextField(text: $text)
                        .inputAccessoryView {
                            navigator
                        }
                        .responder($focus, equals: .second)
                    SUITextField(text: .constant(date.description))
                        .inputAccessoryView {
                            navigator
                        }
                        .inputView {
                            DatePicker("Select date", selection: $date)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                        }
                        .responder($focus, equals: .third)
                    if #available(iOS 15, *) {
                        SUITextField(value: $myDouble, format: .number)
                        TextField("test", value: $myDouble, format: .number)
                        Text(myDouble, format: .number)
                    }
                }
                .padding()
            }
            .uiTextFieldFont(toggleFont ? .monospacedSystemFont(ofSize: 50, weight: .medium) : nil)
            .uiTextFieldBorderStyle(.roundedRect)
            .navigationBarTitle("SUITextField")
        }
    }

    private var navigator: some View {
        ResponderNavigatorView(responder: $focus)
            .centerView {
                Text(text)
            }
    }

    @ViewBuilder
    var keyPadInputView: some View {
        VStack {
            ForEach(0...2, id: \.self) { row in
                HStack {
                    ForEach(1...3, id: \.self) { col in
                        Button {
                            text += (col + (row * 3)).description
                        } label: {
                            Text((col + (row * 3)).description).frame(width: 30, height: 30)
                        }
                    }
                }
            }
        }
        .padding()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
