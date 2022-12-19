//
//  NewConversationUIView.swift
//  messenger
//
//  Created by Khurshed Umarov on 17.12.2022.
//

import UIKit
import JGProgressHUD

protocol NewConversationUIViewDelegate: AnyObject {
    func searchBarTapped(text: String)
    func dismissDidSelectRowAt(item: SearchResult)
}

class NewConversationUIView: UIView {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let spinner = JGProgressHUD(style: .dark)
    private let noResults = UILabel()

    private var results = [SearchResult]()
    
    weak var delegate: NewConversationUIViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        initSearchBar()
        initTableView()
    }
    
    private func initSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search for Users..."
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        
        addSubview(searchBar)
    }
    
    private func initTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewConversationTableViewCell.self, forCellReuseIdentifier: NewConversationTableViewCell.identifier)
        
        addSubview(tableView)
        tableView.snp.makeConstraints { makeTable in
            makeTable.top.equalToSuperview()
            makeTable.left.equalToSuperview()
            makeTable.right.equalToSuperview()
            makeTable.bottom.equalToSuperview()
        }
    }
    
    private func initNoResults() {
        noResults.translatesAutoresizingMaskIntoConstraints = false
        noResults.text = "No Results"
        noResults.isHidden = true
        noResults.textAlignment = .center
        noResults.textColor = .green
        noResults.font = .systemFont(ofSize: 21, weight: .medium)
        
        addSubview(noResults)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func takeSearchBar() -> UISearchBar {
        return searchBar
    }
    
    public func setupTableViewData(results: [SearchResult]) {
        self.results = results
    }
    
    public func showSpinner() {
        spinner.show(in: self)
    }
    
    public func stopSpinner() {
        spinner.dismiss(animated: true)
    }
    
    public func resignResponderSearchBar() {
        searchBar.resignFirstResponder()
    }
    
    public func emptyResult() {
        noResults.isHidden = false
        tableView.isHidden = true
    }
    
    public func notEmptyResult() {
        noResults.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
}

extension NewConversationUIView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NewConversationTableViewCell.identifier, for: indexPath) as! NewConversationTableViewCell
        cell.setupData(with: item)
        return cell
    }
}

extension NewConversationUIView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // start conversation
        let targetUserData = results[indexPath.row]

        delegate?.dismissDidSelectRowAt(item: targetUserData)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension NewConversationUIView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        delegate?.searchBarTapped(text: text)
    }
}
