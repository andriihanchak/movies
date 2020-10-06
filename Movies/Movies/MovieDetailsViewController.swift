//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import UIKit

final class MovieDetailsViewController: UITableViewController {
    
    var items: [MovieDetailsViewItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = .init()
    }
}

extension MovieDetailsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch item {
        case let item as MovieDetailsViewMediaItem:
            let cell = MovieDetailsViewMediaCell.dequeueReusableCell(from: tableView, at: indexPath)
            
            cell.configure(with: item)
            
            return cell
            
        case let item as MovieDetailsViewTextItem:
            let cell = MovieDetailsViewTextCell.dequeueReusableCell(from: tableView, at: indexPath)
            
            cell.configure(with: item)
            
            return cell
            
        default:
            return .init()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
