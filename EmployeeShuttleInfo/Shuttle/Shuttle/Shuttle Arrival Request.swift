//
//  Shuttle Arrival Request.swift
//  Shuttle
//
//  Created by elad halperin on 9/26/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Shuttle_Arrival_Request: UIViewController {
    
    @IBOutlet weak var ViewNotice: UIView!

    @IBOutlet weak var txtArrFirstHourDigit: UITextField!
    
    @IBOutlet weak var txtArrSecondHourDigit: UITextField!
    
    @IBOutlet weak var txtArrFirstMinuteDigit: UITextField!
    
    @IBOutlet weak var txtArrSecondMinuteDigit: UITextField!
    
    var arrPassengers:[Passnger]=[]
    
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
            ViewNotice.hidden = false
        }
    }
    
    @IBAction func btnRequest(sender: AnyObject) {
        let userID:String = (FIRAuth.auth()?.currentUser?.uid)!
        ref = FIRDatabase.database().reference().child(userID)
        var alertController = UIAlertController()
        var okAction = UIAlertAction()
        var cancelAction = UIAlertAction()
        
        if (txtArrFirstHourDigit.text != "" && txtArrSecondHourDigit.text != "" && txtArrFirstMinuteDigit.text != "" && txtArrSecondMinuteDigit.text != "") {
            
            let arrTime = txtArrFirstHourDigit.text!+txtArrSecondHourDigit.text!+txtArrFirstMinuteDigit.text!+txtArrSecondMinuteDigit.text!
            
            if (checkIfFull(arrTime)){
                ref.child("Shuttle request").setValue(["Arrival time":arrTime])
                alertController = UIAlertController(title: "Notice", message: "Your arrival time Received in the system", preferredStyle: .Alert)
                okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
                    self.presentViewController(vc!, animated: true, completion: nil)
                })
                cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action) in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        else{
            showAlert("Notice", message: "Missing Data")
        }
    }
    func checkIfFull(arrivalTime:String)->Bool{
        var count = 0
        for passanger in arrPassengers{
            if passanger.ArrivalTimeRequest == Int(arrivalTime){
                count=count+1
            }
        }
        if count >= 19{
            showAlert("Notice", message: "The shuttle that goes at \(arrivalTime) is full, try the next one")
            return true
        }
        else{
            return false
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        switch textField{
            
        case txtArrFirstHourDigit:
            if txtArrFirstHourDigit.text != "0"{
                showAlert("Notice", message: "You entered invalid time")
                return false
            }
        case txtArrSecondHourDigit :
            if (txtArrSecondHourDigit.text<"6" || txtArrSecondHourDigit.text>"9") {
                showAlert("Notice", message: "You entered invalid time")
                return false
            }
        case txtArrFirstMinuteDigit :
            if (txtArrFirstMinuteDigit.text > "5" || txtArrFirstMinuteDigit.text < "0") {
                showAlert("Notice", message: "You entered invalid time")
                return false
            }
            else{
                if txtArrSecondHourDigit.text == "6" && txtArrFirstMinuteDigit.text != "4"{
                    showAlert("Notice", message: "No Shuttles before 06:45 o'clock")
                    return false
                }
                if txtArrSecondHourDigit.text == "9" && txtArrFirstMinuteDigit.text != "0"{
                    showAlert("Notice", message: "No Shuttles after 09:00 o'clock")
                    return false
                }
                if txtArrFirstMinuteDigit.text == "2" {
                    showAlert("Notice", message: "you need to enter the hours in  multiples of fifteen minutes." +
                        "For example : 16:15, 16:30, and so on...")
                    return false
                }
            }
        case txtArrSecondMinuteDigit:
            if txtArrSecondMinuteDigit.text != "5" && txtArrSecondMinuteDigit.text != "0" && txtArrSecondMinuteDigit.text != ""{
                showAlert("Notice", message: "you need to enter the hours in  multiples of fifteen minutes." +
                    "For example : 16:15, 16:30, and so on...")
                return false
            }
            else if txtArrSecondHourDigit.text == "9" && txtArrSecondMinuteDigit.text != "0" {
                showAlert("Notice", message: "you need to enter the hours in  multiples of fifteen minutes." +
                    "For example : 16:15, 16:30, and so on...")
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
    
    @IBAction func btnCanacel(sender: AnyObject) {
    }
}
