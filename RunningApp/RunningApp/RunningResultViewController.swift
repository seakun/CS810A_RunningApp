//
//  RunningResultViewController.swift
//  RunningApp
//
//  Created by lyu on 16/11/2.
//  Copyright © 2016年 lyuchulin. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class RunningResultViewController: UIViewController, MKMapViewDelegate {

    var run: Run!
    var managedObjectContext: NSManagedObjectContext?
    var weight: Double?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBAction func shareResult(_ sender: UIButton) {
        //printDatabaseStatistics()
    }
    
    @IBOutlet weak var totalcalLabel: UILabel!
    
    private func printDatabaseStatistics() {
        managedObjectContext?.perform {
            if let results = try? self.managedObjectContext!.fetch(NSFetchRequest(entityName: "Run")) {
                print("\(results.count) Run")
            }
            // a more efficient way to count objects ...
            let tweetCount = try? self.managedObjectContext!.count(for: NSFetchRequest(entityName: "Location"))
            print("\(tweetCount) Location")
        }
    }
    
    
    
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polyline = overlay as! pathColorPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = polyline.color
        renderer.fillColor = polyline.color
        renderer.lineWidth = 10.0
        return renderer
    }
    
    
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        
        let locations = run.locations.array as! [Location]
        for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: location.lattitude,
                                                 longitude: location.longitude))
        }
        
        return MKPolyline(coordinates: &coords, count: run!.locations.count)
    }
    
    private func mapRegion() -> MKCoordinateRegion {
        let initialLoc = run.locations.firstObject as! Location
        
        var minLat = initialLoc.lattitude
        var minLng = initialLoc.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        let locations = run.locations.array as! [Location]
        
        for location in locations {
            minLat = min(minLat, location.lattitude)
            minLng = min(minLng, location.longitude)
            maxLat = max(maxLat, location.lattitude)
            maxLng = max(maxLng, location.longitude)
        }
        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                                           longitude: (minLng + maxLng)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.1,
                                   longitudeDelta: (maxLng - minLng)*1.1))
    }
    
    
    func loadMap() {
        mapView.region = mapRegion()
        let colorPath = pathColorPolyline.colorSegments(forLocations: run.locations.array as! [Location])
        mapView.addOverlays(colorPath, level: .aboveRoads)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        if run != nil {
            loadMap()
        } 
        
        
        // Do any additional setup after loading the view.
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Share result" {
            if let srvc = segue.destination as? ShareResultViewController {
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
