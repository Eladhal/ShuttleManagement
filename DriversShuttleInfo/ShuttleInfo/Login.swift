//
//  ViewController.swift
//  Shuttle info
//
//  Created by elad halperin on 9/1/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Login: UIViewController {
    
    var Alert:UIAlertController?
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var ref:FIRDatabaseReference!
    var arrivalArray : [Int]=[]
    var departiveArray : [Int]=[]
    var arrPassengers:[Passnger]=[]
    
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        txtEmail.text = ""
        txtPassword.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnLogin(sender: AnyObject) {
        
        if txtEmail.text != "" && txtPassword.text != ""{
            FIRAuth.auth()?.signInWithEmail(self.txtEmail.text!, password: self.txtPassword.text!, completion: { (user, error) in

                if error != nil{
                    if (error?.userInfo["error_name"])! as! String == "ERROR_USER_NOT_FOUND"{
                        self.showAlert("Notice", message: "This User doesn't exist, you need to register first")
                    }
                    else{
                        self.showAlert("Notice", message: (error?.localizedDescription)!)
                    }
                }
                else{
                    self.LoadingView.hidden=false
                    self.loading.startAnimating()
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
                            self.loading.stopAnimating()
                            let navigationController = UINavigationController(rootViewController: vc)
                            self.presentViewController(navigationController, animated: true, completion: nil)
                        }
                    })
                }
            })
        }
        else{
            showAlert("Notice", message: "Missing Data")
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

