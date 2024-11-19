//
//  MapViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 19.11.2024.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var coordinator: MapCoordinator?
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.mapType = .standard
        
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        
        let initialLocation = CLLocationCoordinate2D(
            latitude: 51.23050251155428,
            longitude: 58.47447023663286
        )
        
        mapView.setCenter(
            initialLocation,
            animated: true
        )
        
        let region = MKCoordinateRegion(
            center: initialLocation,
            latitudinalMeters: 1_000,
            longitudinalMeters: 1_000
        )
        mapView.setRegion(
            region,
            animated: true
        )
        
        return mapView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Карта"
        view.backgroundColor = .systemBackground
        
        view.addSubview(mapView)
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
        ])
    }
}
