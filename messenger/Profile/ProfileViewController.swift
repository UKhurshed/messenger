//
//  ProfileViewController.swift
//  messenger
//
//  Created by Khurshed Umarov on 26.12.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var profileUIView: ProfileUIView {
        self.view as! ProfileUIView
    }
    
    override func loadView() {
        view = ProfileUIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
