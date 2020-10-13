//
//  MovieDetailsViewModelTests.swift
//  MoviesTests
//
//  Created by Andrii Hanchak on 08.10.2020.
//

import Foundation
import RxSwift
import RxTest
import XCTest

@testable import Movies

final class MovieDetailsViewModelTests: XCTestCase {

    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func testWatchTrailer_whenTrailerURLIsAvailable_shouldEmitShowPlayerViewWithURL() {
        let movie = Movie.stubbed(title: "Movie with trailer.")
        let movieVideo = MovieVideo(key: "video")
        let movieService = MovieServiceMock()
        let trailerService = TrailerServiceMock()
        let viewModel = MovieDetailsViewModel(movie: movie,
                                              movieService: movieService,
                                              posterService: PosterServiceMock(),
                                              trailerService: trailerService,
                                              errorController: ErrorController())
        let expectation = self.expectation(description: "watchTrailer")
        let expectedURL = URL(string: "https://youtube.com/v/\(movieVideo.key)")!
        let expectedEvents: [Recorded<Event<URL>>] = [.next(0, expectedURL)]
        let observer = scheduler.createObserver(URL.self)
        
        viewModel.isLoading
            .scan(0, accumulator: { (sum, _) in sum + 1 })
            .subscribe(onNext: { _ in viewModel.watchTrailer() })
            .disposed(by: disposeBag)
        
        viewModel.onShowPlayerView
            .subscribe(onNext: { _ in expectation.fulfill() })
            .disposed(by: disposeBag)
        
        viewModel.onShowPlayerView
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        movieService.movie = movie
        movieService.movieVideos = [MovieVideo(key: "video")]
        trailerService.movieVideo = movieVideo
        
        viewModel.loadDetails()
    
        waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(observer.events, expectedEvents)
        }
    }
}
