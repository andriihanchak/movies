//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import RxCocoa
import RxSwift
import UIKit

final class MovieDetailsViewController: UITableViewController {
    
    var viewModel: MovieDetailsViewModelType?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserInterface()
        configureBindings()
        
        viewModel?.loadDetails()
    }

    private func configureBindings() {
        if let refreshControl = refreshControl {
            refreshControl.rx.controlEvent(.valueChanged)
                .subscribe(onNext: { [weak self] in self?.viewModel?.loadDetails() })
                .disposed(by: disposeBag)
            
            viewModel?.isLoading
                .skip(2)
                .bind(to: refreshControl.rx.isRefreshing)
                .disposed(by: disposeBag)
        }
        
        viewModel?.items.bind(to: tableView.rx.items) { [weak self] (tableView, index, item) in
            let indexPath = IndexPath(row: index, section: 0)
            
            switch item {
            case let item as MovieDetailsViewMediaItem:
                let cell = MovieDetailsViewMediaCell.dequeueReusableCell(from: tableView, at: indexPath)
                
                cell.configure(with: item)
                cell.onWatchTrailer = { self?.viewModel?.watchTrailer() }
                
                return cell
                
            case let item as MovieDetailsViewTextItem:
                let cell = MovieDetailsViewTextCell.dequeueReusableCell(from: tableView, at: indexPath)
                
                cell.configure(with: item)
                
                return cell
                
            default:
                return .init()
            }
        }.disposed(by: disposeBag)
        
        viewModel?.title.bind(to: rx.title)
            .disposed(by: disposeBag)
    }
    
    private func configureUserInterface() {
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = .init()
    }
}
