//
//  MainUIView.swift
//  messenger
//
//  Created by Khurshed Umarov on 17.12.2022.
//

import UIKit
import JGProgressHUD

protocol MainUIViewDelegate: AnyObject {
    func deselectItem()
}

class MainUIView: UIView {
    
    private let tableView = UITableView()
    private let noConservationLabel = UILabel()
    private let spinner = JGProgressHUD(style: .dark)
    
    weak var delegate: MainUIViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        initTableView()
        initNoConservation()
    }
    
    private func initTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.isHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(tableView)
        tableView.snp.makeConstraints { makeTable in
            makeTable.top.equalToSuperview()
            makeTable.left.equalToSuperview()
            makeTable.right.equalToSuperview()
            makeTable.bottom.equalToSuperview()
        }
    }
    
    private func initNoConservation() {
        noConservationLabel.translatesAutoresizingMaskIntoConstraints = false
        noConservationLabel.text = "No Conservations!"
        noConservationLabel.textAlignment = .center
        noConservationLabel.textColor = .gray
        noConservationLabel.font = .systemFont(ofSize: 21, weight: .medium)
        noConservationLabel.isHidden = true
        
        addSubview(noConservationLabel)
        noConservationLabel.snp.makeConstraints { makeNoConv in
            makeNoConv.top.equalToSuperview()
            makeNoConv.left.equalToSuperview()
            makeNoConv.right.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showTable() {
        tableView.isHidden = false
        
    }
}

extension MainUIView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.deselectItem()
    }
    
}

extension MainUIView: UITableViewDelegate {
    
}
