//
//  History.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/20.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit

class History: BookmarksVC {
	
	var visitedWebsites: [String] = ["www.google.com", "www.naver.com", "www.facebook.com", "www.daum.net"]
	var Dates: [String] = ["Tuesday Afternoon", "Monday, November 18", "Saturday, November 16"]
	
	//MARK: - ViewDidLoad
	override func viewDidLoad() {
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "historycellsample")
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return Dates.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return visitedWebsites.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "historycellsample", for: indexPath)
		cell.textLabel?.text = visitedWebsites[indexPath.row]
		
		return cell
	}
	
	
}
