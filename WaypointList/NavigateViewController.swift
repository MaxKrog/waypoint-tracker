//
//  NavigateViewController.swift
//  WaypointList
//
//  Created by Max Krog on 18/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import UIKit
import MapKit

class NavigateViewController: UIViewController, MasterTrackerDelegate, MKMapViewDelegate {
    
    //MARK: Properties
    var masterTracker: MasterTracker!
    var waypointModel: WaypointModel!
    
    //MARK: Outlets
    @IBOutlet weak var waypointLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var distanceLabel: UITextField!
    @IBOutlet weak var relativeBearingLabel: UITextField!
    @IBOutlet weak var convertedBearingLabel: UITextField!
    
    @IBOutlet weak var map: MKMapView!{
        didSet {
            map.delegate = self
            map.pitchEnabled = false
            map.rotateEnabled = false
            map.scrollEnabled = false
            map.showsUserLocation = true
            map.userTrackingMode = .FollowWithHeading
            map.mapType = .Hybrid
    }
}

    //MARK: Actions
    @IBAction func stepperClick(sender: UIStepper) {
        let intValue = Int(stepper.value)
        masterTracker.updateActiveWaypointIndex(intValue)
    }
    
    @IBAction func changeAuto(sender: UISwitch) {
        masterTracker.changeAuto(sender.on)
    }
    
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        print("Navigate view did load")
        super.viewDidLoad()
        
        if let waypointModel = waypointModel {
            masterTracker = MasterTracker(waypointModel: waypointModel)
            masterTracker.delegate = self
            masterTracker.play()
            navigationItem.title = waypointModel.title
            
            stepper.maximumValue = Double(waypointModel.waypoints.count - 1)
            stepper.minimumValue = 0
            stepper.value = 0
        }
        

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        masterTracker.pause()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("NavigateVew: viewWillAppear")
        super.viewWillAppear(animated)

    }
    
    //MARK: Delegate to MasterTracker
    
    func updateActiveWaypoint(activeWaypointIndex: Int) {
        let activeWaypointIndexReadable = activeWaypointIndex + 1
        waypointLabel.text = "Active waypoint: \(activeWaypointIndexReadable.description) of \(waypointModel.waypoints.count.description)"
    }
    
    func distanceChanged() {
        distanceLabel.text = "Distance: \(masterTracker.distance)"
    }
    
    func bearingChanged(){
        relativeBearingLabel.text = "Rel Bear: \(masterTracker.relativeBearing)"
        convertedBearingLabel.text = "Conv Bear: \(masterTracker.convertedBearing)"
        
    }
    
    //MARK: - NAVIGATION
    
}
