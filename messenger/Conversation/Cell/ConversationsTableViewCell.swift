//
//  ConversationsTableViewCell.swift
//  messenger
//
//  Created by Khurshed Umarov on 17.12.2022.
//

import UIKit
import SDWebImage

class ConversationsTableViewCell: UITableViewCell {
    
    static let identifier = "ConversationsTableViewCell"
    
    private let mainView = UIView()
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let userMessageLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        initMainView()
        initUserImageView()
        initUserNameLabel()
        initUserMessageLabel()
    }
    
    private func initMainView() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { makeMain in
            makeMain.top.equalToSuperview()
            makeMain.left.equalToSuperview()
            makeMain.right.equalToSuperview()
            makeMain.bottom.equalToSuperview()
            makeMain.height.equalTo(120)
        }
    }
    
    private func initUserImageView() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = 50
        userImageView.layer.masksToBounds = true
        
        mainView.addSubview(userImageView)
        userImageView.snp.makeConstraints { makeUserImage in
            makeUserImage.top.equalTo(mainView.snp.top).offset(10)
            makeUserImage.left.equalTo(mainView.snp.left).offset(10)
            makeUserImage.height.equalTo(100)
            makeUserImage.width.equalTo(100)
        }
    }
    
    private func initUserNameLabel() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        
        mainView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { makeUserName in
            makeUserName.top.equalToSuperview().offset(10)
            makeUserName.left.equalTo(userImageView.snp.right).offset(10)
            makeUserName.height.equalTo(50)
        }
    }
    
    private func initUserMessageLabel() {
        userMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        userMessageLabel.font = .systemFont(ofSize: 19, weight: .regular)
        userMessageLabel.numberOfLines = 0
        
        mainView.addSubview(userMessageLabel)
        userMessageLabel.snp.makeConstraints { makeUserMessage in
            makeUserMessage.top.equalTo(userNameLabel.snp.bottom).offset(10)
            makeUserMessage.left.equalTo(userImageView.snp.right).offset(10)
            makeUserMessage.height.equalTo(50)
        }
    }
    
    public func setupData(with model: Conversation) {
        if model.latestMessage.text.contains(".png") {
            userMessageLabel.text = "1 photo"
        } else {
            userMessageLabel.text = model.latestMessage.text
        }
        
        userNameLabel.text = model.name
        print("model: \(model)")
        
        let path = "images/\(model.otherUserEmail)_profile_picture.png"
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
