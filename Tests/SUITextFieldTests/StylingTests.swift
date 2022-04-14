//
//  StylingTests.swift
//
//
//  Created by Rico Crescenzio on 14/04/22.
//

import XCTest
@testable import SwiftUITextField
import SnapshotTesting
import SwiftUI

final class StylingTests: CoreTestCase {
    
    private func testBorder(_ border: UITextField.BorderStyle, testName: String = #function) {
        let view = SUITextField(text: .constant("test"))
            .onUpdate {
                XCTAssertEqual($0.borderStyle, border)
            }
            .uiTextFieldBorderStyle(border)
        assertSnapshot(matching: view,
                       named: "textField",
                       testName: testName)
    }
    
    private func testAlignment(_ alignment: NSTextAlignment, testName: String = #function) {
        let view = SUITextField(text: .constant("test"))
            .onUpdate {
                XCTAssertEqual($0.textAlignment, alignment)
            }
            .frame(width: 200)
            .uiTextFieldTextAlignment(alignment)
        assertSnapshot(matching: view,
                       named: "textField",
                       testName: testName)
    }

    func testInitialState() {
        let view = SUITextField(text: .constant("test"))
            .onUpdate {
                XCTAssertEqual($0.borderStyle, .none)
            }
            .uiTextFieldBorderStyle(.none)
        assertSnapshot(matching: view, named: "textField")
        assertSnapshot(matching: SUITextField(text: .constant("test")), named: "textField")
    }
    
    func testRoundedRectBorder() {
        testBorder(.roundedRect)
    }

    func testBezelBorder() {
        testBorder(.bezel)
    }
    
    func testLineBorder() {
        testBorder(.line)
    }
    
    func testTextColor() {
        let view = SUITextField(text: .constant("test"))
            .onUpdate {
                XCTAssertEqual($0.textColor, .systemBlue)
            }
            .uiTextFieldTextColor(.systemBlue)
        assertSnapshot(matching: view, named: "textField")
    }
    
    func testLeftAlignment() {
        testAlignment(.left)
    }
    
    func testRightAlignment() {
        testAlignment(.right)
    }
    
    func testCenterAlignment() {
        testAlignment(.center)
    }
    
    func testNaturalAlignment() {
        testAlignment(.natural)
    }
    
    func testJustifiedAlignment() {
        testAlignment(.justified)
    }

}
