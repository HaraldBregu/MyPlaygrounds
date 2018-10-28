//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class TestProt {
    required init() {
    
    }
    
    func testMe() -> String {
        return ""
    }
}

class TestClass: TestProt {
    
    // This init is required in order
    // to construct an instance with
    // a metatype value (class.init())
    override required init() {
    }
    
    override func testMe() -> String {
        return "Hello from TestClass"
    }
}

let theClass = TestProt.self

let anyclassis: AnyClass = TestClass.self
anyclassis
anyclassis.type

let tInst:TestClass  = theClass.init() as! TestClass
tInst.testMe()








