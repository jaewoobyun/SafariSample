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
		case historyDataInstance
		case backListData
		case forwardListData
		///히스토리 데이터가 업데이트 됬을때 사용한다.
		case HistoryDataUpdate
		///리딩 리스트 데이터가 업데이트 됬을때 사용한다.
		case ReadingListDataUpdate
		
		func getNotificationName() -> Notification.Name? {
			switch self {
			case .bookmarkURLName:
				return Notification.Name.init("bookmarkURLName")
			case .readinglistURLName:
				return Notification.Name.init("readinglistURLName")
			case .historyURLName:
				return Notification.Name.init("historyURLName")
			///우리가 추출하고 싶은 방문기록
			case .historyDataInstance:
				return Notification.Name.init("historyDataInstance")
			/// 백 버튼을 눌렀을때 쌓이는 과거 기록들
			case .backListData:
				return Notification.Name.init("backListData")
			/// 앞으로 버튼 눌렀을때 쌓이는 기로
			case .forwardListData:
				return Notification.Name.init("forwardListData")
				
			case .HistoryDataUpdate:
				return Notification.Name.init("HistoryDataUpdate")
			
			case .ReadingListDataUpdate:
				return Notification.Name.init("ReadingListDataUpdate")
				
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
