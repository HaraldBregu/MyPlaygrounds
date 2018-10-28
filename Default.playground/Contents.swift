//: Playground - noun: a place where people can play

import UIKit

class Default {
    static let shared = Default()
    subscript(key: String) -> Any? {
        get {
            return UserDefaults.standard.object(forKey: key)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}

Default.shared["username"] = "John"
print(Default.shared["username"])

Default.shared["lastname"] = "Doe"
print(Default.shared["lastname"])

Default.shared["names"] = ["aldi", "gimi", "Arta", 3, 3, Date()]
print(Default.shared["names"])
