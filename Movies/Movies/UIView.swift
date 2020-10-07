//
//  UIView.swift
//  Movies
//
//  Created by Andrii Hanchak on 07.10.2020.
//

import UIKit

extension UIView {
        
    final class func instantiateFromNib<T: UIView>(named name: String? = nil) -> T {
        let bundle = Bundle(for: T.self)
        let nibName = name ?? String(describing: T.self)

        return bundle.loadNibNamed(nibName, owner: nil, options: nil)?.first as! T
    }
}
