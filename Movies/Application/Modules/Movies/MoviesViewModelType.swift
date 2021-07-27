//
//  MoviesViewModelType.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation
import RxSwift

protocol MoviesViewModelType {
    
    var isLoading: Observable<Bool> { get }
    var items: Observable<[MoviesViewItem]> { get }
    var title: Observable<String> { get }
    
    func filter(with criteria: String?)
    func load(fromBeginning: Bool)
    func showDetails(forItemAt index: Int)
}
