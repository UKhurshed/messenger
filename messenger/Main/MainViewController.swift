//
//  MainViewController.swift
//  messenger
//
//  Created by Khurshed Umarov on 13.12.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private var mainUIView: MainUIView {
        self.view as! MainUIView
    }
    
    override func loadView() {
        view = MainUIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainUIView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(tapCompose))
    }
    
    @objc private func tapCompose() {
        let vc = NewConversationViewController()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}

extension MainViewController: MainUIViewDelegate {
    func deselectItem() {
        let vc = ChatViewController()
        vc.title = "Jenny Smith"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

