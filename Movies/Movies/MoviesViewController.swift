//
//  MoviesViewController.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import RxCocoa
import RxSwift
import UIKit

final class MoviesViewController: UIViewController {
    
    var viewModel: MoviesViewModelType?
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserInterface()
        configureBindings()
        
        viewModel?.load()
    }
    
    private func configureBindings() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
            .compactMap { $0.cgRectValue }
            .compactMap { $0.size.height }
            .bind(to: searchBarBottomConstraint.rx.constant)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .compactMap { _ in 0 }
            .bind(to: searchBarBottomConstraint.rx.constant)
            .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [weak self] in self?.view.endEditing(true) })
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .subscribe(onNext: { (text) in print(text ?? "no search") })
            .disposed(by: disposeBag)
        
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
            }).disposed(by: disposeBag)
        
        viewModel?.items.bind(to: tableView.rx.items(cellIdentifier: MoviesViewCell.defaultReuseIdentifier,
                                                     cellType: MoviesViewCell.self)) { (row, item, cell) in
            cell.configure(with: item)
        }.disposed(by: disposeBag)
        
        viewModel?.title.bind(to: rx.title)
            .disposed(by: disposeBag)
    }
    
    private func configureUserInterface() {
        searchBar.backgroundColor = .gray
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
        
        tableView.rowHeight = 100
        tableView.tableFooterView = .init(frame: .zero)
    }
}
