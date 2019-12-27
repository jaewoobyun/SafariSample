//
//  HistoryData.swift
//  SafariSample
//
//  Created by Nomad on 2019/12/17.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit

struct HistoryData: Codable {
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
	
}



