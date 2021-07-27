//
//  NetworkReachibilityService.swift
//  Movies
//
//  Created by Andrii Hanchak on 07.10.2020.
//

import Alamofire
import Foundation
import RxRelay
import RxSwift

final class AlamofireNetworkReachibilityService: NetworkReachbilityService {
    
    var connectionLost: Observable<Void> {
        return isReachable.filter { (isReachable) in !isReachable }
                            .compactMap { _ in Void() }
    }
    
    private let disposeBag = DisposeBag()
    private let isReachable: BehaviorRelay<Bool> = .init(value: true)
    private let manager = Alamofire.NetworkReachabilityManager(host: "api.themoviedb.org")
    
    func startMonitoring() {
        manager?.startListening(onUpdatePerforming: { [weak self] (status) in
            guard let self = self,
                  let manager = self.manager
            else { return }
            
            self.isReachable.accept(manager.isReachable)
        })
    }
    
    func stopMonitoring() {
        manager?.stopListening()
    }
}
