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
    
    func configure(title: String, value: String) {
        var content = UIListContentConfiguration.valueCell()
        content.text = title
        content.secondaryText = value
        
        content.textProperties.font = .systemFont(ofSize: 14, weight: .medium)
        content.textProperties.color = .label
        
        content.secondaryTextProperties.font = .systemFont(ofSize: 14, weight: .medium)
        content.secondaryTextProperties.color = .secondaryLabel
        content.secondaryTextProperties.alignment = .natural
        
        contentConfiguration = content
    }
}
