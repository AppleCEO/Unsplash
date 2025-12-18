//
//  ImageTableViewCell.swift
//  Unsplash
//
//  Created by 도미닉 on 12/18/25.
//

import UIKit
import SnapKit
import Kingfisher

final class ImageTableViewCell: UITableViewCell {
    static let identifier = "ImageTableViewCell"
    
    private let thumbImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        contentView.addSubview(thumbImageView)
        thumbImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(thumbImageView.snp.width)
        }
    }
    
    func configure(image: Image) {
         thumbImageView.kf.setImage(with: URL(string: image.thumbURL))
    }
}
