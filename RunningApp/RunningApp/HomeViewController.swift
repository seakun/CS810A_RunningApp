//
//  HomeViewController.swift
//  RunningApp
//
//  Created by lyu on 16/11/2.
//  Copyright © 2016年 lyuchulin. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    
    @IBOutlet weak var mileLable: UILabel!
    
    
    @IBOutlet weak var speedLable: UILabel!
    var r: NSString?
    
    private func getData()
    {
        var distance = 0.0
        r = NSString(format: "%.2f", distance)
        managedObjectContext?.perform {
            if let results = try? self.managedObjectContext!.fetch(NSFetchRequest(entityName: "Run")) {
                print("\(results.count) Run")
                for run in results {
                    let a  = run as! Run
                    distance = distance + (Double)(a.distance)
                    self.r = NSString(format: "%.2f", distance)
                }
                self.mileLable.text = self.r as String?
            }
        }
    }
    
    private func clear(){
        let coord = (UIApplication.shared.delegate as? AppDelegate)?.persistentStoreCoordinator
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Run")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord?.execute(deleteRequest, with: self.managedObjectContext!)
        } catch let error {
            print(error)
        }
        
        self.mileLable.text = "0.00"
    }
    
    
    @IBAction func clearData(_ sender: UIButton) {
        let alertController = UIAlertController(title: "CLEAR DATA", message: "Do you want to clear all running data?", preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
           self.clear()
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Enter Weight" {
            if let swvc = segue.destination as? SettingWeightViewController {
                swvc.managedObjectContext = managedObjectContext
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
