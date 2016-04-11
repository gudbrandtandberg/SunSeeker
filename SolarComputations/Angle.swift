//
//  Angle.swift
//  
//
//  Created by Gudbrand Tandberg on 26/09/15.
//
//

import Foundation

extension Double {
	var mod360 : Double {
		return self % 360
	}
	var radians : Double {
		return self * 2 * M_PI / 360
	}
	var degrees : Double {
		return self * 360 / (2 * M_PI)
	}
}

public struct Angle {
	
	public var degrees : Double
	public var radians : Double
	public var fractionalDays : FractionalDay
	
	init(degrees: Double) {
		self.degrees = degrees.mod360
		radians = degrees * 2 * M_PI / 360
		fractionalDays = FractionalDay(fractionalValue: degrees / 15)
	}
	
	init(radians: Double) {
		self.radians = radians
		degrees = (radians * 360 / (2 * M_PI)).mod360
		fractionalDays = FractionalDay(fractionalValue: degrees / 15)
	}
}

func sin(value: Angle) -> Double {
	return sin(value.radians)
}
func cos(value: Angle) -> Double {
	return cos(value.radians)
}
func tan(value: Angle) -> Double {
	return tan(value.radians)
}
func *(op1: Int, op2: Angle) -> Angle {
	return Angle(degrees: (Double(op1) * op2.degrees))
}
func +(op1: Angle, op2: Angle) -> Angle {
	return Angle(degrees: op1.degrees + op2.degrees)
}
func -(op1: Angle, op2: Angle) -> Angle {
	return Angle(degrees: op1.degrees - op2.degrees)
}
