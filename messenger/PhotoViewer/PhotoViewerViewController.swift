//
//  PhotoViewerViewController.swift
//  messenger
//
//  Created by Khurshed Umarov on 19.12.2022.
//

import UIKit

class PhotoViewerViewController: UIViewController {
    
    private let url: URL
    
    init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    private var photoViewerUIView: PhotoViewerUIView {
        self.view as! PhotoViewerUIView
    }
    
    override func loadView() {
        view = PhotoViewerUIView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.photo()
        navigationItem.largeTitleDisplayMode = .never
        photoViewerUIView.setupData(url: url)
    }

}
