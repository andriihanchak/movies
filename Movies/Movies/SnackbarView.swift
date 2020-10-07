//
//  SnackbarView.swift
//  Movies
//
//  Created by Andrii Hanchak on 07.10.2020.
//

import UIKit

final class SnackbarView: UIView {
    
    @IBOutlet private weak var label: UILabel!
    
    private var height: CGFloat = 44.0
    private var topConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.alpha = 0.0
    }
    
    func embedded(into view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self)
        view.bringSubviewToFront(self)
        
        if #available(iOS 11.0, *) {
            height += view.safeAreaInsets.top
        }
        
        heightAnchor.constraint(equalToConstant: height).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        topConstraint = topAnchor.constraint(equalTo: view.topAnchor, constant: -height)
        topConstraint?.isActive = true
    }
    
    func show(message: String) {
        label.text = message
        superview?.bringSubviewToFront(self)
        
        animate(top: 0, alpha: 1.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.animate(top: -self.height, alpha: 0.0)
        }
    }
    
    private func animate(top: CGFloat, alpha: CGFloat) {
        topConstraint?.constant = top
        
        UIView.animate(withDuration: 0.5) {
            self.label.alpha = alpha
            self.superview?.layoutIfNeeded()
        }
    }
}
