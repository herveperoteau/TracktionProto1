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
	
	func setupUI() {
		self.lbStatus.text = "Waiting tracking on Watch ..."
		self.lbTrackId.text = "xxxx"
		self.lbTimeStamp.text = "xxxxxxxxxxxxxxxx"
		self.setAccelerationXValue(0)
		self.setAccelerationYValue(0)
		self.setAccelerationZValue(0)
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
	
}


