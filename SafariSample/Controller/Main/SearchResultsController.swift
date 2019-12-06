//
//  SearchResultsController.swift
//  SafariSample
//
//  Created by Nomad on 2019/12/04.
//  Copyright © 2019 Nomad. All rights reserved.
//

import UIKit

class SearchResultsController: UITableViewController, UISearchResultsUpdating {
	
	let sectionLists = ["Top Hits", "Google Search", "Bookmarks and History", "On This Page"]
	var topHitsData = ["a","b","c","d"]
	var googleSearchData = ["e","f","g"]
	var bookmarksAndHistoryData = ["h","i","j"]
	var onThisPageData = ["k","l","m"]
	
	var mainSearchController = UISearchController()
	var searchText: String?
	var isSearchBarEmpty: Bool?
	var isFiltering: Bool?
	
//	var isSearchBarEmpty: Bool {
//		return mainSearchController.searchBar.text?.isEmpty ?? true
//	}
//	var isFiltering: Bool {
//		return mainSearchController.isActive && !isSearchBarEmpty
//	}
	
	var originalData: [String] = []
	var displayData: [String] = []
	var filteredData: [String] = []
	
	func updateSearchResults(for searchController: UISearchController) {
		originalData = bookmarksAndHistoryData
		
		self.mainSearchController = searchController //????????????
		searchText = searchController.searchBar.text!
		isSearchBarEmpty = { searchController.searchBar.text?.isEmpty ?? true }()
		isFiltering = { searchController.isActive && !(isSearchBarEmpty ?? true)}()
//		isSearchBarEmpty = searchController.searchBar.text?.isEmpty
//		isFiltering = searchController.isActive && !isSearchBarEmpty!
		
		DispatchQueue.main.async {
			self.filterContentForSearchText(self.searchText!) //
			self.tableView.reloadData()
		}
	}
	
	func filterContentForSearchText(_ searchText: String) {
		filteredData = originalData.filter({ (string) -> Bool in
			Jamo.getJamo(string.lowercased()).contains(Jamo.getJamo(searchText.lowercased()))
		})
		tableView.reloadData()
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		bookmarksAndHistoryData = UserDefaults.standard.stringArray(forKey: "HistoryData") ?? [String]()
		//뒤에서 20개를 뺀다???
//		bookmarksAndHistoryData = arraySlice.dropLast(20)
		
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return sectionLists.count
	}
	
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sectionLists[section]
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		switch section {
		case 0:
			return topHitsData.count
		case 1:
			return googleSearchData.count
		case 2:
			if isFiltering! {
				return filteredData.count
			}
			return bookmarksAndHistoryData.count
		case 3:
			return onThisPageData.count
		default:
			return 1
		}
		
//		if sectionLists[section] == "Top Hits" {
//			return topHitsData.count
//		}
//		if sectionLists[section] == "Google Search" {
//			return googleSearchData.count
//		}
//		if sectionLists[section] == "Bookmarks and History" {
//			return bookmarksAndHistoryData.count
//		}
//		if sectionLists[section] == "On This Page" {
//			return onThisPageData.count
//		}
//		return 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell", for: indexPath)
		
		switch indexPath.section {
		case 0:
			cell.textLabel?.text = topHitsData[indexPath.row]
			cell.detailTextLabel?.text = "detail"
		case 1:
			cell.textLabel?.text = googleSearchData[indexPath.row]
			cell.detailTextLabel?.text = "detail"
		case 2:
			if isFiltering! {
				cell.textLabel?.text = filteredData[indexPath.row]
				cell.detailTextLabel?.text = "FOUND IT"
			}
			cell.textLabel?.text = bookmarksAndHistoryData[indexPath.row]
			cell.detailTextLabel?.text = "detail"
		case 3:
			cell.textLabel?.text = onThisPageData[indexPath.row]
			cell.detailTextLabel?.text = "detail"
		default:
			return cell
		}
		
		
//
//		if indexPath.section == 0 {
//			cell.textLabel?.text = topHitsData[indexPath.row]
//			cell.detailTextLabel?.text = "detail"
//		}
//		if indexPath.section == 1 {
//			cell.textLabel?.text = googleSearchData[indexPath.row]
//			cell.detailTextLabel?.text = "detail"
//		}
//		if indexPath.section == 2 {
//			cell.textLabel?.text = bookmarksAndHistoryData[indexPath.row]
//			cell.detailTextLabel?.text = "detail"
//		}
//		if indexPath.section == 3 {
//			cell.textLabel?.text = onThisPageData[indexPath.row]
//			cell.detailTextLabel?.text = "detail"
//		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//
		if indexPath.section == 0 {
			
		}
		if indexPath.section == 1 {
			
		}
		if indexPath.section == 2 {
			
		}
		if indexPath.section == 3 {
			
		}
	}

	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}



//MARK: - CharacterSet Extension
extension CharacterSet{
    static var modernHangul: CharacterSet{
        return CharacterSet(charactersIn: ("가".unicodeScalars.first!)...("힣".unicodeScalars.first!))
    }
}

//MARK: - 자음 모음
public class Jamo {
    
    // UTF-8 기준
    static let INDEX_HANGUL_START:UInt32 = 44032  // "가"
    static let INDEX_HANGUL_END:UInt32 = 55199    // "힣"
    
    static let CYCLE_CHO :UInt32 = 588
    static let CYCLE_JUNG :UInt32 = 28
    
    static let CHO = [
        "ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ",
        "ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"
    ]
    
    static let JUNG = [
        "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ","ㅕ", "ㅖ", "ㅗ", "ㅘ",
        "ㅙ", "ㅚ","ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ",
        "ㅣ"
    ]
    
    static let JONG = [
        "","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄹ","ㄺ",
        "ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅄ","ㅅ",
        "ㅆ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"
    ]
    
    static let JONG_DOUBLE = [
        "ㄳ":"ㄱㅅ","ㄵ":"ㄴㅈ","ㄶ":"ㄴㅎ","ㄺ":"ㄹㄱ","ㄻ":"ㄹㅁ",
        "ㄼ":"ㄹㅂ","ㄽ":"ㄹㅅ","ㄾ":"ㄹㅌ","ㄿ":"ㄹㅍ","ㅀ":"ㄹㅎ",
        "ㅄ":"ㅂㅅ"
    ]
    
    // 주어진 "단어"를 자모음으로 분해해서 리턴하는 함수
    class func getJamo(_ input: String) -> String {
        var jamo = ""
        //let word = input.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .punctuationCharacters)
        for scalar in input.unicodeScalars{
            jamo += getJamoFromOneSyllable(scalar) ?? ""
        }
        return jamo
    }
	
	class func getChosung(_ input: String) -> String {
		var chosungs = ""
		for scalar in input.unicodeScalars{
			 chosungs += getOnlyChosung(scalar) ?? ""
		}
		return chosungs
	}
    
    // 주어진 "코드의 음절"을 자모음으로 분해해서 리턴하는 함수
    private class func getJamoFromOneSyllable(_ n: UnicodeScalar) -> String?{
        if CharacterSet.modernHangul.contains(n){
            let index = n.value - INDEX_HANGUL_START
            let cho = CHO[Int(index / CYCLE_CHO)]
            let jung = JUNG[Int((index % CYCLE_CHO) / CYCLE_JUNG)]
            var jong = JONG[Int(index % CYCLE_JUNG)]
            if let disassembledJong = JONG_DOUBLE[jong] {
                jong = disassembledJong
            }
            return cho + jung + jong
        }else{
            return String(UnicodeScalar(n))
        }
    }
	
	private class func getOnlyChosung(_ n: UnicodeScalar) -> String?{
			 if CharacterSet.modernHangul.contains(n){
				  let index = n.value - INDEX_HANGUL_START
				  let cho = CHO[Int(index / CYCLE_CHO)]
				 
				  return cho
			 }else{
				  return String(UnicodeScalar(n))
			 }
		}
}
