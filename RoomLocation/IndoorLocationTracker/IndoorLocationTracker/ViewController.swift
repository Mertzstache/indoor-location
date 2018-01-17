//
//  ViewController.swift
//  IndoorLocationTracker
//
//  Created by Eric Mertz on 1/14/18.
//  Copyright © 2018 Eric Mertz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, EILIndoorLocationManagerDelegate {


    var locationBuilder = EILLocationBuilder()
    var locationManager = EILIndoorLocationManager()
    
    var location : EILLocation!
    
    @IBOutlet weak var myLocationView: EILIndoorLocationView!
    @IBOutlet weak var myPositionLabel: UILabel!
    
    
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.myLocationView.clearTrace()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ESTConfig.setupAppID("tiiltlab-gmail-com-s-indoo-m6q", andAppToken: "00d08917ec6ef680a6c2f2119446116c")

        self.locationBuilder.setLocationBoundaryPoints([EILPoint(x:0, y:0), EILPoint(x:0, y:4), EILPoint(x:3, y:4), EILPoint(x:3, y:0)])
        self.locationBuilder.setLocationOrientation(0.0)
        self.locationBuilder.setLocationName("0x235UniqueToApp")
        
        self.locationBuilder.addBeacon(withIdentifier: "7b6f239f7b2811c0e5f0e8094513f212", atBoundarySegmentIndex: 0, inDistance: 0, from: EILLocationBuilderSide.leftSide)
        self.locationBuilder.addBeacon(withIdentifier: "ff6a43970191b949d315b17f83135d0f", atBoundarySegmentIndex: 1, inDistance: 0, from: EILLocationBuilderSide.leftSide)
        self.locationBuilder.addBeacon(withIdentifier: "d1559116a15b2eaed2239837ce46f920", atBoundarySegmentIndex: 2, inDistance: 0, from: EILLocationBuilderSide.leftSide)
        self.locationBuilder.addBeacon(withIdentifier: "6f324e5b8fdacee293241e78deeeb92d", atBoundarySegmentIndex: 3, inDistance: 0, from: EILLocationBuilderSide.leftSide)
        
        
        self.locationManager.delegate = self
        self.locationManager.mode = EILIndoorLocationManagerMode.normal

        // TODO: replace with an identifier of your own location
        // You will find the identifier on https://cloud.estimote.com/#/locations
        
        
//        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "lab-config-1")
//        fetchLocationRequest.sendRequest { (location, error) in
        if true {//let location = location {
                self.location = self.locationBuilder.build()
                
                self.myLocationView.showTrace = true
                self.myLocationView.rotateOnPositionUpdate = false
                self.myLocationView.showWallLengthLabels = true
                
                self.myLocationView.backgroundColor = UIColor.clear
                
                self.myLocationView.rotateOnPositionUpdate = false
                
                self.myLocationView.locationBorderColor = UIColor.black
                self.myLocationView.locationBorderThickness = 4
                

                
                

                // Consult the full list of properties on:
                // http://estimote.github.io/iOS-Indoor-SDK/Classes/EILIndoorLocationView.html
                self.myLocationView.drawLocation(location)
                
                let rect = CGRect(x: 0, y: 0, width: 150, height: 75)
                
                let uielem = UIView(frame: rect)
                uielem.backgroundColor = UIColor(red: 66/255.0, green: 179/255.0, blue: 244/255.0, alpha: 0.5)
//                uielem.layer.shadowColor = UIColor.black as! CGColor
                uielem.layer.shadowOffset = CGSize(width: 2, height: 2)
                uielem.layer.cornerRadius = 7.0
                
//
//                uielem.text = "station"
//                uielem.textAlignment = NSTextAlignment.center
//                uielem.textColor = UIColor.white
//                uielem.isOpaque = false
//
                
                let station = EILOrientedPoint(x: 1.65, y:3.3, orientation: 0)
                self.myLocationView.drawObject(inBackground: uielem, withPosition: station, identifier: "test-station")
                self.locationManager.startPositionUpdates(for: self.location)
            } else {
                print("error")
                //print("can't fetch location: \(error)")
            }
        //}
        
    }
    
    func indoorLocationManager(_ manager: EILIndoorLocationManager, didFailToUpdatePositionWithError error: Error) {
        print("failed to update position: \(error)")
    }

    func indoorLocationManager(_ manager: EILIndoorLocationManager, didUpdatePosition position: EILOrientedPoint, with positionAccuracy: EILPositionAccuracy, in location: EILLocation) {
        var accuracy: String!
        switch positionAccuracy {
        case .veryHigh: accuracy = "+/- 1.00m"
        case .high:     accuracy = "+/- 1.62m"
        case .medium:   accuracy = "+/- 2.62m"
        case .low:      accuracy = "+/- 4.24m"
        case .veryLow:  accuracy = "+/- ? :-("
        case .unknown:  accuracy = "unknown"
        }
        self.myPositionLabel.text = String(format: "x: %5.2f, y: %5.2f, Ori: %3.0f, Acc: %@",
                     position.x, position.y, position.orientation, accuracy)
        self.myLocationView.updatePosition(position)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

