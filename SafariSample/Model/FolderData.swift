//
//  FolderData.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/28.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation

struct FolderData {
	
	var sectionTitle: String
	var isExpanded: Bool
	var containsUserSelectedValue: Bool
	var sectionOptions: [String]
	
	init(sectionTitle: String, isExpanded: Bool, containsUserSelectedValue: Bool, sectionOptions: [String]) {
		self.sectionTitle = sectionTitle
		self.isExpanded = isExpanded
		self.containsUserSelectedValue = containsUserSelectedValue
		self.sectionOptions = sectionOptions
	}
	
}
