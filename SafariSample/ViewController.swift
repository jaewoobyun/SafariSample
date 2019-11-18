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

class ViewController: UIViewController {
	
	
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

	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationItem.titleView?.isHidden = true
		navigationItem.searchController = searchController
		
//		let appearance = UINavigationBarAppearance()
//		appearance.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -5.0)
//		self.navigationController?.navigationBar.standardAppearance = appearance
//		self.navigationController?.navigationBar.standardAppearance = standard
//		let appearance = navigationController?.navigationBar.standardAppearance.copy()
//		let appearance = navigationController?.navigationBar.compactAppearance?.copy()
		////configure appearance
//		navigationItem.standardAppearance = appearance
		
//		navigationItem.hidesSearchBarWhenScrolling = false
		
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.searchBar.placeholder = "Search or enter website name"
		searchController.obscuresBackgroundDuringPresentation = false
		
//		let request = URLRequest(url: URL(string: "https://learnappmaking.com")!)
		let request = URLRequest(url: URL(string: "https://m.naver.com")!)
		webView?.load(request)
		webView?.navigationDelegate = self
		
		self.webView?.isHidden = true
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		for image in images {
			image.layer.anchorPoint.y = 0.0
			image.frame = CGRect(x: 0, y:100, width: 375, height: 400)
			image.didSelect = selectImage
			//375 667
			self.view.addSubview(image)
		}
		
//		for webView in customWebViews {
//			webView.layer.anchorPoint.y = 0.0
//			webView.frame = CGRect(x: 0, y: 100, width: 375, height: 400)
//			let request = URLRequest(url: URLArray[0]!)
//			webView.load(request)
//			webView.didSelect = selectWebView
//
//			self.view.addSubview(webView)
//		}
		
//		navigationItem.title = images.last?.title
		
		navigationItem.titleView?.isHidden = true //??
		
		var perspective = CATransform3DIdentity
		perspective.m34 = -1.0/250.0
		view.layer.sublayerTransform = perspective
		
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
	@IBAction func backButton(_ sender: UIButton) {
		self.webView.goBack()
	}
	@IBAction func forwardButton(_ sender: UIButton) {
		self.webView.goForward()
	}
	
	@IBAction func shareButton(_ sender: UIButton) {
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


extension ViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		print("updateSearchResults")
		searchBar = searchController.searchBar
//		searchWebSite(urlString: searchBar.text!)
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchWebSite(urlString: searchBar.text!)
	}
}

extension ViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		print("textDidChange")
		
	}
	
	
}

extension ViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		print("didStartProvisionalNavigation")
	}
	
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		print("didCommit")
	}
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		print("didFinish")
	}
	
	
	
}
