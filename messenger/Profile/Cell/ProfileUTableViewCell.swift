//
//  ProfileUTableViewCell.swift
//  messenger
//
//  Created by Khurshed Umarov on 26.12.2022.
//

import UIKit

class ProfileUTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileUTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
