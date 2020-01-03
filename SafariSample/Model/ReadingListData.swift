//
//  ReadingListData.swift
//  SafariSample
//
//  Created by Nomad on 2019/12/30.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit

struct ReadingListData: Codable {
	var url: URL? //ex)www.google.com//search?source... ???
	var initialUrl: URL? // 제일 첫 URL? ex) www.google.com ???
	var title: String? //구글
	var urlString: String?
	var date: Date? //방문한 시각
	var uuid: String = UUID.init().uuidString
	
	init(url: URL, initialUrl: URL, title: String, urlString: String, date: Date) {
		self.url = url
		self.initialUrl = initialUrl
		self.title = title
		self.urlString = urlString
		self.date = date
	}
	
	func getFirstIconLetter() -> String {
		if let letter = title {
			if letter.isEmpty {
				return "?"
			}
			
			let first = letter[letter.startIndex]
			return String(first)
		}
		
		return "?"
	}
	
	
	
	func getIconLetterColor() -> UIColor {
		
		let iconText = getFirstIconLetter()
		//랜덤컬러를 지정하여 반환할것, 기준값은 icon text.
		
		var total: Int = 0
		for u in iconText.unicodeScalars {
			total += Int(UInt32(u))
		}
		
		srand48(total * 200)
		let r = CGFloat(drand48())
		
		srand48(total)
		let g = CGFloat(drand48())
		
		srand48(total / 200)
		let b = CGFloat(drand48())
		
		return UIColor(red: r, green: g, blue: b, alpha: 1)
	}
}

extension UIColor {
	public static var random: UIColor {
		let max = CGFloat(UInt32.max)
		let red = CGFloat(arc4random()) / max
		let green = CGFloat(arc4random()) / max
		let blue = CGFloat(arc4random()) / max
		
		return UIColor(red: red, green: green, blue: blue, alpha: 0.7)
	}
	
	/// rgb 만 들어와야함. 0x FF FF FF
	convenience init(rgb: UInt) {
		 self.init(
			  red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
			  green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
			  blue: CGFloat(rgb & 0x0000FF) / 255.0,
			  alpha: CGFloat(1.0)
		 )
	}
}
