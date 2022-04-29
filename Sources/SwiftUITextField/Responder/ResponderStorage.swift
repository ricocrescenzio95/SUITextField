//
//  ResponderStorage.swift
//  
//
//  Created by Rico Crescenzio on 03/04/22.
//

import Foundation

class ResponderStorage: ObservableObject {

    @Published var value: AnyHashable?

    var values = Set<AnyHashable>()

    private let isBool: Bool

    init<H>(value: H?) where H: Hashable {
        self.value = value
        isBool = H.self == Bool.self
    }
    
    func resetDefault() {
        if isBool {
            value = false
        } else {
            value = nil
        }
    }

}

//class AnyHashableResponderStorage: ResponderStorage {
//
//    @Published var value: Any
//
//    override var erasedValue: AnyHashable? {
//        get { value as? AnyHashable }
//        set {
//            value = newValue ?? defaultValue
//            super.erasedValue = newValue
//        }
//    }
//
//    init<Value>(value: Value) where Value: Hashable {
//        self.value = value
//
//        super.init(defaultValue: value)
//    }
//
//}
//
///// Concrete `ResponderStorage` for bool binding.
//class BoolResponderStorage: ResponderStorage {
//
//    @Published var value: Bool = false
//
//    override var erasedValue: AnyHashable? {
//        get { value }
//        set {
//            value = newValue as? Bool ?? false
//            super.erasedValue = newValue
//        }
//    }
//
//}
