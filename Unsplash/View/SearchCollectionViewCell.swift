//
//  SearchCollectionViewCell.swift
//  Unsplash
//
//  Created by 도미닉 on 12/17/25.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
    
    func configure(with model: Image) {
        guard let url = URL(string: model.thumbURL) else {
            imageView.image = nil
            return
        }
        imageView.kf.setImage(with: url)
    }
}
