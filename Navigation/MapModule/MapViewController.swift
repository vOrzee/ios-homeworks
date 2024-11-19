//
//  MapViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 19.11.2024.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var coordinator: MapCoordinator?
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.mapType = .standard

        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 51.23050251155428,
                longitude: 58.47447023663286
            ),
            latitudinalMeters: 1_000,
            longitudinalMeters: 1_000
        )
        mapView.setRegion(region, animated: true)
        
        mapView.delegate = self
        
        let lpg = UILongPressGestureRecognizer(target: self, action: #selector(onLongTap))
        mapView.addGestureRecognizer(lpg)
        
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
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        if locationManager.authorizationStatus == .denied {
            mapView.showsUserTrackingButton = false
        } else {
            mapView.showsUserTrackingButton = true
        }
        let clearBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .done, target: self, action: #selector(clearUserPoints))
        navigationItem.rightBarButtonItems = [clearBarButtonItem]
    }
    
    @objc func onLongTap(_ gr: UILongPressGestureRecognizer) {
        let pointTap = gr.location(in: mapView)
        let coordinate = mapView.convert(pointTap, toCoordinateFrom: mapView)
        
        let alertController = UIAlertController(title: "Добавление точки", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите название"
        }
        let namingAction = UIAlertAction(title: "Применить", style: .default) { [weak self] _ in
            guard let self = self, let title = alertController.textFields?.first?.text else {
                return
            }
            addUserAnnotation(title: title, coordinate: coordinate)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alertController.addAction(namingAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc func clearUserPoints() {
        mapView.removeAnnotations(mapView.annotations.filter( {$0 is UserMapPointAnnotation} ))
    }
    
    private func addUserAnnotation(title: String, coordinate: CLLocationCoordinate2D) {
        let annotation = UserMapPointAnnotation()
        annotation.title = title
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    private func buildRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
        let direction = MKDirections(request: request)
        
        direction.calculate { [weak self] responсe, error in
            if let responсe, let route = responсe.routes.first {
                self?.mapView.addOverlay(route.polyline)
                self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first?.coordinate
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinateFrom = currentLocation, let coordinateTo = view.annotation?.coordinate else {
            return
        }
        let alertController = UIAlertController(title: "Построить маршрут", message: nil, preferredStyle: .alert)
        let namingAction = UIAlertAction(title: "Построить", style: .default) { [weak self] _ in
            guard let self else {
                return
            }
            buildRoute(from: coordinateFrom, to: coordinateTo)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alertController.addAction(namingAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .red
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer()
    }
}
