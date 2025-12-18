//
//  BookmarkButton.swift
//  Unsplash
//
//  Created by 도미닉 on 12/18/25.
//

import UIKit
import SnapKit

final class BookmarkButton: UIButton {
    
    private(set) var isBookmarked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        backgroundColor = .white
        layer.cornerRadius = 20
        
        setImage(UIImage(systemName: "heart"), for: .normal)
        tintColor = .systemRed
        
        imageView?.contentMode = .scaleAspectFit
        
        snp.makeConstraints {
            $0.size.equalTo(40)
        }
    }
    
    func setLiked(_ bookmarked: Bool, animated: Bool = false) {
        isBookmarked = bookmarked
        
        let imageName = bookmarked ? "heart.fill" : "heart"
        setImage(UIImage(systemName: imageName), for: .normal)
        
        guard animated else { return }
        
        UIView.animate(withDuration: 0.15, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.transform = .identity
            }
        }
    }
}
