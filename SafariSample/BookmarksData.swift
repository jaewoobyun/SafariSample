//
//  BookmarksData.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/25.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit

//class BookmarksData {
//	struct Folders {
//		var folderName: String
//		var items: [Bookmark]
//	}
//
//	struct Bookmark {
//		var name: String
//		var href: URL
//		var icon: URL?
//	}
//
//
//}


struct BookmarksData {
	let urlString: String?
	let titleString: String?
	let iconUrlString: String?
	
	var isFolder: Bool {
		get { return (child.count == 0) ? false : true }
	}
	
	var child: [BookmarksData] = []
	
	/// initializing BOOKMARK Data
	init(urlString: String, titleString: String, iconUrlString: String = "") {
		self.urlString = urlString
		self.titleString = titleString
		self.iconUrlString = iconUrlString
	}
	
	/// initializing FOLDER Data
	init(titleString: String, child: [BookmarksData]) {
		self.urlString = ""
		self.titleString = titleString
		self.iconUrlString = ""
		self.child = child
	}
	
	func getBookMarkUrl() -> URL? {
		if isFolder { return nil }
		
		if let url = URL.init(string: urlString ?? "") {
			return url
		}
		return nil
	}
	
	func getIconUrl() -> URL? {
		if isFolder { return nil }
		
		if let url = URL.init(string: iconUrlString ?? "") {
			return url
		}
		return nil
	}
	
}

class BookmarksDataModel {
	
	static var bookMarkDatas: [BookmarksData] = []
	
	static func createSampleData() {
		
		var temp: [BookmarksData] = []
		
		for folderIndex in 0..<10 {
			var child: [BookmarksData] = []
			
			for bookmarkIndex in 0..<5 {
				let childItem = BookmarksData.init(urlString: "http://\(folderIndex).com", titleString: "folder \(folderIndex) \(bookmarkIndex)")
				child.append(childItem)
			}
			let grandchild = BookmarksData.init(urlString: "bookmark", titleString: "Grandchild")
			let bookmarkChildItem = BookmarksData.init(titleString: "folder6", child: [grandchild])
			child.append(bookmarkChildItem)
			
			let folderData = BookmarksData.init(titleString: "folder_ \(folderIndex)", child: child)
			temp.append(folderData)
		}
		print(temp)
		
		bookMarkDatas.removeAll()
		bookMarkDatas.append(contentsOf: temp)
		
		let tempBookmark = BookmarksData.init(urlString: "http://???.com", titleString: "This is a bookmark")
		bookMarkDatas.append(tempBookmark)
	}
	
}
