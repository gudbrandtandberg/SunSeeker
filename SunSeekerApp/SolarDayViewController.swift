//
//  ViewController.swift
//  SunSeekerApp
//
//  Created by Gudbrand Tandberg on 09/04/16.
//  Copyright (c) 2016 Duff Development. All rights reserved.
//

import UIKit
import CoreLocation

/*
* specs:
* x-location of finger in view determines position of ball along a Bezier
* 
* routines:
*/


class SolarDayViewController: UIViewController, UIGestureRecognizerDelegate {

	@IBOutlet weak var dateTitleLabel: UILabel!

	@IBOutlet weak var sunSpaceView: UIView!
	
	let sunView = UIImageView(image: UIImage(named: "sun.png"))
	let yellow = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)

	var rect : CGRect = CGRectZero
	
	var pl = PointList()
	var t = [NSDate]()
	
	let dateFormatter : NSDateFormatter = NSDateFormatter()
	
	var dateToDisplay : NSDate = NSDate() {
		willSet(newValue) {
			dateTitleLabel.text = dateFormatter.stringFromDate(newValue)
		}
		didSet {

		}
	}

	var xPositionOfSun : CGFloat = (0.0 as CGFloat) {
		willSet(newValue) {
			moveSun(newValue)
		}
		didSet {
			
		}
	}
	
	required init(coder aDecoder: NSCoder) {
		
		dateFormatter.dateStyle = .MediumStyle
		dateFormatter.timeStyle = .MediumStyle
		dateFormatter.locale = NSLocale.currentLocale()

		super.init(coder: aDecoder)
		
		//trenger SolarComputer objekt:
		let kampotLocation = CLLocation(latitude: 10.7412, longitude: 104.1931)
		
		let spc = SunLocationCalculator(location: kampotLocation, julianDate: JulianDate(date: dateToDisplay))
		
		//fill pl and t array with points from sunrise to sunset with preset granularity
		
		//pl = spc.positions //pl = [(x1, y1), (x2, y2), ... (xn, yn)] [CGPoint]
		//t = spc.times //t = [t1, t2, ..., tn] [NSDate]
		
		//spc should also have properties nowPos : CGPoint and nowTime : NSDate
	
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dateTitleLabel.text = dateFormatter.stringFromDate(dateToDisplay) //simpler
		rect = sunSpaceView.frame
		pl = generateSinePointListWithFrame(rect) //needs to know the view!
		
		//only if path exists!
		drawPath()
		sunView.frame.size = CGSizeMake(50.0, 50.0)
		sunView.center = pl[0] //pl[t_now]!
		self.view.addSubview(sunView)
		
	}
	
	func drawPath() {
		
		let l = CAShapeLayer()
		l.path = pl.bezierPath.CGPath
		l.fillColor = UIColor.clearColor().CGColor
		l.strokeColor = yellow.CGColor
		l.lineWidth = 7.0
		l.lineCap = kCALineCapRound
		
		self.view.layer.addSublayer(l)

	}
	
// (0 180) -> (y, y + h)
//	
// (-180, 180) -> (x, x + w)   //x

// formula
//	(a, b) to (d, c)
//	f(x) = (x-a)/(b-a) * c + (x-b)/(a-b) * d
	
	func mapFromGeoToSunSpace(point : CGPoint, rectangle : CGRect) -> CGPoint {
		
		println(rectangle.origin.x)
		var x_min : CGFloat = rectangle.origin.x
		var w = rectangle.size.width
		var x_new = mapFromabTocd(point.x, a: -180.0, b: 180.0, c: x_min, d: (x_min + w))

		let y_min = rectangle.origin.y
		let h = rectangle.size.height
		let y_new = mapFromabTocd(point.y, a: 0.0, b: 180.0, c: y_min, d: (y_min + h))
		
		return CGPointMake(x_new, y_new)
	}
	
	func mapFromabTocd(value : CGFloat, a : CGFloat, b: CGFloat, c : CGFloat, d : CGFloat) -> CGFloat {
		
		var firstPart = (value-a)/(b-a)*c
		var secondPart = (value-b)/(a-b) * d

		return CGFloat(firstPart + secondPart)
		
	}
	
	func generateSinePointListWithFrame(rect : CGRect) -> PointList {
		
		var pl = PointList()
		var i : Int
		
		let x0 = CGFloat(-180.0)
		let w = CGFloat(360.0)
		let xn = CGFloat(180.0)

		let yn = CGFloat(0)      //flipped y-axis!?
		let h = CGFloat(180.0)
		let y0 = CGFloat(180.0)
		
		let numPoints = 12 * 60 //onc sample a minute
		
		let dx = w / CGFloat(numPoints-1)
		
		for i in 1...numPoints {
		
			var x = x0 + CGFloat(i-1) * dx
			let arg = 2.0 * CGFloat(M_PI) * x / (2 * w)
			let y = y0 - h * sin(arg)
			
			let newPointInGeoSpace = CGPointMake(x, y)
			
			pl.addPoint(mapFromGeoToSunSpace(newPointInGeoSpace, rectangle: rect))
		}

		return pl
	}
	
	func moveSun(toXValue : CGFloat) {
		sunView.center = pl.getNearestPoint(toXValue)
		
	}

	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		for touch in touches {
			
			//should check point
			
			//insta-move the sun to touch
			let point = touch.locationInView(self.view)
			xPositionOfSun = point.x
		}
	}
	
	@IBAction func pan(sender: UIPanGestureRecognizer!) {
		let touch = sender.locationInView(self.view)
		xPositionOfSun = touch.x
		
	}
}

