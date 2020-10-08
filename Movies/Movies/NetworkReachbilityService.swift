//
//  NetworkReachbilityService.swift
//  Movies
//
//  Created by Andrii Hanchak on 07.10.2020.
//

import Foundation
import RxSwift

protocol NetworkReachbilityService {
    
    var connectionLost: Observable<Void> { get }
    
    func startMonitoring()
    func stopMonitoring()
}
