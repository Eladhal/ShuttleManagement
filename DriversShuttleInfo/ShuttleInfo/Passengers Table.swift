//
//  Passengers Table.swift
//  Shuttle info
//
//  Created by elad halperin on 9/5/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class Passengers_Table: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var strTitle:String?

    var arrShuttlePassengers:[String]=[]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = strTitle
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrShuttlePassengers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")
        cell?.textLabel?.text = arrShuttlePassengers[indexPath.row]
        cell!.layer.borderWidth = 1.0
        cell!.layer.borderColor = UIColor.blackColor().CGColor
        return cell!
    }

}
