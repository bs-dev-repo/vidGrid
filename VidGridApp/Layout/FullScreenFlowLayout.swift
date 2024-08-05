//
//  FullScreenFlowLayout.swift
//  VidGridApp
//
//  Created by Apple on 05/08/24.
//

import UIKit

class FullScreenFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        for attribute in attributes {
            if attribute.representedElementCategory == .cell {
                let centerX = collectionView!.bounds.size.width / 2
                let cellCenterX = attribute.center.x
                let distanceFromCenter = abs(centerX - cellCenterX)
                
                // Adjust cell size based on distance from the center
                let scaleFactor = max(0.75, 1 - distanceFromCenter / collectionView!.bounds.size.width)
                attribute.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
                attribute.zIndex = Int(scaleFactor * 10) // Adjust zIndex to make sure scaled cells are on top
            }
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        
        let contentSize = super.collectionViewContentSize
        let adjustedHeight = max(contentSize.height, collectionView.bounds.height)
        
        return CGSize(width: contentSize.width, height: adjustedHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
        return attributes
    }
}
