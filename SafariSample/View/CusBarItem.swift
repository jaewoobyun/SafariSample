//
//  CusBarItem.swift
//  SafariSample
//
//  Created by Nomad on 2020/01/03.
//  Copyright © 2020 Nomad. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Custom Bar Button Item for long press functionality
/**
#CustomBarItem
- tapEvent
- longEvent
*/
class CusBarItem: UIBarButtonItem {
	
	let touchView:UIView = UIView()
	let imageView:UIImageView = UIImageView()
	
	var tapEvent:(()->())?
	var longEvent:(()->())?
	
	override class func awakeFromNib() {
		super.awakeFromNib()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		//TODO: - 뒤로 가거나 앞으로 갈 수 있을때 파란색으로 활성화 시키고 싶다.
//		self.isEnabled = super.isEnabled
//		super.isEnabled = self.isEnabled
		
		initSetting()
	}
	
	func initSetting() {
		if let cus = self.customView {
			print("cus!!");
		} else {
			print("cus nil");
			//			if let image = self.backgroundImage(for: .normal, barMetrics: .default) {
			//
			//			}
			//			touchView.backgroundColor = UIColor.red
			touchView.frame = CGRect(x: 0, y: 0, width: 27, height: 27)
			self.customView = touchView
			
			imageView.frame = touchView.frame
			imageView.image = self.image
			touchView.addSubview(imageView)
			imageView.contentMode = .scaleAspectFit
			
			let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tap))  //Tap function will call when user tap on button
//			tapGesture.isEnabled = super.isEnabled //??????
			let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))  //Long function will call when user long press on button.
			tapGesture.numberOfTapsRequired = 1
			longGesture.minimumPressDuration = 0.5
			longGesture.numberOfTouchesRequired = 1
			imageView.addGestureRecognizer(tapGesture)
			imageView.addGestureRecognizer(longGesture)
			
			imageView.isUserInteractionEnabled = true
			
		}
	}
	
	@objc func tap() {
		if let tapEvent = self.tapEvent {
			tapEvent()
		}
	}
	
	@objc func long() {
		if let longEvent = self.longEvent {
			longEvent()
		}
	}
}
