//
//  JulianDate.swift
//  
//
//  Created by Gudbrand Tandberg on 26/09/15.
//
//

import Foundation

/*
* Takes as input a localized date and encapsulates this as a JDN and JD in UTC
*
* Example: date = 13 Feb 1993 19:32:00 UTC+7 corresponds to
*				   13 Feb 1993 12:32:00 UTC+0 corresponds to
*				   JD = 2449032.02222
*/

let secsPerHour = 60 * 60
let hoursPerMinute = 1.0 / 60.0
let hoursPerDay = 24.0
let daysPerMinute = 1 / (60.0 * 24)
let daysPerSecond = 1 / (60.0 * 60 * 24)
let julianDateFormat = "g"

public struct JulianDate {
	
	//the important stuff
	var JDN : Int = 0
	var JD : Double = 0.0
	var fractionalDay : FractionalDay = FractionalDay()
	
	var  date : NSDate = NSDate()
	
	public init() {}
	
	public init(fracDay : Double) {
		self.fractionalDay = FractionalDay(fractionalValue: fracDay)
	}
	
	public init(date : NSDate) {
		
		self.date = date
		//get initial guess for julian day
		let dateFormatter = NSDateFormatter()
		dateFormatter.timeZone = NSTimeZone(name: "UTC")
		dateFormatter.dateFormat = julianDateFormat
		
		JDN = dateFormatter.stringFromDate(date).toInt()! //could fail?
		
		//check if date is before noon, if so decrement julian day
		dateFormatter.dateFormat = "H"
		var UTCHour = dateFormatter.stringFromDate(date).toInt()!
		dateFormatter.dateFormat = "m"
		var UTCMinute = dateFormatter.stringFromDate(date).toInt()!
		dateFormatter.dateFormat = "s"
		var UTCSeconds = dateFormatter.stringFromDate(date).toInt()!
		
		switch (UTCHour) {
		case let h where ((0 <= h) && (h < 12)) : //before midday
			JDN -= 1
			fractionalDay = FractionalDay(fractionalValue: (12.0 + Double(UTCHour) + Double(UTCMinute) * daysPerMinute + Double(UTCSeconds) * daysPerSecond))
			
		case let h where ((12 <= h) && (h < 24)) :
			fractionalDay = FractionalDay(fractionalValue: -12.0 + Double(UTCHour) + Double(UTCMinute) * daysPerMinute + Double(UTCSeconds) * daysPerSecond)
		default : //never happens
			fractionalDay = FractionalDay(fractionalValue: 0.0)
		}
		
		JD = Double(JDN) + fractionalDay.fractionalValue
	}

}