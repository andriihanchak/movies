//
//  ErrorController.swift
//  Movies
//
//  Created by Andrii Hanchak on 13.10.2020.
//

import Foundation
import RxRelay
import RxSwift

protocol ErrorControllerType {
    
    var onShowError: Observable<String> { get }
    
    func showError(_ error: Swift.Error)
}

final class ErrorController: ErrorControllerType {
    
    var onShowError: Observable<String> { showError.compactMap { $0 } }
    
    private let showError: BehaviorRelay<String?> = .init(value: nil)
    
    func showError(_ error: Swift.Error) {
        switch error {
        case Error.getMovieDetails:
            showError.accept("Couldn't get some movie details. Please, try again.")
            
        case Error.getMovieVideos:
            showError.accept("Couldn't get movie trailer. Please, try again.")
            
        case Error.getPopularMovies:
            showError.accept("Couldn't get movies. Please, try again.")
            
        case Error.notConnectedToInternet:
            showError.accept("No network connection. Please, try again.")
            
        default:
            showError.accept("Something went wrong. Please, try again.")
        }
    }
}
