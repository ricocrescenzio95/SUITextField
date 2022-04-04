//
//  ResponderStorage.swift
//  
//
//  Created by Rico Crescenzio on 03/04/22.
//

import Foundation

class ResponderStorage: ObservableObject {

    static let responderQueue = OperationQueue()

    var erasedValue: AnyHashable? {
        get { fatalError("Must subclass") }
        set { objectWillChange.send() }
    }

    var values = Set<AnyHashable>()

    let defaultValue: Any

    init(defaultValue: Any) {
        self.defaultValue = defaultValue
    }

}

class AnyHashableResponderStorage: ResponderStorage {

    @Published var value: Any

    override var erasedValue: AnyHashable? {
        get { value as? AnyHashable }
        set {
            value = newValue ?? defaultValue
            super.erasedValue = newValue
        }
    }

    init<Value>(value: Value) where Value: Hashable {
        self.value = value

        super.init(defaultValue: value)
    }

}

class BoolResponderStorage: ResponderStorage {

    @Published var value: Bool = false

    override var erasedValue: AnyHashable? {
        get { value }
        set {
            value = newValue as? Bool ?? false
            super.erasedValue = newValue
        }
    }

}
