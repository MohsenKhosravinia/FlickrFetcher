//
//  UICollectionView+Reuse.swift
//  FlickrFetcher
//
//  Created by Mohsen Khosravinia on 5/20/22.
//

import UIKit

extension UICollectionView {
    
    func dequeue<T: UICollectionViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {
        if let dequeuedCell = dequeueReusableCell(withReuseIdentifier: String(describing: cell),
                                                  for: indexPath) as? T {
            return dequeuedCell
        }
        return T()
    }
    
    func register<T: UICollectionViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: String(describing: cell), bundle: nil),
                      forCellWithReuseIdentifier: String(describing: cell))
    }
}
