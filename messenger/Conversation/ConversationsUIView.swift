//
//  ConversationsUIView.swift
//  messenger
//
//  Created by Khurshed Umarov on 17.12.2022.
//

import UIKit
import JGProgressHUD

protocol ConversationsUIViewDelegate: AnyObject {
    func deselectItem(_ model: Conversation)
}

class ConversationsUIView: UIView {
    
    private let tableView = UITableView()
    private let noConservationLabel = UILabel()
    private let spinner = JGProgressHUD(style: .dark)
    
    private var conversations = [Conversation]()
    
    weak var delegate: ConversationsUIViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        initTableView()
        initNoConservation()
    }
    
    private func initTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ConversationsTableViewCell.self, forCellReuseIdentifier: ConversationsTableViewCell.identifier)
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
        
        addSubview(noConservationLabel)
        noConservationLabel.snp.makeConstraints { makeNoConv in
            makeNoConv.top.equalToSuperview().offset(130)
            makeNoConv.left.equalToSuperview()
            makeNoConv.right.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func emptyConversation() {
        tableView.isHidden = true
        noConservationLabel.isHidden = false
    }
    
    public func setupData(conversation: [Conversation]) {
        noConservationLabel.isHidden = true
        tableView.isHidden = false
        self.conversations = conversation
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    public func showError() {
        tableView.isHidden = true
        noConservationLabel.isHidden = false
    }
    
    public func showSpinner() {
        spinner.show(in: self)
    }
    
    public func stopSpinner() {
        spinner.dismiss(animated: true)
    }
}

extension ConversationsUIView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsTableViewCell.identifier, for: indexPath) as! ConversationsTableViewCell
        cell.setupData(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.deselectItem(conversations[indexPath.row])
    }
    
}

extension ConversationsUIView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let conversationID = conversations[indexPath.row].id
            tableView.beginUpdates()
            self.conversations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        }
    }
}
