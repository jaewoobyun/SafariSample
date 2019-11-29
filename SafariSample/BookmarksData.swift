//
//  BookmarksData.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/25.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation

class BookmarksData {
	struct Folders {
		var folderName: String
		var items: [Bookmark]
	}
	
	struct Bookmark {
		var name: String
		var href: URL
		var icon: URL?
	}
	
	
}


extension BookmarksData {
	
	
	
}
