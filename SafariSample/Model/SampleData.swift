//
//  SampleData.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/28.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation

struct SampleData {
	
	var folderTitle: String
	var isExpanded: Bool = false
	var indexDepth: Int = 0
	var contents: [String?]
	
	init(folderTitle: String, isExpanded: Bool, indexDepth: Int, contents: [String?]) {
		self.folderTitle = folderTitle
		self.isExpanded = isExpanded
		self.indexDepth = indexDepth
		self.contents = contents
	}
	
	
}
