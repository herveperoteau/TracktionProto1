//
//  TrackDataItem.swift
//  TracktionProto1
//
//  Created by Hervé PEROTEAU on 03/01/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import Foundation

class TrackDataItem {
	
	var trackId : Int = 0
	var timeStamp : Double = 0.0
	var accelerationX : Double = 0.0
	var accelerationY : Double = 0
	var accelerationZ : Double = 0
	
	static func fromDictionary(userInfo: [String : AnyObject]) -> TrackDataItem {
		let item = TrackDataItem()
		item.trackId = userInfo["trackId"] as! Int
		item.timeStamp = userInfo["timeStamp"] as! Double
		item.accelerationX = userInfo["accelerationX"] as! Double
		item.accelerationY = userInfo["accelerationY"] as! Double
		item.accelerationZ = userInfo["accelerationZ"] as! Double
		return item
	}
	
	func toDictionary() -> [String : AnyObject] {
		var userInfo = [String : AnyObject]()
		userInfo["trackId"] = trackId
		userInfo["timeStamp"] = timeStamp
		userInfo["accelerationX"] = accelerationX
		userInfo["accelerationY"] = accelerationY
		userInfo["accelerationZ"] = accelerationZ
		return userInfo
	}
}