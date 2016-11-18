//
//  RunningViewController.swift
//  RunningApp
//
//  Created by lyu on 16/11/2.
//  Copyright © 2016年 lyuchulin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
import HealthKit

class RunningViewController: UIViewController, CLLocationManagerDelegate {

    var managedObjectContext: NSManagedObjectContext?
    var sRun: Run!
    var weight: Double?
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .fitness
        _locationManager.distanceFilter = 10.0
       return _locationManager
    }()
    
    
    //var location: CLLocationManager?
    
    var second = 0.0
    var distance = 0.0
    var polyLine: MKPolyline?
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var distanceTraveled = 0.0
    
    lazy var locations = [CLLocation]()
    lazy var speedTimer = Timer()
    lazy var timer = Timer()
    var zeroTime = TimeInterval()
    
    @IBOutlet weak var showResult: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var stopShowMapbutton: UIButton!
    @IBOutlet weak var showMapButton: UIButton!
    @IBOutlet weak var stopRunningButton: UIButton!
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var startRunningButton: UIButton!
    
    @IBAction func starToRun(_ sender: Any) {
        startRunningButton.isHidden = true
        startRunningButton.isEnabled = false;
        locations.removeAll(keepingCapacity: false)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        speedTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countSecond), userInfo: nil, repeats: true)
        zeroTime = NSDate.timeIntervalSinceReferenceDate
        
        distanceTraveled = 0.0
        startLocation = nil
        lastLocation = nil
        
        updateLocation()
    }
    
    @IBAction func stopToRun(_ sender: UIButton) {
        stopRunningButton.isHidden = true;
        stopRunningButton.isEnabled = false;
        showResult.isHidden = false;
        showResult.isEnabled = true;
        timer.invalidate()
        speedTimer.invalidate()
        locationManager.stopUpdatingLocation()
        saveRun()
    }
    
    
    
    
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        var timePassed: TimeInterval = currentTime - zeroTime
        let minutes = UInt8(timePassed / 60.0)
        timePassed -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(timePassed)
        timePassed -= TimeInterval(seconds)
        let millisecsX10 = UInt8(timePassed * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMSX10 = String(format: "%02d", millisecsX10)
        
        timeLabel.text = "\(strMinutes):\(strSeconds):\(strMSX10)"
        
        if timeLabel.text == "60:00:00" {
            timer.invalidate()
            locationManager.stopUpdatingLocation()
        }
    }

    
    
    func countSecond() { // speed!!!! 用什么单位计算比较好？？？
        second += 1
        let speed = distance / second
        let spe = NSString(format: "%.2f", speed)
        speedLabel.text = "\(spe) m/s"
        
    }
    
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func stopShowMap(_ sender: UIButton) {
        showMapButton.isHidden = false
        showMapButton.isEnabled = true
        stopRunningButton.isHidden = false
        stopRunningButton.isEnabled = true
        kmLabel.isHidden = false
        distanceLabel.isHidden = false
        timeLabel.isHidden = false
        speedLabel.isHidden = false
        mapView.isHidden = true
        mapView.showsUserLocation = true
        stopShowMapbutton.isHidden = true
        stopShowMapbutton.isEnabled = false
        startRunningButton.isHidden = true
        startRunningButton.isEnabled = false

    }
    
    @IBAction func showmap(_ sender: UIButton) {
        showMapButton.isHidden = true
        showMapButton.isEnabled = false
        stopRunningButton.isHidden = true
        stopRunningButton.isEnabled = false
        kmLabel.isHidden = true
        distanceLabel.isHidden = true
        timeLabel.isHidden = true
        speedLabel.isHidden = true
        mapView.isHidden = false
        mapView.showsUserLocation = true
        stopShowMapbutton.isHidden = false
        stopShowMapbutton.isEnabled = true
        startRunningButton.isHidden = true
        startRunningButton.isEnabled = false
        //mapview.isHidden = false;
    }
    
    func saveRun()
    {
        self.sRun = NSEntityDescription.insertNewObject(forEntityName: "Run", into: managedObjectContext!) as! Run
        sRun.distance = Float(distance)
        sRun.duration = Int16(second)
        sRun.timestamp = NSDate()
        
        var saveLocations = [Location]()
        for location in locations {
            let saveLocation = NSEntityDescription.insertNewObject(forEntityName: "Location", into: managedObjectContext!) as! Location
            saveLocation.timestamp = location.timestamp as NSDate?
            saveLocation.lattitude = location.coordinate.latitude
            saveLocation.longitude = location.coordinate.longitude
            saveLocations.append(saveLocation)
        }
        
        sRun.locations = NSOrderedSet(array: saveLocations)
        //self.run = saveRun
        //print(saveRun.distance)
        //print(self.run.distance)
        
        do {
            try self.managedObjectContext!.save()
        } catch let error {
            print(error)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.isHidden = true
        stopShowMapbutton.isHidden = true
        stopShowMapbutton.isEnabled = false
        mapView.showsUserLocation = true
        stopRunningButton.isHidden = true
        stopRunningButton.isEnabled = false
        showResult.isHidden = true;
        showResult.isEnabled = false;
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show RunningResult" {
            if let rrvc = segue.destination as? RunningResultViewController {
                rrvc.managedObjectContext = managedObjectContext
                rrvc.weight = weight
                rrvc.run = sRun
                //print(run.distance)
            }
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let c = locations[0] as CLLocation
//        let nowLocation = CLLocationCoordinate2D(latitude: c.coordinate.latitude, longitude: c.coordinate.longitude)
//        
//        //將map中心點定在目前所在的位置
//        //span是地圖zoom in, zoom out的級距
//        let _span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
//        self.mapview.setRegion(MKCoordinateRegion(center: nowLocation, span: _span), animated: true)
//        self.mapview.mapType = .hybrid
//    }

    

}
