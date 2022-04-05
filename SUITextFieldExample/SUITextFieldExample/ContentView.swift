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

    var body: some View {
        ScrollView {
            Text("SUITextField")
                .font(.headline)
                .padding(.top)
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
                .padding(.vertical, 50)
            VStack {
                SUITextField(text: $text)
                    .inputAccessoryView {
                        accessoryView
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
                        ResponderNavigatorView(responder: $focus)
                    }
                    .inputView {
                        keyPadInputView
                    }
                    .responder($focus, equals: .second)
                SUITextField(text: .constant(date.description))
                    .inputAccessoryView {
                        accessoryView
                    }
                    .inputView {
                        DatePicker("Select date", selection: $date)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                    }
                    .responder($focus, equals: .third)
            }
            .padding()
        }
        .uiTextFieldFont(toggleFont ? .monospacedSystemFont(ofSize: 50, weight: .medium) : nil)
        .uiTextFieldBorderStyle(.roundedRect)
    }

    var accessoryView: some View {
        VStack {
            HStack {
                Button(action: goPrevious) {
                    Text("<")
                        .frame(width: 30, height: 30)
                }
                .disabled(focus == .first)
                Button(action: goNext) {
                    Text(">")
                        .frame(width: 30, height: 30)
                }
                .disabled(focus == .third)
                Spacer()
                Text(text)
                Spacer()
                Button(action: {
                    focus = nil
                    isFocused = false
                }) {
                    Text("Dismiss")
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity)
    }

    func goNext() {
        if focus == .first {
            focus = .second
        } else if focus == .second {
            focus = .third
        }
    }

    func goPrevious() {
        if focus == .third {
            focus = .second
        } else if focus == .second {
            focus = .first
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
