//
//  IntPoint.swift
//  IntGeometry
//
//  Created by Max-Joseph on 15.08.22.
//

import Foundation


/// A structure that contains a point in a two-dimensional coordinate system.
public struct IntPoint: Equatable, Hashable, Codable {
	/// The x-coordinate of the point.
	public var x: Int
	/// The y-coordinate of the point.
	public var y: Int
	/// Creates a point with coordinates specified as integer values.
	public init(x: Int, y: Int) {
		self.x = x
		self.y = y
	}
}

public extension IntPoint {
	/// The point with location (0,0).
	static let zero = Self(x: 0, y: 0)
}

public extension IntPoint {
	/// Returns a point that is offset from the source point.
	func offsetBy(dx: Int, dy: Int) -> IntPoint {
		IntPoint(x: x+dx, y: y+dy)
	}
}
