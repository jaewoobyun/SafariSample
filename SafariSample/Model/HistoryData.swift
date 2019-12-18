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
	var urlString: String?
	var date: Date?
	
	init(urlString: String, date: Date) {
		self.urlString = urlString
		self.date = date
	}
}


