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
	
	let dataIndexPath:[Int]?
	
	var child: [BookmarksData] = []
	var isFolder: Bool {
//		get { return (child.count == 0) ? false : true }
		get {
			
			let temp = (urlString?.isEmpty ?? true) ? true : false
			return temp
		}
	}

	/// initializing BOOKMARK Data
	init(urlString: String, titleString: String, iconUrlString: String = "", indexPath:[Int]) {
		self.urlString = urlString
		self.titleString = titleString
		self.iconUrlString = iconUrlString
		self.dataIndexPath = indexPath
	}
	
	/// initializing FOLDER Data
	init(titleString: String, child: [BookmarksData], indexPath:[Int]) {
		self.urlString = nil
		self.titleString = titleString
		self.iconUrlString = ""
		self.child = child
		
		self.dataIndexPath = indexPath
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
	
	//For Tree Sytle data
	mutating func addChild(_ child: BookmarksData) {
		self.child.append(child)
	}
	
	mutating func removeChild(_ child: BookmarksData) {
//		self.child = self.child.filter({ $0 !== child })
	}
	//------------
}

class BookmarksDataModel {
	static var mockDataArray = ["www.google.com", "www.m.naver.com", "www.apple.com", "www.github.com", "www.facebook.com"]
	
	static var bookMarkDatas: [BookmarksData] = []
	
	static func createSampleData() {
		
		var temp: [BookmarksData] = []
		
		for folderIndex in 0..<10 {
			//append 10 folders
			var child: [BookmarksData] = []
			
			for bookmarkIndex in 0..<5 {
				//append 5 folders for each top folder
				
				let dataIndex:[Int] = [0, folderIndex, bookmarkIndex]
				let childItem = BookmarksData.init(urlString: "http://\(mockDataArray[bookmarkIndex])", titleString: "\(mockDataArray[bookmarkIndex])", indexPath: dataIndex)
				child.append(childItem)
			}
			
//			let grandchild = BookmarksData.init(urlString: "bookmark", titleString: "Grandchild Bookmark")
//			let bookmarkChildItem = BookmarksData.init(titleString: "folder 5", child: [grandchild])
//			child.append(bookmarkChildItem)
			
			let dataIndex:[Int] = [0, folderIndex]
			let folderData = BookmarksData.init(titleString: "folder_ \(folderIndex)", child: child, indexPath: dataIndex)
			temp.append(folderData)
		}
		
		let dataIndex:[Int] = [0, temp.count]
		let tempBookmark = BookmarksData.init(urlString: "http://???.com", titleString: "This is a bookmark", indexPath: dataIndex)
//		bookMarkDatas.append(tempBookmark)
		temp.append(tempBookmark)
//		print(temp)
		
		bookMarkDatas.removeAll()
//		bookMarkDatas.append(contentsOf: temp)
		//
		
		let firstdataIndex:[Int] = [0]
		let favorites = BookmarksData.init(titleString: "Favorites", child: temp, indexPath: firstdataIndex)
		bookMarkDatas.append(favorites)
		
		
		
	}
	
}
