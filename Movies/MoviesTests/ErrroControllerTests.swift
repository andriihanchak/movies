//
//  ErrroControllerTests.swift
//  MoviesTests
//
//  Created by Andrii Hanchak on 13.10.2020.
//

import Foundation
import RxBlocking
import XCTest

@testable import Movies

final class ErrroControllerTests: XCTestCase {
    
    private var errorController: ErrorController!
    
    override func setUpWithError() throws {
        errorController = ErrorController()
    }
    
    func testShowError_withKnownError_shouldEmitErrorMessage() {
        let observable = errorController.onShowError
        let errors: [Error] = [.getMovieDetails, .getMovieVideos, .getPopularMovies, .notConnectedToInternet]
        let messages = ["Couldn't get some movie details. Please, try again.",
                        "Couldn't get movie trailer. Please, try again.",
                        "Couldn't get movies. Please, try again.",
                        "No network connection. Please, try again."]
        
        for error in errors.enumerated() {
            errorController.showError(error.element)
            
            XCTAssertEqual(try observable.toBlocking().first(), messages[error.offset])
        }
    }
    
    func testShowError_withUnknownError_shouldEmitDefaultErrorMessage() {
        let observable = errorController.onShowError
        let error = NSError(domain: "error", code: 0, userInfo: [:])
        let message = "Something went wrong. Please, try again."
        
        errorController.showError(error)
        
        XCTAssertEqual(try observable.toBlocking().first(), message)
    }
}
