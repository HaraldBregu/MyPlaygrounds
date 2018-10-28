//: Playground - noun: a place where people can play

import Foundation

private class Invoker<EventData> {
    weak var listener: AnyObject?
    let closure: (EventData) -> Bool
    
    init<Listener : AnyObject>(listener: Listener, method: @escaping (Listener) -> (EventData) -> Void) {
        self.listener = listener
        self.closure = {
            [weak listener] (data: EventData) in
            guard let listener = listener else {
                return false
            }
            method(listener)(data)
            return true
        }
    }
}

class Event<EventData> {
    private var invokers = [Invoker<EventData>]()
    
    /// Adds an event listener, notifying the provided method when the event is emitted.
    func addListener<Listener : AnyObject>(listener: Listener, method: @escaping (Listener) -> (EventData) -> Void) {
        invokers.append(Invoker(listener: listener, method: method))
    }
    
    /// Removes the object from the list of objects that get notified of the event.
    func removeListener(listener: AnyObject) {
        invokers = invokers.filter {
            guard let current = $0.listener else {
                return false
            }
            return current !== listener
        }
    }
    
    /// Publishes the specified data to all listeners via the global utility dispatch queue.
    func emit(data: EventData) {
        let queue = DispatchQueue.global(Int(QOS_CLASS_UTILITY.rawValue), 0)
        for invoker in invokers {
            dispatch_async(queue) {
                // TODO: If this returns false, we should remove the invoker from the list.
                invoker.closure(data)
            }
        }
    }
}

// MARK: - Demo
class Player {
    // A simple tuple to demonstrate multi-value events (could also be a struct/class of course).
    typealias TrackData = (file: String, duration: Int)
    
    // An event with no additional information.
    let paused = Event<Void>()
    // Another event that emits TrackData.
    let trackChanged = Event<TrackData>()
    
    // Demo function to show an event being emitted.
    func emitStuff() {
        // Emit the track changed event to all listeners.
        trackChanged.emit(data: (file: "song1.mp3", duration: 123))
        // No need to pass in data if the event data type is Void.
        paused.emit(data: )
    }
}

class MyClass {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("Releasing \(name)!")
    }
    
    // Events with event type Void don't require any argument in the handler.
    func handlePause() {
        print("Handling pause in \(name)!")
    }
    
    // Note that tuples can be expanded in the handler signature, which makes the code cleaner.
    func handleTrackChanged(file: String, duration: Int) {
        print("Handling track changed to \(file) (\(duration) sec) in \(name)!")
    }
}

let player = Player()

// Adding event handlers to different objects is simple.
let c1: MyClass = MyClass(name: "One")
player.trackChanged.addListener(listener: c1, method: MyClass.handleTrackChanged(c1))

let c2: MyClass = MyClass(name: "Two")
player.paused.addListener(listener: c2, method: MyClass.handlePause(c2))
player.trackChanged.addListener(listener: c2, method: MyClass.handleTrackChanged(c2))

// This is how you explicitly unregister an object from handling an event.
player.trackChanged.removeListener(listener: c2)

// Objects that are not retained elsewhere will automatically be unregistered for events.
func scope() {
    // c3 will be released at the end of this scope, so its handlePause method will never be called.
    let c3: MyClass = MyClass(name: "Three")
    player.paused.addListener(listener: c3, method: MyClass.handlePause(c3))
}
scope()

// Emit the events to all the listeners.
player.emitStuff()
