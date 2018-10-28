//: Playground - noun: a place where people can play

import UIKit

typealias CallBack = (Bool)->Void


class Listener {
    var name:String!
    var callBack:CallBack = { _ in }
}


typealias EventCallBack = (Bool)->Void
class Example {
    var eventCallBack:EventCallBack
    var eventCallBackList:[EventCallBack] = []
    var closureArray: [() -> ()] = []

    var listeners:[Listener] = []
    
    init() {
        
        self.eventCallBack = { done in
           print("did calle")
        }
        
        self.eventCallBackList.forEach { (callback) in
            callback(true)
        }
        
        self.closureArray.append { print("something one") }
        self.closureArray.append { print("something two") }
        self.closureArray[0]()
        self.closureArray[1]()
        
        let eventCallBack1:EventCallBack = { done in }
        eventCallBack1(true)
        self.eventCallBackList.append(eventCallBack1)

        let eventCallBack2:EventCallBack = { done in }
        eventCallBack2(false)
        self.eventCallBackList.append(eventCallBack2)
        
        // Listener Class Approach
        // Prima ti metti in ascolto e poi invia messaggo
        let listen1 = Listener()
        listen1.name = "First Listener"
        self.listeners.append(listen1)
        
        let listen2 = Listener()
        listen2.name = "Second Listener"
        self.listeners.append(listen2)
        
        self.listeners.forEach { (listener) in
            listener.callBack = { done in
                print("Print listening")
            }
            listener.callBack(true)
        }
        
//        listen1.callBack(true)
//        listen2.callBack(true)
    }
}

let ex = Example()
ex.eventCallBack(true)

