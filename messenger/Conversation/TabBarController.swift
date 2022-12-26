//
//  TabBarController.swift
//  messenger
//
//  Created by Khurshed Umarov on 26.12.2022.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .systemGray5
        let convVC = ConversationsViewController()
        let profileVC = ProfileViewController()

        convVC.title = "Chats"
        profileVC.title = "Profile"
        convVC.navigationItem.largeTitleDisplayMode = .always
        profileVC.navigationItem.largeTitleDisplayMode = .always
        
        let navMain = UINavigationController(rootViewController: convVC)
        let navProfile = UINavigationController(rootViewController: profileVC)
        
        navMain.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message"), tag: 1)
        navProfile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "gear"), tag: 1)
        
        navMain.navigationBar.prefersLargeTitles = true
        navProfile.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navMain, navProfile], animated: false)
    }

}
