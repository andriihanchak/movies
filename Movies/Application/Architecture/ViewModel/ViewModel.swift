//
//  ViewModel.swift
//  Movies
//
//  Created by Andrii Hanchak on 27.07.2021.
//

import Foundation
import RxSwift

class ViewModel {
    
    final var onDeinitialize: Observable<Void> { deinitialize.asObservable() }
    
    private let deinitialize = PublishSubject<Void>()
    
    deinit {
        deinitialize.on(.next(()))
        deinitialize.on(.completed)
    }
}
