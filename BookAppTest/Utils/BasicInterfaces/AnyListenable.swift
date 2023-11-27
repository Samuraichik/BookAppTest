//
//  AnyListenable.swift
//  Rococo
//
//  Created by oleksiy humenyuk on 15.08.2023.
//

import Foundation

protocol ListenableEvent {}

protocol AnyListenable: AnyObject {
    associatedtype Event where Event: ListenableEvent
    
    var listeners: [(AnyListener, Event)] { get set }
    
    func add(listener: AnyListener, for event: [Event])
    func remove(listener: AnyListener)
    func removeAllListeners()
}

extension AnyListenable {
    func add(listener: AnyListener, for event: [Event]) {
        event.forEach {
            listeners.append((listener, $0))
        }
    }
    
    func remove(listener: AnyListener) {
        listeners = listeners.filter { $0.0.id != listener.id }
    }
    
    func removeAllListeners() {
        listeners.removeAll()
    }
}
