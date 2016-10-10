//
//  Register.swift
//  Shuttle
//
//  Created by elad halperin on 8/25/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Register: UIViewController {
    
    var Alert:UIAlertController?
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
    }

    @IBOutlet weak var txtFirstName: UITextField!
    
    
    @IBOutlet weak var txtLastName: UITextField!
    
    
    @IBOutlet weak var txtWorkerNumber: UITextField!
    
    
    @IBOutlet weak var textEmail: UITextField!
    
    
    @IBOutlet weak var txtPassword: UITextField!
    
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
    @IBAction func btnRegister(sender: AnyObject) {
        
        if txtFirstName.text != "" && txtLastName.text != "" && txtWorkerNumber.text != "" && textEmail.text != "" && txtPassword.text != "" && txtConfirmPassword.text != ""{
            
            if txtPassword.text != txtConfirmPassword.text{
                showAlert("Notice", message: "Please make sure your passwords match")
            }
            else {
                FIRAuth.auth()?.createUserWithEmail(self.textEmail.text!, password: self.txtPassword.text!, completion: { (user, error) in
                    if error != nil{
                        self.showAlert("Notice", message: (error?.localizedDescription)!)
                    }
                    else{
                        self.ref.child((user?.uid)!).child("Personal info").setValue(["First name":self.txtFirstName.text!,"Last name":self.txtLastName.text!,"Worker number":self.txtWorkerNumber.text!])
                        
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ShuttleReqDep") as! Shuttle_Departive_request
                        vc.isReister = true
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                })
            }
        }
        else{
            showAlert("Notice", message:"Missing Data")
        }
    }
    
    func showAlert(title:String,message:String){
        Alert = UIAlertController(title:title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        Alert!.addAction(defaultAction)
        presentViewController(Alert!, animated: true, completion: nil)
    }
}
