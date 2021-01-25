//
//  UIKit+Extension.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

// MARK: - UIView

extension UIView {
    
    static var name: String {
        return String(describing: self)
    }
    
}

// MARK: - UIViewController

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
    
    static func instantiate<T: UIViewController>(from storyboard: Storyboard) -> T {
        return storyboard.viewController(viewControllerTypes: T.self)
    }
}

// MARK: - UITableView
extension UICollectionView {
    
    func register(type: UICollectionViewCell.Type) {
        let typeName = type.name
        let nib = UINib(nibName: typeName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: typeName)
    }
    
    func register(type: UICollectionReusableView.Type, kind: String) {
        let typeName = type.name
        let nib = UINib(nibName: typeName, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: typeName)
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.name, for: indexPath) as! T
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: type.name, for: indexPath) as! T
    }

}

