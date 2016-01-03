//
//  WatchConnectivityManager.swift
//  TracktionProto1
//
//  Created by Hervé PEROTEAU on 03/01/2016.
//  Copyright © 2016 Hervé PEROTEAU. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject {
	
	class var sharedInstance: WatchConnectivityManager {
		struct Singleton {
			static let instance = WatchConnectivityManager()
		}
		return Singleton.instance
	}
	
	func activateSession() {
		if (WCSession.isSupported()) {
			let session = WCSession.defaultSession()
			print("Activate session WatchConnectivity ...")
			session.delegate = self
			session.activateSession()
		}
	}
}

extension WatchConnectivityManager : WCSessionDelegate {
	
	func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]){
		print("didReceiveUserInfo ...")
		NSNotificationCenter.defaultCenter().postNotificationName("WKdidReceiveUserInfo",
			object: nil, userInfo: userInfo)
	}
}
