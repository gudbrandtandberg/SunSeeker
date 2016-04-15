//
//  SunPositionCalculator.swift
//  
//
//  Created by Gudbrand Tandberg on 26/09/15.
//
//

import Foundation
import CoreLocation
import UIKit

public class SunLocationCalculator {
	
	var observerLatitude : Angle
	var observerLongitude : Angle
	var julianDate : JulianDate
	
	let perihelion = Angle(degrees: 102.9372)
	let obliquity = Angle(degrees: 23.45)
	let oneEighty = Angle(degrees: 180.0)
	
	let h_0 = -0.83
	let M_0 = 357.5291
	let M_1 = 0.98560028
	let J_2000 = 2451545.0
	let theta_0 = 280.1600
	let theta_1 = 360.9856235
	let C_1 = 1.9148
	let A_2 = -2.4680
	
	let J_0 = 0.0009
	let J_1 = 0.0053
	let J_2 = -0.0069
	let J_3 = 1.0000000
	
	let secondsPerDay = 60.0 * 60 * 24
	let julianDateFormat = "g"
	
	var currentTimezoneOffset : NSTimeInterval {
		return NSTimeInterval(NSTimeZone.localTimeZone().secondsFromGMT)
	}
	
	public init(location : CLLocation, julianDate : JulianDate) {
		observerLongitude = Angle(degrees: location.coordinate.longitude)
		observerLatitude = Angle(degrees: location.coordinate.latitude)
		self.julianDate = julianDate
	}
	
	public init(location : CLLocation) {
		observerLongitude = Angle(degrees: location.coordinate.longitude)
		observerLatitude = Angle(degrees: location.coordinate.latitude)
		self.julianDate = JulianDate()
	}
	
	func meanAnomaly(julianDate : JulianDate) -> Angle {
		return Angle(degrees: M_0 + (M_1 * (julianDate.JD - J_2000)))
	}
	
	func center(meanAnomaly : Angle) -> Angle {
		
		var C = C_1 * sin(meanAnomaly)
		C += 0.0200 * sin(2 * meanAnomaly)
		C += 0.0003 * sin(3 * meanAnomaly)
		
		return Angle(degrees: C)
	}
	
	func eclipticalLongitude(meanAnomaly: Angle, center: Angle) -> Angle {
		return (meanAnomaly + center + perihelion + oneEighty)
	}
	
	func ascention(eclipticalLongitude: Angle) -> Angle {
		return Angle(radians: atan(tan(eclipticalLongitude) * cos(obliquity)))
	}
	
	func declination(eclipticalLongitude: Angle) -> Angle {
		return Angle(radians: asin(sin(obliquity) * sin(eclipticalLongitude)))
	}
	
	func siderealTime(julianDate: JulianDate, longitude: Angle) -> Angle {
		return Angle(degrees: theta_0 + theta_1 * (julianDate.JD - J_2000)
			+ longitude.degrees)
	}
	
	func hourAngle(siderealTime: Angle, ascention: Angle) -> Angle {
		return (siderealTime - ascention)
	}
	
	func azimuth(hourAngle: Angle, latitude: Angle, declination: Angle) -> Angle {
		return Angle(radians: atan(sin(hourAngle) /
			(cos(hourAngle) * sin(latitude) - tan(declination) * cos(latitude))))
	}
	
	func altitude(hourAngle: Angle, latitude: Angle, declination: Angle) -> Angle {
		return Angle(radians: asin(sin(latitude) * sin(declination) + cos(latitude) * cos(declination) * cos(hourAngle)))
	}
	
	public func getRiseSetTimes() -> (NSDate, NSDate) {
		
		var n_star = (julianDate.JD - 2451545.0009 + observerLongitude.degrees / 360)
		var n = floor(n_star + 1/2)
		
		var J_star = 2451545.0009 - observerLongitude.degrees / 360 + n
		
		var M = meanAnomaly(julianDate)
		var C = center(M)
		var l = eclipticalLongitude(M, center: C)
		
		var d = declination(l)
		
		var J_transit = J_star + 0.0053 * sin(M) - 0.0069 * sin(2 * l)
		
		var hourAngle = acos((sin(h_0.radians) - sin(observerLatitude) * sin(d)) / (cos(observerLatitude) * cos(d))).degrees
		
		var J_set = J_transit + hourAngle / 360
		var J_rise = J_transit - hourAngle / 360
		
		return (dateFromJulianDate(J_rise), dateFromJulianDate(J_set))
	}
	
	public func getSunPosition(day : JulianDate) -> (Angle, Angle) {
		
		
		
		
		return (Angle(degrees: 0.0), Angle(degrees: 0.0))
	}
	
	public func getSunPosition() -> (Angle, Angle) {
		
		var M = meanAnomaly(julianDate)
		var C = center(M)
		var λ = eclipticalLongitude(M, center: C)
		var α = ascention(λ)
		var δ = declination(λ)
		var θ = siderealTime(julianDate, longitude: observerLongitude)
		var H = hourAngle(θ, ascention: α)
		
		var A = azimuth(H, latitude: observerLatitude, declination: δ)
		var h = altitude(H, latitude: observerLatitude, declination: δ)
		
		return (A, h)
		
	}
	
}


