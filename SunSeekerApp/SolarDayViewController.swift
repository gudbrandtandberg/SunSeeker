//
//  ViewController.swift
//  SunSeekerApp
//
//  Created by Gudbrand Tandberg on 09/04/16.
//  Copyright (c) 2016 Duff Development. All rights reserved.
//

import UIKit
import CoreLocation

let SUNSIZE : CGFloat = 70.0
let IPANE_WIDTH : CGFloat = 140.0
let IPANE_HEIGHT : CGFloat = 45.0


/*
* Beautifuly displays the trajectory and position of the sun for a given day
* 
*
*/

class SolarDayViewController: UIViewController, UIGestureRecognizerDelegate {

	@IBOutlet weak var dateTitleLabel: UILabel!
	@IBOutlet weak var sunSpaceView: UIView!
	@IBOutlet weak var grassView: UIView!
	
	let sunView = UIImageView(image: UIImage(named: "sun.png"))
	let yellow = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
	let infoPane: InfoPaneView

	var sunTrajectory = SunTrajectory()
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

		infoPane = InfoPaneView(frame: CGRectMake(0, 0, IPANE_WIDTH, IPANE_HEIGHT))
		
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
	
		
		view.addSubview(infoPane)
	}
	
	//	LÆREPENGE:
	//	You should not initialise UI geometry-related things in viewDidLoad,
	//	because the geometry of your view is not set at this point and the results will be unpredictable
	
	override func viewDidLayoutSubviews() {
		
		//should instead map data from pl to sunSpace rect
		//then add the sun and the path of the sun
		
		sunTrajectory = generateSinePointList()
		
		//only if path exists!
		drawPath()
//		sunView.center = pl[0] //pl[t_now]!
		sunView.frame.size = CGSizeMake(SUNSIZE, SUNSIZE)
		
		grassView.layer.zPosition = 2
		sunSpaceView.layer.zPosition = 0
		sunView.layer.zPosition = 1
		
		xPositionOfSun = sunTrajectory[0].p.x
		
		self.view.addSubview(sunView)



	}
	
	func drawPath() {
		
		let l = CAShapeLayer()
		l.path = sunTrajectory.bezierPath.CGPath
		l.fillColor = UIColor.clearColor().CGColor
		l.strokeColor = yellow.CGColor
		l.lineWidth = 7.0
		l.lineCap = kCALineCapRound
		l.zPosition = 0.5
		
		self.view.layer.addSublayer(l)

	}
	
	func flipY(point : CGPoint, axisHeight: CGFloat) -> CGPoint {
		//flips y-coordinate from (0, axisHeight) to (axisHeight, 0)
		return CGPointMake(point.x, axisHeight - point.y)
	}
	
	func generateSinePointList() -> SunTrajectory {
		
		let toRect = sunSpaceView.frame
		
		var trajectory = SunTrajectory()
		
		var pl = [CGPoint]()
		var t = [CGFloat]()
		
		var i : Int
		
		//-90*sin((pi*(x - 180)/360))
		//example values..
		let x0 = CGFloat(0.0)
		let w = CGFloat(180.0)
		let xn = CGFloat(180.0)

		let y0 = CGFloat(0.0)
		let h = CGFloat(90.0)
		let yn = CGFloat(90.0)
		
		let fromRect = CGRectMake(x0, y0, w, h)
		
		let numPoints = 12 * 60 //onc sample a minute
		
		let dx = w / CGFloat(numPoints-1)
		
		for i in 1...numPoints {
		
			var x = x0 + CGFloat(i-1) * dx
			let arg = CGFloat(M_PI) * x / w
			let y = h * sin(arg)
			
			let newPoint = CGPointMake(x, y)
			
			trajectory.addSpaceTimePoint(0.0, p: gmap(flipY(newPoint, axisHeight: h), fromRect: fromRect, toRect: toRect))
		}
		
		return trajectory
	}
	
	func mapFromabTocd(val : CGFloat, a : CGFloat, b: CGFloat, c : CGFloat, d : CGFloat) -> CGFloat {
		return (val-a)*(d-c)/(b-a) + c
		
	}
	
	func gmap(point : CGPoint, fromRect : CGRect, toRect : CGRect) -> CGPoint {
		
		var x : CGFloat = mapFromabTocd(point.x, a: fromRect.origin.x, b: fromRect.origin.x + fromRect.size.width, c: toRect.origin.x, d: toRect.origin.x + toRect.size.width)
		
		var y = mapFromabTocd(point.y, a: fromRect.origin.y, b: fromRect.origin.y + fromRect.size.height, c: toRect.origin.y, d: toRect.origin.y + toRect.size.height)
		
		return CGPointMake(x, y);
	}
	
	func moveSun(toXValue : CGFloat) {
		
		let nearestPoint = sunTrajectory.getNearestPointByX(toXValue)
		sunView.center = nearestPoint.p
		infoPane.center = CGPointMake(nearestPoint.p.x, nearestPoint.p.y - IPANE_HEIGHT)
		
		let x = String(format: "%.1f", Float(nearestPoint.p.x))
		let y = String(format: "%.1f", Float(nearestPoint.p.y))
		
		infoPane.positionLabel.text = "Alt. (" + x + "\u{B0}N \nAz. " + y + "\u{B0}E)"
		//timeLabel.text =
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

