//
//  MovieDetailsViewModelType.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation
import RxSwift

protocol MovieDetailsViewModelType {
 
    var isLoading: Observable<Bool> { get }
    var items: Observable<[MovieDetailsViewItem]> { get }
    var title: Observable<String> { get }
    
    func loadDetails()
    func watchTrailer()
}
