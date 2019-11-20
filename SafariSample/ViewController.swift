//
//  ViewController.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/18.
//  Copyright © 2019 Nomad. All rights reserved.
//

import UIKit
import QuartzCore
import WebKit

class ViewController: UIViewController, UISearchControllerDelegate {
	
	
	let searchController = UISearchController(searchResultsController: nil)
	lazy var searchBar = UISearchBar(frame: CGRect.zero)
	
	@IBOutlet weak var webView: WKWebView!

	var isGalleryOpen = false
	
	let images = [
		ImageViewCard(imageNamed: "sampleImage1", title: "SampleImage1"),
		ImageViewCard(imageNamed: "favorites", title: "favorites"),
		ImageViewCard(imageNamed: "tabs", title: "tabs"),
		ImageViewCard(imageNamed: "bookmark", title: "bookmark")
	]
	
	//	let URLArray = [URL(string: "https://m.naver.com"), URL(string: "https://m.daum.net/?nil_top=mobile"), URL(string: "https://learnappmaking.com")]
	//
	//	let customWebViews = [
	//		CustomWebView(url: URL(string: "https://m.naver.com")! , title: ""),
	//		CustomWebView(url: URL(string: "https://m.daum.net/?nil_top=mobile")! , title: ""),
	//		CustomWebView(url: URL(string: "https://learnappmaking.com")! , title: "")
	//	]
	
	//MARK: - ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		searchController.delegate = self
		
		if #available(iOS 11.0, *) {
			searchBar = searchController.searchBar
			
			//			if let navigationbar = self.navigationController?.navigationBar {
			//				navigationbar.isHidden = true
			//			}
			//			for subview in (self.navigationController?.navigationBar.subviews)! {
			//				if NSStringFromClass(subview.classForCoder).contains("BarBackground") {
			//					  var subViewFrame: CGRect = subview.frame
			//					  // subViewFrame.origin.y = -20;
			//					  subViewFrame.size.height = 200
			//					  subview.frame = subViewFrame
			//
			//				 }
			//
			//			}
			
			
			navigationItem.searchController = searchController
			navigationItem.hidesSearchBarWhenScrolling = false
			navigationItem.prompt = nil
			navigationController?.toolbar.delegate = self
		}
		searchBar.showsBookmarkButton = true
		let refreshImage = UIImage(systemName: "arrow.clockwise")
		let aIcon = UIImage(systemName: "a")
		searchBar.setImage(aIcon, for: UISearchBar.Icon.search, state: UIControl.State.normal)
		searchBar.setImage(refreshImage, for: UISearchBar.Icon.bookmark, state: UIControl.State.normal)
		
		
		//		navigationController?.navigationBar.isHidden = true
		//		self.view.addSubview(searchBar)
		//		searchBar.translatesAutoresizingMaskIntoConstraints = false
		//		searchBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
		//		searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
		//		searchBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
		//		searchBar.widthAnchor.constraint(equalToConstant: 30).isActive = true
		//
		//		searchBar.searchBarStyle = .minimal
		//		navigationItem.searchController = searchController
		//
		//		let appearance = UINavigationBarAppearance()
		//		appearance.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -5.0)
		//		self.navigationController?.navigationBar.standardAppearance = appearance
		//		self.navigationController?.navigationBar.standardAppearance = standard
		//		let appearance = navigationController?.navigationBar.standardAppearance.copy()
		//		let appearance = navigationController?.navigationBar.compactAppearance?.copy()
		////configure appearance
		//		navigationItem.standardAppearance = appearance
		
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.searchBar.placeholder = "Search or enter website name"
		searchController.obscuresBackgroundDuringPresentation = false
		
		//		let request = URLRequest(url: URL(string: "https://learnappmaking.com")!)
		let request = URLRequest(url: URL(string: "https://m.naver.com")!)
		webView?.load(request)
		
//		if let filePath = Bundle.main.url(forResource: "bookmarks_11_19_19", withExtension: "html") {
//			let request = NSURLRequest(url: filePath)
//			webView.load(request as URLRequest)
//		}
		
		
		webView?.navigationDelegate = self
		
		self.webView.scrollView.delegate = self
		
		//FIXME: - hide
		//		self.webView?.isHidden = true
		
		
	}
	
	//MARK: - ViewDidAppear
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		for image in images {
			image.layer.anchorPoint.y = 0.0
			image.frame = CGRect(x: 0, y:100, width: 375, height: 400)
			image.didSelect = selectImage
			//375 667
//			self.view.addSubview(image)//
		}
		
		//		for webView in customWebViews {
		//			webView.layer.anchorPoint.y = 0.0
		//			webView.frame = CGRect(x: 0, y: 100, width: 375, height: 400)
		//			let request = URLRequest(url: URLArray[0]!)
		//			webView.load(request)
		//			webView.didSelect = selectWebView
		//			self.view.addSubview(webView)
		//		}
		//		navigationItem.title = images.last?.title
		//		navigationItem.titleView?.isHidden = true //??
		
		var perspective = CATransform3DIdentity
		perspective.m34 = -1.0/250.0
		view.layer.sublayerTransform = perspective
		
	}
	
	//MARK: - ViewWillAppear
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//		navigationController?.hidesBarsOnSwipe = true
	}
	
	//MARK: - ViewWillDisappear
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		//		navigationController?.hidesBarsOnSwipe = false
	}
	
	
	func searchWebSite(urlString: String) {
		let url = URL(string: urlString)
		let request = URLRequest(url: url!)
		self.webView?.load(request)
	}
	
	//	func selectWebView(selectedWebView: CustomWebView) {
	//		for subview in view.subviews {
	//			guard let webV = subview as? CustomWebView else {
	//				continue
	//			}
	//			if webV === selectedWebView {
	//				UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
	//					webV.layer.transform = CATransform3DIdentity
	//				}) { (_) in
	//					self.view.bringSubviewToFront(webV)
	//				}
	//			} else {
	//				UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
	//					webV.alpha = 0.0
	//				}) { (_) in
	//					webV.alpha = 1.0
	//					webV.layer.transform = CATransform3DIdentity
	//				}
	//			}
	//		}
	//		isGalleryOpen = false
	//	}
	
	func selectImage(selectedImage: ImageViewCard) {
		for subview in view.subviews {
			guard let image = subview as? ImageViewCard else {
				continue
			}
			if image === selectedImage {
				UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
					image.layer.transform = CATransform3DIdentity
				}) { (_) in
					self.view.bringSubviewToFront(image)
				}
			} else {
				UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
					image.alpha = 0.0
				}) { (_) in
					image.alpha = 1.0
					image.layer.transform = CATransform3DIdentity
				}
			}
		}
		
		self.navigationItem.title = selectedImage.title
		isGalleryOpen = false
	}
	
	
	@IBAction func backButton(_ sender: UIBarButtonItem) {
		self.webView.goBack()
	}
	@IBAction func forwardButton(_ sender: UIBarButtonItem) {
		self.webView.goForward()
	}
	
	@IBAction func shareButton(_ sender: UIBarButtonItem) {
		let message = "Message goes here"
		if let link = NSURL(string: self.searchBar.text!) {
			let objectsToShare = [message, link] as [Any]
			let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
			activityVC.excludedActivityTypes = []
			self.present(activityVC, animated: true, completion: nil)
		}
	}
	
	@IBAction func openTabs(_ sender: Any) {
		if isGalleryOpen {
			self.webView.isHidden = true //
			for subview in view.subviews {
				guard let image = subview as? ImageViewCard else {
					continue
				}
				let animation = CABasicAnimation(keyPath: "transform")
				animation.fromValue = NSValue(caTransform3D: image.layer.transform)
				animation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
				animation.duration = 0.33
				
				image.layer.add(animation, forKey: nil)
				image.layer.transform = CATransform3DIdentity
			}
			isGalleryOpen = false
			return
		}
		
		var imageYOffset: CGFloat = 50.0
		
		for subview in view.subviews {
			guard let image = subview as? ImageViewCard else {
				continue
			}
			//
			var imageTransform = CATransform3DIdentity
			//1
			imageTransform = CATransform3DTranslate(imageTransform, 0.0, imageYOffset, 0.0)
			//2
			imageTransform = CATransform3DScale(imageTransform, 0.95, 0.6, 1.0)
			//3
			imageTransform = CATransform3DRotate(imageTransform, .pi/8, -1.0, 0.0, 0.0)
			
			let animation = CABasicAnimation(keyPath: "transform")
			animation.fromValue = NSValue(caTransform3D: image.layer.transform)
			animation.toValue = NSValue(caTransform3D: imageTransform)
			animation.duration = 0.33
			image.layer.add(animation, forKey: nil)
			
			image.layer.transform = imageTransform
			
			imageYOffset += view.frame.height / CGFloat(images.count)
			
		}
		self.webView.isHidden = false
		isGalleryOpen = true
		
		//		if isGalleryOpen {
		//			for subview in view.subviews {
		//				guard let image = subview as? CustomWebView else {
		//					continue
		//				}
		//				let animation = CABasicAnimation(keyPath: "transform")
		//				animation.fromValue = NSValue(caTransform3D: image.layer.transform)
		//				animation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
		//				animation.duration = 0.33
		//			}
		//			isGalleryOpen = false
		//			return
		//		}
		//
		//		var imageYOffset: CGFloat = 50.0
		//
		//		for subview in view.subviews {
		//			guard let webV = subview as? CustomWebView else {
		//				continue
		//			}
		//			var imageTransform = CATransform3DIdentity
		//			//1
		//			imageTransform = CATransform3DTranslate(imageTransform, 0.0, imageYOffset, 0.0)
		//			//2
		//			imageTransform = CATransform3DScale(imageTransform, 0.95, 0.6, 1.0)
		//			//3
		//			imageTransform = CATransform3DRotate(imageTransform, .pi/8, -1.0, 0.0, 0.0)
		//
		//			let animation = CABasicAnimation(keyPath: "transform")
		//			animation.fromValue = NSValue(caTransform3D: webV.layer.transform)
		//			animation.toValue = NSValue(caTransform3D: imageTransform)
		//			animation.duration = 0.33
		//			webV.layer.transform = imageTransform
		//
		//			imageYOffset += view.frame.height / CGFloat(customWebViews.count)
		//
		//		}
		//		isGalleryOpen = true
		
	}
	
}

//MARK: - ScrollView Delegate
extension ViewController: UIScrollViewDelegate {
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		
		if(velocity.y>0) {
			//Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
			UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
				            self.navigationController?.setNavigationBarHidden(true, animated: true)
				            self.navigationController?.setToolbarHidden(true, animated: true)
				//				self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
				//				self.navigationController?.toolbar.isHidden = true
				
				print("Hide")
			}, completion: nil)
			
		} else {
			UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions(), animations: {
				self.navigationController?.setNavigationBarHidden(false, animated: true)
				self.navigationController?.setToolbarHidden(false, animated: true)
				print("Unhide")
			}, completion: nil)
		}
	}
	
}

//MARK: - UIToolBar Delegate
extension ViewController: UIToolbarDelegate {
	func position(for bar: UIBarPositioning) -> UIBarPosition {
		
		return UIBarPosition.bottom
	}
	
	
	
}

//MARK: - UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		print("updateSearchResults")
		searchBar = searchController.searchBar
		//		searchWebSite(urlString: searchBar.text!)
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//		searchWebSite(urlString: searchBar.text!)
		guard var urlString = searchBar.text?.lowercased() else {
			return
		}
		
		if !urlString.contains("://") {
			if urlString.contains("localhost") || urlString.contains("127.0.0.1") {
				urlString = "http://" + urlString
			} else {
				urlString = "https://" + urlString
			}
		}
		
		if webView.url?.absoluteString == urlString {
			return
		}
		
		if let targetUrl = URL(string: urlString) {
			webView.load(URLRequest(url: targetUrl))
		}
	}
	
	func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
		searchBar.endEditing(true)
		return false
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBarTextDidEndEditing(searchBar)
	}
	
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		print("textDidChange")
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.searchBar.endEditing(true)
//		self.searchBar.resignFirstResponder()
		//FIXME: - keyboard 내려가야됨
	}
	
	func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
		//TODO: - refresh
		print("bookmark button clicked")
	}
	
	
	
	
}

//MARK: - WKNavigationDelegate
extension ViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		print("didStartProvisionalNavigation")
	}
	
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		print("didCommit")
		if let url = webView.url {
			if url.scheme != "file" {
				if let urlString = webView.url?.absoluteString {
					UserDefaults.standard.set(urlString, forKey: "LastCommittedURLString")
					searchBar.text = urlString
				}
			} else {
				UserDefaults.standard.removeObject(forKey: "LastCommittedURLString")
				searchBar.text = url.lastPathComponent
			}
		}
	}
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		print("didFinish")
	}
	
//	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
//		//TODO: -
//	}
	
	
	
}
