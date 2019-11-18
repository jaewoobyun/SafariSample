//
//  OpenTabsVC.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/18.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit

class  OpenTabsVC: UIViewController {
	var isGalleryOpen = false
	
	let images = [
		ImageViewCard(imageNamed: "sampleImage1", title: "SampleImage1"),
		ImageViewCard(imageNamed: "favorites", title: "favorites"),
		ImageViewCard(imageNamed: "tabs", title: "tabs"),
		ImageViewCard(imageNamed: "bookmark", title: "bookmark")
	]
	
	override func viewDidAppear(_ animated: Bool) {
			super.viewDidAppear(animated)
			
			for image in images {
				image.layer.anchorPoint.y = 0.0
				image.frame = CGRect(x: 0, y:100, width: 375, height: 400)
				image.didSelect = selectImage
				//375 667
				self.view.addSubview(image)
			}
			navigationItem.title = images.last?.title
			
			var perspective = CATransform3DIdentity
			perspective.m34 = -1.0/250.0
			view.layer.sublayerTransform = perspective
		}
	
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
		}
	
}
