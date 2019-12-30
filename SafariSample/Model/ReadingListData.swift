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
			let first = letter[letter.startIndex]
			return String(first)
		}
		
		return "?"
	}
	
	func getIconLetterColor() -> UIColor {
		let color = UIColor.red
		let iconText = getFirstIconLetter()
		//랜덤컬러를 지정하여 반환할것, 기준값은 icon text.
		
		
		
		return color
	}
}
