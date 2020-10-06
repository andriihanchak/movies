//
//  MoviesViewModelType.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation
import RxSwift

protocol MoviesViewModelType {
    
    var items: Observable<[MoviesViewItem]> { get }
    var title: Observable<String> { get }
    
    func filter(with criteria: String?)
    func load()
    func showDetails(forItemAt index: Int)
}
