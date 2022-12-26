//
//  NewConversationTableViewCell.swift
//  messenger
//
//  Created by Khurshed Umarov on 17.12.2022.
//

import UIKit
import SDWebImage

class NewConversationTableViewCell: UITableViewCell {
    
    static let identifier = "newConversationTableViewCell"
    
    private let mainBackground = UIView()
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        initMainBackground()
        initUserImageView()
        initUserNameLabel()
    }
    
    private func initMainBackground() {
        mainBackground.translatesAutoresizingMaskIntoConstraints = false
        mainBackground.backgroundColor = .white
        
        contentView.addSubview(mainBackground)
        mainBackground.snp.makeConstraints { makeMainBack in
            makeMainBack.top.equalToSuperview()
            makeMainBack.left.equalToSuperview()
            makeMainBack.right.equalToSuperview()
            makeMainBack.bottom.equalToSuperview()
            makeMainBack.height.equalTo(90)
        }
    }
    
    private func initUserImageView() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = 35
        userImageView.layer.masksToBounds = true
        
        mainBackground.addSubview(userImageView)
        userImageView.snp.makeConstraints { makeUserImage in
            makeUserImage.top.equalTo(mainBackground.snp.top).offset(10)
            makeUserImage.left.equalTo(mainBackground.snp.left).offset(10)
            makeUserImage.height.equalTo(70)
            makeUserImage.width.equalTo(70)
        }
    }
    
    private func initUserNameLabel() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        
        mainBackground.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { makeUserName in
            makeUserName.top.equalToSuperview().offset(20)
            makeUserName.left.equalTo(userImageView.snp.right).offset(10)
            makeUserName.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupData(with model: SearchResult) {
        userNameLabel.text = model.name

        let path = "images/\(model.email)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
            switch result {
            case .success(let url):

                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: url, completed: nil)
                }

            case .failure(let error):
                print("failed to get image url: \(error)")
            }
        }
    }
}
