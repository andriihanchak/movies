//
//  MoviesViewModelTests.swift
//  MoviesTests
//
//  Created by Andrii Hanchak on 08.10.2020.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest

@testable import Movies

final class MoviesViewModelTests: XCTestCase {

    private var disposeBag: DisposeBag!
    private var movieService: MovieServiceMock!
    private var scheduler: TestScheduler!
    private var viewModel: MoviesViewModel!
    
    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        movieService = MovieServiceMock()
        scheduler = TestScheduler(initialClock : 0)
        viewModel = MoviesViewModel(movieService: movieService, posterService: PosterServiceMock())
    }
    
    func testTitle_emitsTitle() {
        let observable = viewModel.title
        
        XCTAssertEqual(try observable.toBlocking().single(), "Movies")
    }
    
    func testLoad_whenFilterIsEmpty_shouldEmitIsLoadingSequence() {
        let expectation = self.expectation(description: "isLoading")
        let expectedEvents: [Recorded<Event<Bool>>] = [.next(0, false), .next(0, true), .next(0, false)]
        let observer = scheduler.createObserver(Bool.self)
    
        viewModel.items
            .filter { !$0.isEmpty }
            .subscribe(onNext: { _ in expectation.fulfill() })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        movieService.popularMovie = TMDBPopularMovie(page: 1, results: [.stubbed(title: "Star Wars")])
        
        viewModel.filter(with: "")
        viewModel.load(fromBeginning: true)
    
        waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(observer.events, expectedEvents)
        }
    }
    
    func testLoad_whenFilterIsNotEmpty_shouldIgonoreLoading() {
        let expectedEvents: [Recorded<Event<Bool>>] = [.next(0, false)]
        let observer = scheduler.createObserver(Bool.self)
        
        viewModel.isLoading
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        viewModel.filter(with: "search")
        viewModel.load(fromBeginning: true)
    
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testLoad_whenMovieServiveSucceeds_shouldEmitMoviesViewItems() {
        let expectation = self.expectation(description: "firstPageMovies")
        let expectedMovies: [Movie] = [.stubbed(title: "1"), .stubbed(title: "2"), .stubbed(title: "3")]
        let expectedItems: [MoviesViewItem] = expectedMovies.compactMap { .init(title: $0.title, posterURL: nil) }
        let observer = scheduler.createObserver([MoviesViewItem].self)
        
        viewModel.items
            .filter { !$0.isEmpty }
            .subscribe(onNext: { _ in expectation.fulfill() })
            .disposed(by: disposeBag)
        
        viewModel.items
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        movieService.popularMovie = TMDBPopularMovie(page: 1, results: expectedMovies)
        
        viewModel.filter(with: "")
        viewModel.load(fromBeginning: true)
    
        waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(observer.events.last, .next(0, expectedItems))
        }
    }
    
    func testLoad_whenMovieServiceFails_shouldEmitError() {
        let expectation = self.expectation(description: "error")
        let expectedErrors = ["Couldn't get movies. Please, try again.",
                              "No network connection. Please, try again."]
        let expectedEvents: [Recorded<Event<String>>] = expectedErrors.compactMap { .next(0, $0) }
        let observer = scheduler.createObserver(String.self)
        
        viewModel.onShowErrorView
            .scan(0, accumulator: { (sum, _) in sum + 1 })
            .filter { $0 == expectedEvents.count  }
            .subscribe(onNext: { _ in expectation.fulfill() })
            .disposed(by: disposeBag)
        
        viewModel.onShowErrorView
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        viewModel.filter(with: "")
        
        movieService.error = Error.getPopularMovies
        viewModel.load(fromBeginning: true)
        
        movieService.error = Error.notConnectedToInternet
        viewModel.load(fromBeginning: false)
    
        waitForExpectations(timeout: 5.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(observer.events, expectedEvents)
            
        }
    }
}
