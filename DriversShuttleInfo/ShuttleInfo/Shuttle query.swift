//
//  Shuttle query.swift
//  Shuttle info
//
//  Created by elad halperin on 9/4/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Shuttle_query: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var lblDepartive: UILabel!
    @IBOutlet weak var lblArrival: UILabel!
    @IBOutlet weak var ShuttleLoading: UIView!
    
    @IBOutlet weak var ActivityLoading: UIActivityIndicatorView!
    var arrivalArray : [Int]=[]
    var departiveArray : [Int]=[]
    var arrPassengers:[Passnger]=[]
    var arrPassengersForShuttle:[String]=[]

    let date = NSDate()
    var oneDayfromNow: NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Day,value: 1, toDate: NSDate(), options: [])!
    }
    var ref:FIRDatabaseReference!
    
    @IBOutlet weak var DepCollectionView: UICollectionView!
    
    @IBOutlet weak var ArrCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateToday = formatter.stringFromDate(date)
        lblDepartive.text = " Departive Time for \(dateToday)"

        let tommorow = NSDateFormatter()
        tommorow.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateTommorow = tommorow.stringFromDate(oneDayfromNow)
        lblArrival.text = " Arrival Time for \(dateTommorow)"
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numOfItems:Int?
       if collectionView == DepCollectionView{
            numOfItems = self.departiveArray.count
        }
        else{
            numOfItems = self.arrivalArray.count
        }
        return numOfItems!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.ShuttleLoading.hidden=false
        self.ActivityLoading.startAnimating()
        
        if collectionView == DepCollectionView{
            
            for passnger in arrPassengers{
                if passnger.DepartiveTimeRequest == departiveArray[indexPath.row]{
                    arrPassengersForShuttle.append(passnger.firstName+" "+passnger.lastName+" "+passnger.workerNumber)
                }
            }
            let vc = storyboard!.instantiateViewControllerWithIdentifier("Passengers") as! Passengers_Table
            vc.arrShuttlePassengers = self.arrPassengersForShuttle
            arrPassengersForShuttle = []
            vc.strTitle = "List of Passangers for hour \(departiveArray[indexPath.row])"
            self.ActivityLoading.stopAnimating()
            self.ShuttleLoading.hidden = true
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else{
            for passnger in arrPassengers{
                
                if passnger.ArrivalTimeRequest == arrivalArray[indexPath.row]{
                    arrPassengersForShuttle.append(passnger.firstName+" "+passnger.lastName+" "+passnger.workerNumber)
                }
            }
            let vc = storyboard?.instantiateViewControllerWithIdentifier("Passengers") as! Passengers_Table
            vc.arrShuttlePassengers = self.arrPassengersForShuttle
            arrPassengersForShuttle = []
            vc.strTitle = "List of Passangers for hour" + String(arrivalArray[indexPath.row])
            self.ActivityLoading.stopAnimating()
            self.ShuttleLoading.hidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = ShuttleQueryCell()
        if collectionView == DepCollectionView{
         cell = collectionView.dequeueReusableCellWithReuseIdentifier("DepartiveCell", forIndexPath: indexPath) as! ShuttleQueryCell
            cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.layer.borderWidth=1
            cell.lblCell.text = String(departiveArray[indexPath.row])
        }
        else{
             cell = collectionView.dequeueReusableCellWithReuseIdentifier("ArrivalCell", forIndexPath: indexPath) as! ShuttleQueryCell
            cell.layer.borderColor = UIColor.blackColor().CGColor
            cell.layer.borderWidth=1
            cell.lblCell.text = String(arrivalArray[indexPath.row])
        }
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.blackColor().CGColor
        return cell
    }
    
    
    
}
