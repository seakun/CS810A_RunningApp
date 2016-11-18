//
//  ShareResultViewController.swift
//  RunningApp
//
//  Created by lyu on 16/11/14.
//  Copyright © 2016年 lyuchulin. All rights reserved.
//

import UIKit
import Social

class ShareResultViewController: UIViewController, UITextViewDelegate {
    
    
    @IBAction func showShareOptions(_ sender: UIBarButtonItem)
    {
        if noteTextview.isFirstResponder {
            noteTextview.resignFirstResponder()
        }
        
        let actionSheet = UIAlertController(title: "", message: "Share your Run", preferredStyle: UIAlertControllerStyle.actionSheet)
        let tweetAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.default) { (action) -> Void in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                // Initialize the default view controller for sharing the post.
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                // Set the note text as the default post message.
                if self.noteTextview.text.characters.count <= 140 {
                    twitterComposeVC?.setInitialText("\(self.noteTextview.text!)")
                }
                else {
                    let startIndex = self.noteTextview.text.index(self.noteTextview.text.startIndex, offsetBy: 140)
                    let subText = self.noteTextview.text.substring(to: startIndex)
                    twitterComposeVC?.setInitialText("\(subText)")
                }
                
                self.present(twitterComposeVC!, animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "LOGIN", message: "You are not logged in to your Twitter account.", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
        // Configure a new action to share on Facebook.
        let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.default) { (action) -> Void in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                facebookComposeVC?.setInitialText("\(self.noteTextview.text!)")
                
                self.present(facebookComposeVC!, animated: true, completion: nil)
                
            } else {
                let alertController = UIAlertController(title: "LOGIN", message: "You are not logged in to your Facebook account.", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (action) -> Void in
            
        }
        
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(facebookPostAction)
        actionSheet.addAction(dismissAction)
        
        present(actionSheet, animated: true, completion: nil)

    }

    @IBOutlet weak var noteTextview: UITextView!
    
    private func configureNoteTextView() {
        noteTextview.layer.cornerRadius = 8.0
        noteTextview.layer.borderColor = UIColor(white: 0.75, alpha: 0.5).cgColor
        noteTextview.layer.borderWidth = 1.2
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNoteTextView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Back To Home Page" {
            
        }
    }
    

    

}
