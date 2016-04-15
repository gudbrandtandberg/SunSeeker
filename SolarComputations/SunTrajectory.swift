//
//  PointList.swift
//  SunSeekerApp
//
//  Created by Gudbrand Tandberg on 09/04/16.
//  Copyright (c) 2016 Duff Development. All rights reserved.
//

import Foundation
import UIKit

typealias SpaceTimePoint = (t: CGFloat,p: CGPoint)

struct SunTrajectory {
	
	var times : [CGFloat]
	var points : [CGPoint]
	var count : Int
	var bezierPath : UIBezierPath
	
	init() {
		times = []
		points = []
		count = 0
		bezierPath = UIBezierPath()
	}
	
	mutating func addSpaceTimePoint(t: CGFloat, p: CGPoint) {
		
		self.points.append(p)
		self.times.append(t)
		
		(count == 0) ? bezierPath.moveToPoint(p) : bezierPath.addLineToPoint(p)

		self.count++
	}
	
	func getNearestPointByX(x: CGFloat) -> SpaceTimePoint {
		
		var index = 0
		var lowest : CGFloat = 10000.0
		
		for point in points {
			var diff = abs(x - point.x)
			if diff < lowest {
				lowest = diff
				index++
			}
		}
		
		return (times[index-1], points[index-1])
	}
	
	subscript(index: Int) -> SpaceTimePoint { //should check bounds?
		get {if (index > count){println("Index out of bounds"); exit(1)}
			else {
				return (times[index], points[index])
			}
		}
		set(newValue) {
			(times[index], points[index]) = newValue
		}
	}
	
}