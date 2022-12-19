//
//  LocationPickerUIView.swift
//  messenger
//
//  Created by Khurshed Umarov on 19.12.2022.
//

import UIKit
import MapKit

protocol LocationPickerUIViewDelegate: AnyObject {
    func mapTapped(coordinates: CLLocationCoordinate2D)
}

class LocationPickerUIView: UIView {
    
    private let mapView = MKMapView()
    
    weak var delegate: LocationPickerUIViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
    }
    
    private func initMap() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mapView)
        mapView.snp.makeConstraints { makeMap in
            makeMap.top.equalToSuperview()
            makeMap.left.equalToSuperview()
            makeMap.right.equalToSuperview()
            makeMap.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configuredMapIsPickable() {
        mapView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(mapTapped(_:)))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(gesture)
    }
    
    @objc private func mapTapped(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: mapView)
        let coordinates = mapView.convert(locationInView, toCoordinateFrom: mapView)
        delegate?.mapTapped(coordinates: coordinates)
        
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
         let pin = MKPointAnnotation()
         pin.coordinate = coordinates
         mapView.addAnnotation(pin)
    }
    
    public func dropPinFromMap(coordinates: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
    }
}
