//
//  CoordinatorType.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation

protocol CoordinatorType {
    
    var id: UUID { get }
    
    func start()
    func finish()
}
