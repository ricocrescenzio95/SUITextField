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
        case fifth
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
        .foregroundColor: UIColor.systemOrange,
        .font: UIFont.systemFont(ofSize: 20, weight: .black),
        .paragraphStyle: {
            let p = NSMutableParagraphStyle()
            p.alignment = .right
            return p
        }()
    ]
    
    let moreKern: [NSAttributedString.Key: Any] = [
        .kern: 15,
    ]
    
    let placeholderAttributes: [NSAttributedString.Key: Any] = [
        .kern: 5,
        .foregroundColor: UIColor.systemGray
    ]
  
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
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
                        .uiTextFieldDefaultTextAttributes(moreKern, mergePolicy: .keepNew)
                    SUITextField(text: $text)
                        .inputAccessoryView {
                            navigator
                        }
                        .responder($focus, equals: .second)
                    if #available(iOS 15, *) {
                        SUITextField(
                            value: $myDouble,
                            format: .number,
                            formatPolicy: .onChange,
                            placeholder: AttributedString("Hey there")
                                .mergingAttributes(AttributeContainer(placeholderAttributes))
                        )
                        .inputAccessoryView {
                            navigator
                        }
                        .responder($focus, equals: .third)
                        .uiTextFieldTextColor(.systemGreen)
                    }
                    SUITextField(value: $date, formatter: formatter)
                        .inputAccessoryView {
                            navigator
                        }
                        .inputView {
                            datePicker
                        }
                        .responder($focus, equals: .fourth)
                        .uiTextFieldFont(.systemFont(ofSize: 14, weight: .light))
                }
                .uiTextFieldDefaultTextAttributes(attributes)
                .padding()
                SUITextField(value: $date, formatter: formatter)
                    .inputAccessoryView {
                        navigator
                    }
                    .inputView {
                        datePicker
                    }
                    .responder($focus, equals: .fifth)
                    .uiTextFieldDefaultTextAttributes(attributes, mergePolicy: .keepOld)
                    .uiTextFieldTextColor(.systemRed)
                    .uiTextFieldFont(.italicSystemFont(ofSize: 12))
            }
            .uiTextFieldFont(.systemFont(ofSize: 14, weight: .light))
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
