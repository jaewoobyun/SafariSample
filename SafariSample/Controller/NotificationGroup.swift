//
//  NotificationGroup.swift
//  SafariSample
//
//  Created by Nomad on 2019/12/11.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit

class NotificationGroup {
	static let shared = NotificationGroup()
	
	private init(){
//		super.init() /// NotificationGroup 이 다른 class 를 상속하고 있을때는 상위 클래스의 초기화도 해준다
	}
	
	enum NotiType: String {
		case bookmarkURLName
		case readinglistURLName
		case historyURLName
		
		func getNotificationName() -> Notification.Name? {
			switch self {
			case .bookmarkURLName:
				return Notification.Name.init("bookmarkURLName")
			case .readinglistURLName:
				return Notification.Name.init("readinglistURLName")
			case .historyURLName:
				return Notification.Name.init("historyURLName")
			default:
				return nil
			}
		}
	}
	
	func registerObserver(type: NotiType, vc:UIViewController, selector: Selector) {
		guard let name = type.getNotificationName() else {
			return
		}
		
		//여기에서 노티등록과정을 진행할것.
		NotificationCenter.default.addObserver(vc, selector: selector, name: name, object: nil)
		
	}
	
	func post(type: NotiType, userInfo: [AnyHashable : Any]? = nil) {
		guard let name = type.getNotificationName() else {
			return
		}
		
		NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
	}
	
	func removeAllObserver(vc: UIViewController) {
		NotificationCenter.default.removeObserver(vc)
	}
	
	
}
