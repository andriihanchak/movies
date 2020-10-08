//
//  Coordinator.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation

class Coordinator: CoordinatorType, CoordinatorDelegate {
   
    final weak var delegate: CoordinatorDelegate?
    
    final let id: UUID = UUID()
    final private var coordinators: [UUID: CoordinatorType] = [:]
    
    func start() {
        fatalError("This method must be implemented by a subclass.")
    }

    final func start(coordination coordinator: Coordinator) {
        attach(coordinator: coordinator)
        
        coordinator.delegate = self
        coordinator.start()
    }
    
    func finish() {
        delegate?.finish(self)
    }
    
    final func finish(_ coordinator: CoordinatorType) {
        detach(coordinator: coordinator)
    }

    final private func attach(coordinator: CoordinatorType) {
        coordinators[coordinator.id] = coordinator
    }
    
    final private func detach(coordinator: CoordinatorType) {
        coordinators[coordinator.id] = nil
    }
}
