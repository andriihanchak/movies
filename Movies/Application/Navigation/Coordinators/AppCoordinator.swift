//
//  AppCoordinator.swift
//  Movies
//
//  Created by Andrii Hanchak on 27.07.2021.
//

import Foundation
import RxSwift

final class AppCoordinator: Coordinator<Void> {
    
    private let appContext: AppContext
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(appContext: AppContext) {
        self.appContext = appContext
    }
    
    override func start() -> Observable<Void> {
        let coordinator = MoviesViewCoordinator(appContext: appContext)
        
        return start(coordinator)
    }
}
