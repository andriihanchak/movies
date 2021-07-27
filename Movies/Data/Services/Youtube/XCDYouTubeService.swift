//
//  XCDYouTubeService.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation
import RxSwift
import XCDYouTubeKit

final class XCDYouTubeService: TrailerService {
    
    func getMovieTrailerURL(_ movieVideo: MovieVideo) -> Observable<URL?> {
        let client: XCDYouTubeClient = .default()
        let identifier = movieVideo.key.replacingOccurrences(of: "/", with: "")
        
        return Single<URL?>.create { (promise) -> Disposable in
            client.getVideoWithIdentifier(identifier) { (video, error) in
                guard let video = video, error == nil
                else { return promise(.success(nil)) }
                
                promise(.success(video.streamURL))
            }
            
            return Disposables.create()
        }.asObservable()
    }
}
