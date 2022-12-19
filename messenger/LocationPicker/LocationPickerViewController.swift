//
//  LocationPickerViewController.swift
//  messenger
//
//  Created by Khurshed Umarov on 19.12.2022.
//

import UIKit
import CoreLocation

class LocationPickerViewController: UIViewController {
    
    public var completion: ((CLLocationCoordinate2D) -> Void)?
    private var coordinates: CLLocationCoordinate2D?
    private var isPickable = true
    
    init(coordinates: CLLocationCoordinate2D?) {
        self.coordinates = coordinates
        self.isPickable = coordinates == nil
        super.init(nibName: nil, bundle: nil)
    }
    
    private var locationUIView: LocationPickerUIView {
        self.view as! LocationPickerUIView
    }
    
    override func loadView() {
        view = LocationPickerUIView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationUIView.delegate = self
        if isPickable {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(sendButtonTapped))
            locationUIView.configuredMapIsPickable()
        } else {
            guard let coordinates = self.coordinates else {
                return
            }
            locationUIView.dropPinFromMap(coordinates: coordinates)
        }
       
    }
    
    @objc private func sendButtonTapped() {
        guard let coordinates = coordinates else {
            return
        }
        navigationController?.popViewController(animated: true)
        completion?(coordinates)
    }
}

extension LocationPickerViewController: LocationPickerUIViewDelegate {
    func mapTapped(coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
    }
}

