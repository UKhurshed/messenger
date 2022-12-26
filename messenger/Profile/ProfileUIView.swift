//
//  ProfileUIView.swift
//  messenger
//
//  Created by Khurshed Umarov on 26.12.2022.
//

import UIKit

class ProfileUIView: UIView {
    
    private let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        initTableView()
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
}

extension ProfileUIView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ProfileUIView: UITableViewDelegate {
    
}
