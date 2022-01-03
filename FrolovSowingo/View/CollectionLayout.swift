// Name: Mikhail Frolov
// IOS DEV TEST
// CollectionLayout.swift

import Foundation
import UIKit

class CollectionLayout {
    
    static func createCollectionLayout() -> UICollectionViewLayout {
        
        let collectionLayout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: size)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
            
        }
        
        return collectionLayout
        
    }
}
