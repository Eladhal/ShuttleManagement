//
//  Register.swift
//  Shuttle info
//
//  Created by elad halperin on 9/1/16.
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
    
    @IBOutlet weak var viewLoadingReg: UIView!
    
    @IBOutlet weak var LoadingReg: UIActivityIndicatorView!
    @IBOutlet weak var txtFirstName: UITextField!
    
    
    @IBOutlet weak var txtLastName: UITextField!
    
    
    @IBOutlet weak var txtWorkerNumber: UITextField!
    
    
    @IBOutlet weak var textEmail: UITextField!
    
    
    @IBOutlet weak var txtPassword: UITextField!
    
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    var arrivalArray : [Int]=[]
    var departiveArray : [Int]=[]
    var arrPassengers:[Passnger]=[]
    
    
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
                        self.viewLoadingReg.hidden=false
                        self.LoadingReg.startAnimating()
                        self.ref = FIRDatabase.database().reference()
                        self.ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                            if let Workers = snapshot.value as? [String:NSDictionary]{
                                for (_,ShuttleReq) in Workers   {
                                    let passenger = Passnger()
                                    for (title,descriptions) in ShuttleReq as! [String:AnyObject]  {
                                        if title=="Personal info"{
                                            for (infoTitle,infoDescription) in (descriptions as? [String:AnyObject])!{
                                                switch infoTitle{
                                                case "First name":
                                                    passenger.firstName = infoDescription as! String
                                                case  "Last name":
                                                    passenger.lastName = infoDescription as! String
                                                case  "Worker number":
                                                    passenger.workerNumber = infoDescription as! String
                                                default:
                                                    return
                                                }
                                            }
                                        }
                                        else{
                                            for (infoTitle,infoDescription) in (descriptions as? [String:AnyObject])!{
                                                switch infoTitle{
                                                case "Departive time":
                                                    passenger.DepartiveTimeRequest = Int(infoDescription as! String) ?? 0
                                                case  "Arrival time":
                                                    passenger.ArrivalTimeRequest = Int(infoDescription as! String) ?? 0
                                                default:
                                                    return
                                                }
                                            }
                                        }
                                        
                                    }
                                    self.arrPassengers.append(passenger)
                                }
                                var arrival = [Int]()
                                var departive = [Int]()
                                for passenger in self.arrPassengers{
                                    arrival.append(passenger.ArrivalTimeRequest)
                                    departive.append(passenger.DepartiveTimeRequest)
                                }
                                self.arrivalArray=self.removeDuplicatesAndSort(arrival)
                                self.departiveArray=self.removeDuplicatesAndSort(departive)
                                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ShuttleQuery") as! Shuttle_query
                                vc.arrivalArray = self.arrivalArray
                                vc.departiveArray=self.departiveArray
                                vc.arrPassengers=self.arrPassengers
                                self.LoadingReg.stopAnimating()
                                let navigationController = UINavigationController(rootViewController: vc)
                                self.presentViewController(navigationController, animated: true, completion: nil)
                            }
                        })
                        self.ref.child((user?.uid)!).child("Personal info").setValue(["First name":self.txtFirstName.text!,"Last name":self.txtLastName.text!,"Worker number":self.txtWorkerNumber.text!])
                    }
                })
            }
        }
        else{
            showAlert("Notice", message:"Missing Data")
        }
    }
    func removeDuplicatesAndSort(arr:[Int])-> [Int]{
        var arr = Array(Set(arr)).sort()
        arr.removeAtIndex(0)
        return arr
    }

    func showAlert(title:String,message:String){
        Alert = UIAlertController(title:title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        Alert!.addAction(defaultAction)
        presentViewController(Alert!, animated: true, completion: nil)
    }
}
