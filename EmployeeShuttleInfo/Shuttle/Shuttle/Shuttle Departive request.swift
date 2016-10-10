    //
//  Shuttle request.swift
//  Shuttle
//
//  Created by elad halperin on 8/25/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Shuttle_Departive_request: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var ViewNotice: UIView!
    @IBOutlet weak var txtDepFirstHourDigit: UITextField!
    
    @IBOutlet weak var txtDepSecondHourDigit: UITextField!
    
    @IBOutlet weak var txtDepFirstMinuteDigit: UITextField!
    
    @IBOutlet weak var txtDepSecondMinuteDigit: UITextField!
    

    var arrPassengers:[Passnger]=[]
    
    var isReister:Bool = false
    
    let nowDate = NSDate()
    
    let calendar = NSCalendar.currentCalendar()
    
    var Alert:UIAlertController?
    
    var ref : FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnViewNotice(sender: AnyObject) {
        ViewNotice.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        let dateComponents = calendar.components([NSCalendarUnit.Hour,NSCalendarUnit.Minute], fromDate: nowDate)
        if (dateComponents.hour > 18 || ( dateComponents.hour == 14 && dateComponents.minute > 0)){
            let alertController = UIAlertController(title: "Notice", message: "You can't make shuttle request after 14:00 o'clock , come back tommorow", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(vc!, animated: true, completion: nil)
            })
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            if isReister == true{
            ViewNotice.hidden = false
            }
    }
    }

    @IBAction func btnRequest(sender: AnyObject) {
        let userID:String = (FIRAuth.auth()?.currentUser?.uid)!
        ref = FIRDatabase.database().reference().child(userID)
        var alertController = UIAlertController()
        var okAction = UIAlertAction()
        var cancelAction = UIAlertAction()

        if (txtDepFirstHourDigit.text != "" && txtDepSecondHourDigit.text != "" && txtDepFirstMinuteDigit.text != "" && txtDepSecondMinuteDigit.text != "") {
            
            let depTime = txtDepFirstHourDigit.text!+txtDepSecondHourDigit.text!+txtDepFirstMinuteDigit.text!+txtDepSecondMinuteDigit.text!
            
            if (checkIfFull(depTime)==false){
            ref.child("Shuttle request").setValue(["Departive time":depTime])
            alertController = UIAlertController(title: "Notice", message: "Your departive time Received in the system", preferredStyle: .Alert)
            okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ShuttleReqArr") as! Shuttle_Arrival_Request
                vc.arrPassengers = self.arrPassengers
                self.presentViewController(vc, animated: true, completion: nil)
            })
            cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            }
            else{
                
            }
        }
        else{
            showAlert("Notice", message: "Missing Data")
        }
    }
    func checkIfFull(departiveTime:String)->Bool{
        var count = 0
        for passanger in arrPassengers{
            if passanger.DepartiveTimeRequest == Int(departiveTime){
                count=count+1
            }
        }
        if count >= 19{
            showAlert("Notice", message: "The shuttle that goes at \(departiveTime) is full, try the next one")
            return true
        }
        else{
            return false
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        switch textField{
            
        case txtDepFirstHourDigit:
            if txtDepFirstHourDigit.text != "1" && txtDepFirstHourDigit.text != "" {
                showAlert("Notice", message: "You entered invalid time")
                return false
            }
        case txtDepSecondHourDigit :
            if (txtDepSecondHourDigit.text<"6" || txtDepSecondHourDigit.text>"8") {
                showAlert("Notice", message: "You entered invalid time")
                return false
            }
        case txtDepFirstMinuteDigit :
            if (txtDepFirstMinuteDigit.text > "5" || txtDepFirstMinuteDigit.text < "0"){
                showAlert("Notice", message: "You entered invalid time")
                return false
            }
            else{
                if txtDepSecondHourDigit.text == "8" && txtDepFirstMinuteDigit.text != "0"{
                        showAlert("Notice", message: "No Shuttles after 18:00 o'clock")
                        return false
                }
                if txtDepFirstMinuteDigit.text == "2" {
                    showAlert("Notice", message: "you need to enter the hours in  multiples of fifteen minutes." +
                    "For example : 16:15, 16:30, and so on...")
                    return false
                }
        }
        case txtDepSecondMinuteDigit:
            if txtDepSecondMinuteDigit.text == "0" || txtDepSecondMinuteDigit.text == "5"{
            if txtDepFirstMinuteDigit.text == "0" || txtDepFirstMinuteDigit.text == "3" &&
            txtDepSecondMinuteDigit.text != "0"{
            showAlert("Notice", message: "you need to enter the hours in  multiples of fifteen minutes." +
                    "For example : 16:15, 16:30, and so on...")
                return false
            }
            else if txtDepFirstMinuteDigit.text == "4" || txtDepFirstMinuteDigit.text == "1"  && txtDepSecondMinuteDigit.text != "5"{
                showAlert("Notice", message: "you need to enter the hours in  multiples of fifteen minutes." +
                    "For example : 16:15, 16:30, and so on...")
                return false
                }
            }
            else{
                showAlert("Notice", message: "You entered invalid time")
                return false
            }
        default :
            return true
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (textField.text!.characters.count + string.characters.count>1) {
            return false
        }
        return true
    }
    func showAlert(title:String,message:String){
        Alert = UIAlertController(title:title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        Alert!.addAction(defaultAction)
        presentViewController(Alert!, animated: true, completion: nil)
    }
}


