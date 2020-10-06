//
//  MoviesViewController.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import UIKit

final class MoviesViewController: UITableViewController {
    
    var items: [MoviesViewItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100
        tableView.tableFooterView = .init(frame: .zero)
    }
}

extension MoviesViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MoviesViewCell.dequeueReusableCell(from: tableView, at: indexPath)
        let item = items[indexPath.row]
        
        cell.configure(with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

extension MoviesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(of: MovieDetailsViewController.self)
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
}
