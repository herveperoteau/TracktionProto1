//
//  TrackDataItem.swift
//  TracktionProto1
//
//  Created by Hervé PEROTEAU on 03/01/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import Foundation

let infoEndSession = "END"

let keyTrackStartSession = "tSS"
let keyTrackId = "tId"
let keyTimeStamp = "TS"
let keyAccelerationX = "X"
let keyAccelerationY = "Y"
let keyAccelerationZ = "Z"
let keyInfo = "I"

class TrackDataItem {
	
	var trackStartSession: Double = 0
	var trackId: Int = 0
	var timeStamp: Double = 0.0
	var accelerationX: Double = 0.0
	var accelerationY: Double = 0
	var accelerationZ: Double = 0
	var info: String = ""
	
	static func fromDictionary(userInfo: [String : AnyObject]) -> TrackDataItem {
		let item = TrackDataItem()
		item.trackStartSession = userInfo[keyTrackStartSession] as! Double
		item.trackId = userInfo[keyTrackId] as! Int
		item.timeStamp = userInfo[keyTimeStamp] as! Double
		item.accelerationX = userInfo[keyAccelerationX] as! Double
		item.accelerationY = userInfo[keyAccelerationY] as! Double
		item.accelerationZ = userInfo[keyAccelerationZ] as! Double
		item.info = userInfo[keyInfo] as! String
		return item
	}
	
	func toDictionary() -> [String : AnyObject] {
		var userInfo = [String : AnyObject]()
		userInfo[keyTrackStartSession] = trackStartSession
		userInfo[keyTrackId] = trackId
		userInfo[keyTimeStamp] = timeStamp
		userInfo[keyAccelerationX] = accelerationX
		userInfo[keyAccelerationY] = accelerationY
		userInfo[keyAccelerationZ] = accelerationZ
		userInfo[keyInfo] = info
		return userInfo
	}
}