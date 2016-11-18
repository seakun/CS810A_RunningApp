//
//  SettingWeightViewController.swift
//  RunningApp
//
//  Created by lyu on 16/11/2.
//  Copyright © 2016年 lyuchulin. All rights reserved.
//

import UIKit
import CoreData

class SettingWeightViewController: UIViewController, UITextFieldDelegate {

    var weight: Double?
    var managedObjectContext: NSManagedObjectContext?
    
    @IBOutlet weak var kiloTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kiloTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Start Run" {
            if let rvc = segue.destination as? RunningViewController {
                rvc.managedObjectContext = managedObjectContext
                rvc.weight = weight
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        kiloTextField.resignFirstResponder()
//        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
