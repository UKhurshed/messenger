//
//  PhotoViewerUIView.swift
//  messenger
//
//  Created by Khurshed Umarov on 19.12.2022.
//

import UIKit
import SDWebImage

class PhotoViewerUIView: UIView {
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        initImageView()
    }
    
    private func initImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        addSubview(imageView)
        imageView.snp.makeConstraints { makeImage in
            makeImage.top.equalToSuperview()
            makeImage.left.equalToSuperview()
            makeImage.right.equalToSuperview()
            makeImage.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupData(url: URL) {
        imageView.sd_setImage(with: url, completed: nil)
    }

}
