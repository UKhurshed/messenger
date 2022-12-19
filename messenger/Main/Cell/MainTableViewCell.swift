//
//  MainTableViewCell.swift
//  messenger
//
//  Created by Khurshed Umarov on 17.12.2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    static let identifier = "mainTableViewCell"
    
    private let mainView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        initMainView()
    }
    
    private func initMainView() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .gray
        
        addSubview(mainView)
        mainView.snp.makeConstraints { makeMain in
            makeMain.top.equalToSuperview()
            makeMain.left.equalToSuperview()
            makeMain.right.equalToSuperview()
            makeMain.bottom.equalToSuperview()
            makeMain.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
