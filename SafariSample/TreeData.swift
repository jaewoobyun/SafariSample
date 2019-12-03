//
//  TreeData.swift
//  SafariSample
//
//  Created by Nomad on 2019/11/29.
//  Copyright © 2019 Nomad. All rights reserved.
//

import Foundation
import UIKit

class TreeData {
	
	let title: String
//	let url: URL
//	let iconUrl: URL
	var children: [TreeData]
	
	init(title: String, children: [TreeData]) {
		self.title = title
//		self.url = url
//		self.iconUrl = iconUrl
		self.children = children
	}
	
	convenience init(title: String) {
		self.init(title: title, children: [TreeData]())
	}
	
	func addChild(_ child: TreeData) {
		self.children.append(child)
	}
	
	func removeChild(_ child: TreeData) {
		self.children = self.children.filter( {$0 !== child })
	}

}

extension TreeData {
	static func getDefaultData() -> [TreeData] {
		 let subChild121 = TreeData(title: "Albea")
		 let subChild122 = TreeData(title: "Egea")
		 let subChild123 = TreeData(title: "Linea")
		 let subChild124 = TreeData(title: "Siena")
		 
		 let child11 = TreeData(title: "Volvo")
		 let child12 = TreeData(title: "Fiat", children:[subChild121, subChild122, subChild123, subChild124])
		 let child13 = TreeData(title: "Alfa Romeo")
		 let child14 = TreeData(title: "Mercedes")
		 let parent1 = TreeData(title: "Sedan", children: [child11, child12, child13, child14])
		 
		 let subChild221 = TreeData(title: "Discovery")
		 let subChild222 = TreeData(title: "Evoque")
		 let subChild223 = TreeData(title: "Defender")
		 let subChild224 = TreeData(title: "Freelander")
		 
		 let child21 = TreeData(title: "GMC")
		 let child22 = TreeData(title: "Land Rover" , children: [subChild221,subChild222,subChild223,subChild224])
		 let parent2 = TreeData(title: "SUV", children: [child21, child22])
		 
		 
		 let child31 = TreeData(title: "Wolkswagen")
		 let child32 = TreeData(title: "Toyota")
		 let child33 = TreeData(title: "Dodge")
		 let parent3 = TreeData(title: "Truck", children: [child31, child32,child33])
		 
		 let subChildChild5321 = TreeData(title: "Carrera", children: [child31, child32,child33])
		 let subChildChild5322 = TreeData(title: "Carrera 4 GTS")
		 let subChildChild5323 = TreeData(title: "Targa 4")
		 let subChildChild5324 = TreeData(title: "Turbo S")
		 
		 let parent4 = TreeData(title: "Van",children:[subChildChild5321,subChildChild5322,subChildChild5323,subChildChild5324])
		 
		
		 
		 let subChild531 = TreeData(title: "Cayman")
		 let subChild532 = TreeData(title: "911",children:[subChildChild5321,subChildChild5322,subChildChild5323,subChildChild5324])
		 
		 let child51 = TreeData(title: "Renault")
		 let child52 = TreeData(title: "Ferrari")
		 let child53 = TreeData(title: "Porshe", children: [subChild531, subChild532])
		 let child54 = TreeData(title: "Maserati")
		 let child55 = TreeData(title: "Bugatti")
		 let parent5 = TreeData(title: "Sports Car",children:[child51,child52,child53,child54,child55])

		 
//		 return [parent5,parent2,parent1,parent3,parent4]
		return [parent5]
		
	}
}
