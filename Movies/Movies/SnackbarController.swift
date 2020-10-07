//
//  SnackbarController.swift
//  Movies
//
//  Created by Andrii Hanchak on 07.10.2020.
//

import RxSwift
import UIKit

final class SnackbarController {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let snackbarView: SnackbarView = .instantiateFromNib()
    
    init(networkReachabilityService: NetworkReachbilityService) {
        networkReachabilityService.connectionLost
            .subscribe(onNext: { [weak self] in self?.showMessage("No network connection.") })
            .disposed(by: disposeBag)
    }
    
    func initialize(with window: UIWindow) {
        snackbarView.embedded(into: window)
    }
    
    func showMessage(_ message: String) {
        snackbarView.show(message: message)
    }
}
