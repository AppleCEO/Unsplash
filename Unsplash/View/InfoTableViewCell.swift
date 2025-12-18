//
//  InfoTableViewCell.swift
//  Unsplash
//
//  Created by 도미닉 on 12/18/25.
//

import UIKit
import Then
import SnapKit

class InfoTableViewCell: UITableViewCell {
    static let identifier = "InfoTableViewCell"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .label
    }
    private let valueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 0
    }
    private let spacer = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        let hStack = UIStackView(arrangedSubviews: [
            titleLabel,
            spacer,
            valueLabel
        ])
        
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 8
        
        contentView.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}
