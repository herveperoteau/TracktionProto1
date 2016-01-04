//
//  TrackRealTimeViewController.swift
//  TracktionProto1
//
//  Created by Hervé PEROTEAU on 29/12/2015.
//  Copyright © 2015 Hervé PEROTEAU. All rights reserved.
//

import UIKit
import WatchConnectivity

class TrackRealTimeViewController: UIViewController {

	@IBOutlet weak var lbTrackId: UILabel!
	@IBOutlet weak var lbTimeStamp: UILabel!
	
	@IBOutlet weak var lbAccelerationX: UILabel!
	@IBOutlet weak var sliderAccelerationX: UISlider!

	@IBOutlet weak var lbAccelerationY: UILabel!
	@IBOutlet weak var sliderAccelerationY: UISlider!

	@IBOutlet weak var lbAccelerationZ: UILabel!
	@IBOutlet weak var sliderAccelerationZ: UISlider!

	@IBOutlet weak var lbStatus: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.registerForWKNotifications();
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		self.unregisterForWKNotifications()
	}
	
	func setupUI() {

		self.lbTrackId.text = "xxxx"
		self.lbTimeStamp.text = "xxxxxxxxxxxxxxxx"
		self.setAccelerationXValue(0)
		self.setAccelerationYValue(0)
		self.setAccelerationZValue(0)

		if let session = WatchConnectivityManager.sharedInstance.session {
			if !session.paired {
				self.lbStatus.text = "Need paired with your watch !"
			}
			else {
				self.lbStatus.text = "Waiting tracking on Watch ..."
			}
		}
		else {
			self.lbStatus.text = "WatchApp not supported"
		}
	}
	
	func refreshWithTrackDataItem(item: TrackDataItem) {
		dispatch_async(dispatch_get_main_queue()) {
			self.lbStatus.text = "Tracking ..."
			self.lbTrackId.text = String(format:"%f", item.trackId)
			self.lbTimeStamp.text = String(format:"%f", item.timeStamp)
			self.setAccelerationXValue(item.accelerationX)
			self.setAccelerationYValue(item.accelerationY)
			self.setAccelerationZValue(item.accelerationZ)
		}
	}

	func setAccelerationXValue(value: Double) {
		lbAccelerationX.text = NSString(format: "%.2f", value) as String
		sliderAccelerationX.value = Float(value)
	}
	
	func setAccelerationYValue(value: Double) {
		lbAccelerationY.text = NSString(format: "%.2f", value) as String
		sliderAccelerationY.value = Float(value)
	}
	
	func setAccelerationZValue(value: Double) {
		lbAccelerationZ.text = NSString(format: "%.2f", value) as String
		sliderAccelerationZ.value = Float(value)
	}
	
	func registerForWKNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "handlerWCdidReceiveUserInfo",
			name:NotificationWCdidReceiveUserInfo, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "handlerWCsessionWatchStateDidChange",
			name:NotificationWCsessionWatchStateDidChange, object: nil)
	}
	func unregisterForWKNotifications() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationWCdidReceiveUserInfo, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationWCsessionWatchStateDidChange, object: nil)
	}
	func handlerWKdidReceiveUserInfo(notification: NSNotification){
		if let trackItem = notification.object as? TrackDataItem {
			refreshWithTrackDataItem(trackItem)
		}
	}
	func handlerWCsessionWatchStateDidChange(notification: NSNotification){
		if let session = notification.object as? WCSession {
			if (!session.paired) {
				self.lbStatus.text = "Need paired with your watch !!!"
			}
		}
	}

}


