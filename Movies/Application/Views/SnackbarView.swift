//
//  SnackbarView.swift
//  Movies
//
//  Created by Andrii Hanchak on 07.10.2020.
//

import UIKit

final class SnackbarView: UIView {
    
    @IBOutlet private weak var label: UILabel!
    
    private let defaultHeight: CGFloat = 44.0
    private var height: CGFloat = 0
    private var heightConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        calculateHeight()
        
        heightConstraint?.constant = height
        topConstraint?.constant = -height
    }
    
    func embedded(into view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self)
        view.bringSubviewToFront(self)
        
        calculateHeight()
        
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        heightConstraint = heightAnchor.constraint(equalToConstant: height)
        heightConstraint?.isActive = true
        
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
            self.alpha = alpha
            self.superview?.layoutIfNeeded()
        }
    }

    private func calculateHeight() {
        if #available(iOS 11.0, *) {
            height = defaultHeight + (superview?.safeAreaInsets.top ?? 0)
        } else {
            height = defaultHeight + statusBarHeight()
        }
    }
    
    private func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }
}
