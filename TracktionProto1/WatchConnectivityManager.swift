//
//  WatchConnectivityManager.swift
//  TracktionProto1
//
//  Created by Hervé PEROTEAU on 03/01/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import Foundation
import WatchConnectivity

let NotificationWCdidReceiveUserInfo = "NotificationWCdidReceiveUserInfo"
let NotificationWCsessionWatchStateDidChange = "NotificationWCsessionWatchStateDidChange"

class WatchConnectivityManager: NSObject {
	
	class var sharedInstance: WatchConnectivityManager {
		struct Singleton {
			static let instance = WatchConnectivityManager()
		}
		return Singleton.instance
	}

	var session: WCSession? {
		didSet {
			if let session = session {
				session.delegate = self
				session.activateSession()
			}
		}
	}
		
	func activateSession() {
		if (WCSession.isSupported()) {
			session = WCSession.defaultSession()
		}
	}
}

extension WatchConnectivityManager : WCSessionDelegate {
	
	func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]){
		print("didReceiveUserInfo ...")
		let trackItem = TrackDataItem.fromDictionary(userInfo)
		dispatch_async(dispatch_get_main_queue()) {
			NSNotificationCenter.defaultCenter().postNotificationName(NotificationWCdidReceiveUserInfo,
				object: trackItem, userInfo: userInfo)
		}
	}
	
	func sessionWatchStateDidChange(session: WCSession) {
		print("sessionWatchStateDidChange session.paired=\(session.paired) ...")
		dispatch_async(dispatch_get_main_queue()) {
			NSNotificationCenter.defaultCenter().postNotificationName(NotificationWCsessionWatchStateDidChange,
				object: session, userInfo: nil)
		}
	}
}
