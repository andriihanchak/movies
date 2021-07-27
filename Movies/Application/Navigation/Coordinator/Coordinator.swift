//
//  Coordinator.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation
import RxSwift

class Coordinator<Output> {
    
    typealias ResultType = Output
    
    private var coordinators: [ObjectIdentifier: Any] = [:]
    
    final func start<Output>(_ coordinator: Coordinator<Output>) -> Observable<Output>  {
        append(coordinator)
        
        return coordinator.start()
            .do(onNext: { [weak self, weak coordinator] _ in
                guard let coordinator = coordinator
                else { return }
                
                self?.remove(coordinator)
            })
            .asObservable()
    }
    
    func start() -> Observable<Output> {
        fatalError("This method must be overrided in a subclass.")
    }
    
    private func append<Output>(_ coordinator: Coordinator<Output>) {
        let identifier = ObjectIdentifier(coordinator)
        
        coordinators[identifier] = coordinator
    }
    
    private func remove<Output>(_ coordinator: Coordinator<Output>) {
        let identifier = ObjectIdentifier(coordinator)
        
        coordinators[identifier] = nil
    }
}
