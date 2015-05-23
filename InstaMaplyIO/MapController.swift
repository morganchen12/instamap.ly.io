//
//  MapController.swift
//  InstaMaplyIO
//
//  Created by Morgan Chen on 5/23/15.
//  Copyright (c) 2015 Morgan Chen. All rights reserved.
//

import UIKit
import MapKit
import MediaPlayer
import AVFoundation

final class MapController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    let locationManager: CLLocationManager = CLLocationManager()
    var updateTimer: NSTimer? = nil
    var audioPlayer: AVAudioPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegateMaybe: AppDelegate? = UIApplication.sharedApplication().delegate as! AppDelegate?
        if let appDelegate = appDelegateMaybe {
            appDelegate.mapController = self
        }
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
        var error: NSError? = nil
        if let resourcePath = NSBundle.mainBundle().resourcePath,
           let url = NSURL(fileURLWithPath: "\(resourcePath)/blank.mp3"),
           let audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error) {
            self.audioPlayer = audioPlayer
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.updateRegionAnimated(false)
        self.drawMap()
    }
    
    private func updateRegionAnimated(animated: Bool) {
        let center = self.locationManager.location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(region, animated: animated)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            self.mapView.showsUserLocation = true
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.updateRegionAnimated(true)
    }
    
    func drawMap() {
        let width = self.mapView.frame.size.width
        let height = self.mapView.frame.size.height
        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        self.mapView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let mapImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: mapImage),
            MPMediaItemPropertyArtist: "Don't get lost",
            MPMediaItemPropertyTitle: "You Are Here",
            MPMediaItemPropertyAlbumTitle: "The dream",
        ]
    }
    
    @IBAction func refreshPressed(sender: AnyObject) {
        self.drawMap()
    }
    
    func updateMapInBackground() {
        self.updateRegionAnimated(false)
        self.drawMap()
    }
    
    internal func startUpdatingLocationInBackground() {
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(150), target: self, selector: "updateMapInBackground", userInfo: nil, repeats: true)
    }
    
    internal func stopUpdatingLocationInBackground() {
        if let updateTimer = self.updateTimer {
            updateTimer.invalidate()
        }
        self.updateTimer = nil
    }
}
