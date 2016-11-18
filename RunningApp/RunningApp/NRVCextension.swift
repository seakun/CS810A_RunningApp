//
//  NRVCextension.swift
//  RunningApp
//
//  Created by lyu on 16/11/3.
//  Copyright © 2016年 lyuchulin. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit


extension RunningViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let frequency = location.timestamp.timeIntervalSinceNow
            
            if abs(frequency) < 10 && location.horizontalAccuracy < 20 {
                
                if self.locations.count > 0 {
                    let lastDistance = location.distance(from: self.locations.last!) as Double
                    distance += lastDistance * 0.000621371
                    let trimmedDistance = String(format: "%.2f", distance)
                    
                    distanceLabel.text = "\(trimmedDistance)"
                    
                    var coords = [CLLocationCoordinate2D]()
                    coords.append(self.locations.last!.coordinate)
                    coords.append(location.coordinate)
                    //print(coords)
                    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                    self.mapView.setRegion(region, animated: true)
                    self.polyLine = MKPolyline(coordinates: &coords, count: coords.count)
                    //print(polyLine!)
                    //mapView.add(polyLine)
                    
                    self.mapView.add(polyLine!, level: .aboveRoads)
                }
                
                self.locations.append(location)
            }
        }
    }
}


extension RunningViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blue
        renderer.fillColor = UIColor.blue
        renderer.lineWidth = 10
        return renderer
    }
    
        
}




