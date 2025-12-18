//
//  BookmarkButton.swift
//  Unsplash
//
//  Created by 도미닉 on 12/18/25.
//

import UIKit
import SnapKit

final class BookmarkButton: UIButton {
    private let containerView = UIView()
    private let heartImageView = UIImageView()
    private(set) var isBookmarked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        addSubview(containerView)
        containerView.addSubview(heartImageView)
        containerView.backgroundColor = .white
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(40)
        }
        containerView.layer.cornerRadius = 20
        heartImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(20)
        }
        heartImageView.image = UIImage(systemName: "heart")
        tintColor = .systemRed
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @objc private func didTap() {
        setLiked(!isBookmarked, animated: true)
    }

    func setLiked(_ bookmarked: Bool, animated: Bool = false) {
        isBookmarked = bookmarked

        let imageName = bookmarked ? "heart.fill" : "heart"
        let color: UIColor = bookmarked ? .systemRed : .systemGray

        if animated {
            UIView.animate(withDuration: 0.15, animations: {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.15) {
                    self.transform = .identity
                }
            }
        }

        setImage(UIImage(systemName: imageName), for: .normal)
        tintColor = color
    }
}
