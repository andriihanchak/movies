//
//  TMDBPosterServiceTests.swift
//  MoviesTests
//
//  Created by Andrii Hanchak on 08.10.2020.
//

import XCTest

@testable import Movies

final class TMDBPosterServiceTests: XCTestCase {

    private var posterService: TMDBPosterService!
    
    override func setUpWithError() throws {
        posterService = TMDBPosterService()
    }
    
    func testMovieGetPosterURL_whenPosterPathIsNil_shouldReturnNil() {
        let movie = Movie.stubbed(title: "Movies without poster.")
        let url = posterService.getMoviePosterURL(movie, size: .movies)
    
        XCTAssertNil(url)
    }
    
    func testMovieGetPosterURL_whenPosterPathIsNotNil_shouldReturnPosterURL() {
        let posterPath = "/moviePoster.png"
        let size = PosterSize.movies
        let movie = Movie.stubbed(title: "Movies with poster.", posterPath: posterPath)
        let posterBaseURL = URL(string: "https://image.tmdb.org")!
        let posterExpectedURL = posterBaseURL.appendingPathComponent("/t/p/\(size.rawValue)\(posterPath)")
        let url = posterService.getMoviePosterURL(movie, size: size)
        
        XCTAssertEqual(url, posterExpectedURL)
    }
}
