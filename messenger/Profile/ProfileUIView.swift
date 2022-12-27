//
//  ProfileUIView.swift
//  messenger
//
//  Created by Khurshed Umarov on 26.12.2022.
//

import UIKit
import SDWebImage

protocol ProfileUIDelegate: AnyObject {
    func logOut()
}

class ProfileUIView: UIView {
    
    private let tableView = UITableView()
    
    private var profileModel = [ProfileModel]()
    
    weak var delegate: ProfileUIDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        initTableView()
        profileModel.append(ProfileModel(profileModelType: .info, title: "Name: \(UserDefaults.standard.value(forKey: UserDefaultsKeysConstant.name) as? String ?? "No Name")", handler: nil))
        
        profileModel.append(ProfileModel(profileModelType: .info, title: "Email: \(UserDefaults.standard.value(forKey: UserDefaultsKeysConstant.email) as? String ?? "No Email")", handler: nil))
        
        profileModel.append(ProfileModel(profileModelType: .logout, title: "Log Out", handler: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.delegate?.logOut()
        }))
    }
    

    
    private func initTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileUTableViewCell.self, forCellReuseIdentifier: ProfileUTableViewCell.identifier)
        
        addSubview(tableView)
        tableView.snp.makeConstraints { makeTableView in
            makeTableView.top.equalToSuperview()
            makeTableView.left.equalToSuperview()
            makeTableView.right.equalToSuperview()
            makeTableView.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupData(with data: [ProfileModel]) {
        self.profileModel = data
    }
}

extension ProfileUIView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = profileModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileUTableViewCell.identifier, for: indexPath) as! ProfileUTableViewCell
        cell.setupData(with: item)
        return cell
    }
}

extension ProfileUIView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        profileModel[indexPath.row].handler?()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableHeader()
    }
}


class TableHeader: UIView {
    
    private let mainBack = UIView()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initMainBack()
        initImageView()
        downloadPhoto()
    }
    
    private func initMainBack() {
        mainBack.translatesAutoresizingMaskIntoConstraints = false
        mainBack.backgroundColor = .link
        
        addSubview(mainBack)
        mainBack.snp.makeConstraints { makeMainBack in
            makeMainBack.top.equalToSuperview()
            makeMainBack.left.equalToSuperview()
            makeMainBack.right.equalToSuperview()
            makeMainBack.height.equalTo(160)
        }
    }
    
    private func initImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        
        mainBack.addSubview(imageView)
        imageView.snp.makeConstraints { makeImage in
            makeImage.centerX.equalToSuperview()
            makeImage.centerY.equalToSuperview()
            makeImage.height.equalTo(100)
            makeImage.width.equalTo(100)
        }
    }
    
    private func downloadPhoto() {
        guard let email = UserDefaults.standard.value(forKey: UserDefaultsKeysConstant.email) as? String else {
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/" + filename
        print("path: \(path)")
        
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                self?.imageView.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                self?.imageView.image = UIImage(named: "user")
                print("Failed to get download url: \(error)")
            }
        })
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
