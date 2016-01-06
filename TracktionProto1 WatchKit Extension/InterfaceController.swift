//
//  InterfaceController.swift
//  TracktionProto1 WatchKit Extension
//
//  Created by Hervé PEROTEAU on 29/12/2015.
//  Copyright © 2015 Hervé PEROTEAU. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import WatchConnectivity

class InterfaceController: WKInterfaceController {
	
	// MARK: - Interface
	@IBOutlet var xLbl: WKInterfaceLabel!
	@IBOutlet var yLbl: WKInterfaceLabel!
	@IBOutlet var zLbl: WKInterfaceLabel!
	@IBOutlet var xValues: WKInterfaceLabel!
	@IBOutlet var yValues: WKInterfaceLabel!
	@IBOutlet var zValues: WKInterfaceLabel!
	
	@IBOutlet var countValue: WKInterfaceLabel!
	@IBOutlet var btnStartStop: WKInterfaceButton!
	
	// MARK: - Properties
	private let motionManager = CMMotionManager()
	
	var tracking = false
	var countTracking = 0
	var startSessionTimestamp: NSTimeInterval = 0
	var countdown = 0
	var timerCountdown: NSTimer?
	
	// MARK: - Context Initializer
	override func awakeWithContext(context: AnyObject?) {
		super.awakeWithContext(context)
		
		// Configure interface objects here.
		self.xValues.setText("-")
		self.yValues.setText("-")
		self.zValues.setText("-")
	}
	
	// MARK: - Calls
	override func willActivate() {
		// This method is called when watch view controller is about to be visible to user
		super.willActivate()
		//getMotionManagerUpdates()
	}
	
	override func didDeactivate() {
		// This method is called when watch view controller is no longer visible
		super.didDeactivate()
		//stopMotionUpdates()
	}
	
	func stopMotionUpdates() {
		// vibration when stop
		WKInterfaceDevice.currentDevice().playHaptic(.Stop)
		self.motionManager.stopAccelerometerUpdates()
	}
	
	// MARK: - Get Accelerometer Data
	func getMotionManagerUpdates() {
		
		// vibration when start
		WKInterfaceDevice.currentDevice().playHaptic(.Start)
		
		// init interval for update (NSTimeInterval)
		self.motionManager.accelerometerUpdateInterval = 0.1
		
		// get current accelerometerData
		if self.motionManager.accelerometerAvailable {
			
			// operation main queue
			let mainQueue: NSOperationQueue = NSOperationQueue.mainQueue()
			
			// start accelerometer updates
			self.motionManager.startAccelerometerUpdatesToQueue(mainQueue, withHandler: { (accelerometerData:CMAccelerometerData?, error:NSError?) -> Void in
				// errors
				if (error != nil) {
					print("error: \(error?.localizedDescription)")
				}else{
					// success
					if ((accelerometerData) != nil) {
						
						// get accelerations values
						let x:String = NSString(format: "%.2f", (accelerometerData?.acceleration.x)!) as String
						let y:String = NSString(format: "%.2f", (accelerometerData?.acceleration.y)!) as String
						let z:String = NSString(format: "%.2f", (accelerometerData?.acceleration.z)!) as String
						
						print("x: \(x)")
						print("y: \(y)")
						print("z: \(z)")
						
						// set text labels
						self.xValues.setText(x)
						self.yValues.setText(y)
						self.zValues.setText(z)
						
						if (self.tracking) {
							self.countTracking++
							self.countValue.setText(String(self.countTracking))
							let trackItem = TrackDataItem()
							trackItem.trackStartSession = self.startSessionTimestamp
							trackItem.trackId = self.countTracking
							trackItem.accelerationX = (accelerometerData?.acceleration.x)!
							trackItem.accelerationY = (accelerometerData?.acceleration.y)!
							trackItem.accelerationZ = (accelerometerData?.acceleration.z)!
							trackItem.timeStamp = (accelerometerData?.timestamp)!
							self.sendTrackItem(trackItem)
						}
					}
				}
			})
		}
	}
	
	@IBAction func startStopTrackingAction() {
		
		if (tracking) {
			tracking = false
			stopCountDown()
			btnStartStop.setTitle("START")
			
			// Send last track to close session
			let trackItem = TrackDataItem()
			trackItem.trackStartSession = startSessionTimestamp
			trackItem.trackId = self.countTracking
			trackItem.accelerationX = 0
			trackItem.accelerationY = 0
			trackItem.accelerationZ = 0
			trackItem.timeStamp = 0
			trackItem.info = infoEndSession
			sendTrackItem(trackItem)
			
			stopMotionUpdates()
		}
		else {
			countTracking = 0
			startSessionTimestamp = NSDate().timeIntervalSince1970
			tracking = true
			startCountDown()
		}
	}
	
	func startCountDown() {
		countdown = 5
		btnStartStop.setTitle("\(countdown)")
		timerCountdown = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countdownStep:", userInfo: nil, repeats: true)
	}
	
	func stopCountDown() {
		if let timerCountdown = timerCountdown {
			timerCountdown.invalidate()
			self.timerCountdown = nil
		}
	}
	
	func countdownStep(timer:NSTimer!) {
		countdown--
		btnStartStop.setTitle("\(countdown)")
		if (countdown == 0) {
			stopCountDown()
			if (tracking) {
				btnStartStop.setTitle("STOP")
				getMotionManagerUpdates()
			}
		}
	}
	
	func sendTrackItem(trackItem: TrackDataItem) {
		
		let session = WCSession.defaultSession()
		
		// send to iPhone
		session.transferUserInfo(trackItem.toDictionary())
	}
}
