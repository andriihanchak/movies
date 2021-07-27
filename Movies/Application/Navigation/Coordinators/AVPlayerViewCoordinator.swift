//
//  AVPlayerViewCoordinator.swift.swift
//  Movies
//
//  Created by Andrii Hanchak on 27.07.2021.
//

import AVKit
import RxSwift
import UIKit

final class AVPlayerViewCoordinator: Coordinator<Void> {
    
    private let navigationController: UINavigationController
    private let videoURL: URL
    
    init(navigationController: UINavigationController, videoURL: URL) {
        self.navigationController = navigationController
        self.videoURL = videoURL
    }
    
    override func start() -> Observable<Void> {
        let viewController = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        
        if #available(iOS 11.0, *) {
            viewController.entersFullScreenWhenPlaybackBegins = true
        }
        
        viewController.player = player
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissPlayerView),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: viewController.player?.currentItem)
        
        navigationController.present(viewController, animated: true) {
            player.play()
        }

        return viewController.onDeinitialize
            .asObservable()
    }
    
    @objc private func dismissPlayerView() {
        NotificationCenter.default.removeObserver(self)
        
        navigationController.dismiss(animated: true)
    }
}

extension AVPlayerViewCoordinator {
    
    final class AVPlayerViewController: AVKit.AVPlayerViewController {
        
        var onDeinitialize: Observable<Void> { deinitialize.asObservable() }
        
        private var deinitialize: PublishSubject<Void> = PublishSubject()
        
        deinit {
            deinitialize.on(.next(()))
            deinitialize.on(.completed)
        }
    }
}
