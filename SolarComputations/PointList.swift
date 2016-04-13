//
//  PointList.swift
//  SunSeekerApp
//
//  Created by Gudbrand Tandberg on 09/04/16.
//  Copyright (c) 2016 Duff Development. All rights reserved.
//

import Foundation
import UIKit

struct PointList {
	
	var points : [CGPoint]
	var count : Int
	var bezierPath : UIBezierPath
	
	init() {
		points = []
		count = 0
		bezierPath = UIBezierPath()
	}
	
	mutating func addPoint(p: CGPoint) {
		
		self.points.append(p)
		(count == 0) ? bezierPath.moveToPoint(p) : bezierPath.addLineToPoint(p)

		self.count++
	}
	
	func getNearestPoint(x: CGFloat) -> CGPoint {
		
		var index = -1
		var lowest = 10000.0 as CGFloat
		
		for point in points {
			var diff = abs(x - point.x)
			if diff < lowest {
				lowest = diff
				index++
			}
		}
		return points[index]
	}
	
//	func toUIBezierPath() -> UIBezierPath {
//		return bezierPath
//	}
	
	subscript(index: Int) -> CGPoint { //should check bounds?
		get {
			return points[index]
		}
		set(newValue) {
			points[index] = newValue
		}
	}
	
}