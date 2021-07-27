//
//  UITableViewCell.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import UIKit

extension UITableViewCell {
    
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }

    final class func dequeueReusableCell(from tableView: UITableView, at indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(withIdentifier: defaultReuseIdentifier, for: indexPath) as! Self
    }
}
