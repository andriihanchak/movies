//
//  UIStoryboard.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import UIKit

extension UIStoryboard {
    
    final func instantiateViewController<T: UIViewController>(of type: T.Type) -> T {
        return instantiateViewController(withIdentifier: type.defaultStoryboardIdentifier) as! T
    }
}

