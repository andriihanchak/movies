//
//  MoviesViewItem.swift
//  MoviesTests
//
//  Created by Andrii Hanchak on 08.10.2020.
//

import Foundation

@testable import Movies

extension MoviesViewItem: Equatable {
    
    static public func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.title == rhs.title && lhs.posterURL == rhs.posterURL
    }
}
 
