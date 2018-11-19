//
//  ViewController.swift
//  iBeaconTemplateSwift
//
//  Created by subramanya on 20/01/16.
//  Copyright © 2015 subramanya. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var tableView: UITableView?
    var beacons: [CLBeacon]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        navigationItem.title = "Beacons in the region" //to set the title of nav bar
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.title = "Region"//if not here,in storyboard
        
        print("yeah")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var signalBarImage: UIImageView!
    @IBOutlet weak var detailTextLabel1: UILabel!
    @IBOutlet weak var textLabel1: UILabel!
}

extension ViewController {
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            print("yeah2")
            if(beacons != nil) {
                return beacons!.count
            } else {
//                if #available(iOS 8.0, *) {
//                    let alertBox = UIAlertController(title: "No Beacons Found", message: "Can't find any beacons in the area.\nPlease try again later.", preferredStyle: UIAlertControllerStyle.Alert)
//                    alertBox.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                    self.presentViewController(alertBox, animated: true, completion: nil)
//                    }
                print("the else part")
                return 0
            }
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            print("cellforrow")
            let cell = tableView.dequeueReusableCellWithIdentifier("MyIdentifier1") as! CustomCell
            
            cell.textLabel1?.numberOfLines = 0
            cell.detailTextLabel1?.numberOfLines = 0
            cell.sizeToFit()
            let beacon:CLBeacon = beacons![indexPath.row]
            var proximityLabel:String! = ""
            
            switch beacon.proximity {
            case CLProximity.Far:
                proximityLabel = "Far"
            case CLProximity.Near:
                proximityLabel = "Near"
            case CLProximity.Immediate:
                proximityLabel = "Immediate"
            case CLProximity.Unknown:
                proximityLabel = "Unknown"
            }
            
            if(beacon.minor == 23306){//0117c55b943f
                cell.textLabel1.text = "Beacon 1 : \(proximityLabel)"
            }
            if(beacon.minor == 25909){//0117c55e445e
                cell.textLabel1?.text = "Beacon 2 : \(proximityLabel)"
            }
            if(beacon.minor == 5177){//0117c55dfb8d
                cell.textLabel1.text = "Beacon 3 : \(proximityLabel)"
            }
            //cell!.textLabel!.text = "Proximity :\(proximityLabel)| Minorvalue:\(beacon.minor.integerValue)"//"iBeacons"
            
            func distanceCalc() -> String{
                switch(beacon.accuracy){
                    case 0..<0.11 : return "Within 0.1 meter"
                    case 0.11..<0.20: return "Within 0.2 meter"
                    case 0.20..<0.30: return "Within 0.3 meter"
                    case 0.30..<0.40: return "Within 0.4 meter"
                    case 0.40..<0.50: return "Within 0.5 meter"
                    case 0.50..<0.60: return "Within 0.6 meter"
                    case 0.60..<0.70: return "Within 0.7 meter"
                    case 0.70..<0.80: return "Within 0.8 meter"
                    case 0.80..<0.90: return "Within 0.9 meter"
                    case 0.90..<1: return "Within 1 meter"
                    case 1..<2: return "Within 2 meter"
                    case 2..<10: return "Beyond 2 meters"
                    default: return "distance cant be found"
                }
            }
            
            let detailLabel1:String = "Distance: \(distanceCalc())" +
            //"\nMajor: \(beacon.major.integerValue)," +
            "\nRSSI: \(beacon.rssi as Int)"
             //"\nUUID: \(beacon.proximityUUID.UUIDString)"
            cell.detailTextLabel1.text = detailLabel1
            
            if(beacon.rssi == 0){
                cell.signalBarImage.image = UIImage(named: "signalbar0")
            }
            if(beacon.rssi < 0 && beacon.rssi > -50 ){
                cell.signalBarImage.image = UIImage(named: "signalbar4")
            }
            if(beacon.rssi <= -50 && beacon.rssi > -57 ){
                cell.signalBarImage.image = UIImage(named: "signalbar3")
            }
            if(beacon.rssi <= -57 && beacon.rssi > -70 ){
                cell.signalBarImage.image = UIImage(named: "signalbar2")
            }
            if(beacon.rssi <= -70 ){
                cell.signalBarImage.image = UIImage(named: "signalBar1")
            }
            
            return cell
    }
}

