//: Playground - noun: a place where people can play

import UIKit

var items = ["A", "B", "C", "D", "E", "F", "G", "H"]
var shuffled = [String]();

for _ in 0..<items.count {
    let rand = Int(arc4random_uniform(UInt32(items.count)))
    
    shuffled.append(items[rand])
    
    items.remove(at: rand)
}

print(shuffled)


extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}


let x = [1, 2, 3].shuffled()
print(x)

// x == [2, 3, 1]

//let fiveStrings = stride(from: 0, through: 100, by: 5).map(String.init).shuffled()
// fiveStrings == ["20", "45", "70", "30", ...]

//var numbers = [1, 2, 3, 4]
//numbers.shuffle()
// numbers == [3, 2, 1, 4]
