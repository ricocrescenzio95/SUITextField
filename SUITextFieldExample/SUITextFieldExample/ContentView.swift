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
        NavigationView {
            ScrollView {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .padding(.vertical, 50)
                VStack {
                    SUITextField(text: $text)
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
                    if #available(iOS 15, *) {
                        SUITextField(
                            value: $myDouble,
                            format: .number,
                            placeholder: AttributedString("Hey there").mergingAttributes(AttributeContainer(placeholderAttributes))
                        )
                        .inputAccessoryView {
                            navigator
                        }
                        .responder($focus, equals: .third)
                        SUITextField(value: $date, format: .dateTime)
                            .inputAccessoryView {
                                navigator
                            }
                            .inputView {
                                datePicker
                            }
                            .responder($focus, equals: .fourth)
                    } else {
                        SUITextField(text: .constant(date.description))
                            .inputAccessoryView {
                                navigator
                            }
                            .inputView {
                                datePicker
                            }
                            .responder($focus, equals: .third)
                    }
                }
                .padding()
            }
            .uiTextFieldDefaultTextAttributes(attributes)
            .uiTextFieldFont(toggleFont ? .monospacedSystemFont(ofSize: 50, weight: .medium) : nil)
            .uiTextFieldBorderStyle(.roundedRect)
            .uiTextFieldAdjustsFontSizeToFitWidth(.enabled(minSize: 8))
            .navigationBarTitle("SUITextField")
        }
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
