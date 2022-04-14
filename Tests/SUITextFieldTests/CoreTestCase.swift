//
//  CoreTestCase.swift
//  
//
//  Created by Rico Crescenzio on 14/04/22.
//

import XCTest
import SnapshotTesting
import SwiftUI

class CoreTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        XCTAssertEqual(UIDevice.current.name, "iPhone 11 Pro")
    }

    func assertSnapshot<V>(
        matching view: V,
        asLayer: Bool = false,
        named name: String,
        record recording: Bool = false,
        timeout: TimeInterval = 5,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) where V: View {
        let view = UIHostingController(rootView: view).view!
        SnapshotTesting.assertSnapshot(
            matching: view,
            as: .image(precision: 0.8, size: view.intrinsicContentSize),
            named: name,
            record: recording,
            file: file,
            testName: testName,
            line: line
        )
    }
    
}
