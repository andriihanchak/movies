//
//  MoviesViewController.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import RxCocoa
import RxSwift
import UIKit

final class MoviesViewController: UITableViewController {
    
    var viewModel: MoviesViewModelType?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserInterface()
        configureBindings()
        
        viewModel?.load()
    }
    
    private func configureBindings() {
        tableView.rx.contentOffset
            .compactMap { [weak self] (offset) -> Bool? in
                guard let tableView = self?.tableView
                else { return false }
                return tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height)
            }.skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (loadMore) in loadMore ? self?.viewModel?.load() : () })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                self?.viewModel?.showDetails(forItemAt: indexPath.row)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(of: MovieDetailsViewController.self)
                
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
        
        viewModel?.items.bind(to: tableView.rx.items(cellIdentifier: MoviesViewCell.defaultReuseIdentifier,
                                                     cellType: MoviesViewCell.self)) { (row, item, cell) in
            cell.configure(with: item)
        }.disposed(by: disposeBag)
        
        viewModel?.title.bind(to: rx.title)
            .disposed(by: disposeBag)
    }
    
    private func configureUserInterface() {
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rowHeight = 100
        tableView.tableFooterView = .init(frame: .zero)
    }
}
