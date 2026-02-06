//
//  GridCollectionViewLayout.swift
//  Unsplash
//
//  Created by 도미닉 on 2/7/26.
//

import UIKit

class GridFlowLayout: UICollectionViewFlowLayout {
    
    private let itemsPerRow: CGFloat
    private let spacing: CGFloat
    
    init(itemsPerRow: CGFloat = 4, spacing: CGFloat = 1) {
        self.itemsPerRow = itemsPerRow
        self.spacing = spacing
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 레이아웃이 준비될 때 호출되는 메서드
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        // 컬렉션 뷰의 실제 너비를 기준으로 계산 (UIScreen.main 대신)
        let contentWidth = collectionView.bounds.width
        let totalSpacing = (spacing * 2) + (spacing * (itemsPerRow - 1))
        let width = (contentWidth - totalSpacing) / itemsPerRow
        
        self.minimumLineSpacing = spacing
        self.minimumInteritemSpacing = spacing
        self.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        self.itemSize = CGSize(width: width, height: width)
        self.scrollDirection = .vertical
    }
}
