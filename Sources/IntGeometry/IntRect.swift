//
//  IntRect.swift
//  IntGeometry
//
//  Created by Max-Joseph on 15.08.22.
//

import Foundation


/// A structure that contains the location and dimensions of a rectangle.
public struct IntRect: Equatable, Hashable, Codable {
	/// A point that specifies the coordinates of the rectangle’s origin.
	public var origin: IntPoint
	/// A size that specifies the height and width of the rectangle.
	public var size: IntSize
	/// Creates a rectangle with the specified origin and size.
	public init(origin: IntPoint, size: IntSize) {
		self.origin = origin
		self.size = size
	}
}

public extension IntRect {
	/// The rectangle whose origin and size are both zero.
	static let zero = Self(origin: .zero, size: .zero)
	
	/// Creates a rectangle with coordinates and dimensions specified as integer values.
	init(x: Int, y: Int, width: Int, height: Int) {
		self.origin = IntPoint(x: x, y: y)
		self.size = IntSize(width: width, height: height)
	}
	
	/// Creates a rectangle with the two specified opposite corners.
	init(point1: IntPoint, point2: IntPoint) {
		let minX = Swift.min(point1.x, point2.x)
		let minY = Swift.min(point1.y, point2.y)
		let maxX = Swift.max(point1.x, point2.x)
		let maxY = Swift.max(point1.y, point2.y)
		self.origin = IntPoint(x: minX, y: minY)
		self.size = IntSize(width: maxX-minX, height: maxY-minY)
	}
}

public extension IntRect {
	/// Returns the smallest value for the x-coordinate of the rectangle.
	var minX: Int {
		origin.x
	}
	/// Returns the smallest value for the y-coordinate of the rectangle.
	var minY: Int {
		origin.y
	}
	/// Returns a point representing the corner of the rectangle with the smallest value for the x and y-coordinate.
	var minPoint: IntPoint {
		origin
	}
	/// Returns the largest value for the x-coordinate of the rectangle.
	var maxX: Int {
		origin.x + size.width
	}
	/// Returns the largest value for the y-coordinate of the rectangle.
	var maxY: Int {
		origin.y + size.height
	}
	/// Returns a point representing the corner of the rectangle with the largest value for the x and y-coordinate.
	var maxPoint: IntPoint {
		IntPoint(x: maxX, y: maxY)
	}
	
	/// Returns the width of the rectangle.
	var width: Int {
		size.width
	}
	/// Returns the height of the rectangle.
	var height: Int {
		size.height
	}
	/// Returns whether the rectangle has zero width or height
	var isEmpty: Bool {
		size.isEmpty
	}
}

public extension IntRect {
	/// Returns a rectangle with an origin that is offset from that of the source rectangle.
	/// - Parameters:
	///   - dx: The offset value for the x-coordinate.
	///   - dy: The offset value for the y-coordinate.
	/// - Returns: A rectangle that is the same size as the source, but with its origin offset by `dx` units along the x-axis and `dy` units along the y-axis with respect to the source.
	func offsetBy(dx: Int, dy: Int) -> IntRect {
		IntRect(origin: origin.offsetBy(dx: dx, dy: dy), size: size)
	}
	/// Returns a rectangle that is smaller or larger than the source rectangle, with the same center point.
	/// - Parameters:
	///   - dx: The x-coordinate value to use for adjusting the source rectangle.
	///         To create an inset rectangle, specify a positive value.
	///         To create a larger, encompassing rectangle, specify a negative value.
	///   - dy: The y-coordinate value to use for adjusting the source rectangle.
	///         To create an inset rectangle, specify a positive value.
	///         To create a larger, encompassing rectangle, specify a negative value.
	/// - Returns: A rectangle. The origin value is offset in the x-axis by the distance specified by the `dx` parameter
	///            and in the y-axis by the distance specified by the `dy` parameter, and its size adjusted by `(2*dx,2*dy)`,
	///            relative to the source rectangle.
	///            If `dx` and `dy` are positive values, then the rectangle’s size is decreased.
	///            If `dx` and `dy` are negative values, the rectangle’s size is increased.
	///            If the resulting rectangle would have a negative height or width, `nil` is returned.
	func insetBy(dx: Int, dy: Int) -> IntRect? {
		let width = size.width-dx*2
		let height = size.height-dy*2
		if width < 0 || height < 0 { return nil }
		return IntRect(origin: IntPoint(x: origin.x-dx, y: origin.y-dy), size: IntSize(width: width, height: height))
	}
	
	/// Returns the smallest rectangle that contains the two source rectangles.
	/// - Parameter r2: Another rectangle to be combined with this rectangle.
	/// - Returns: The smallest rectangle that completely contains both of the source rectangles.
	func union(_ r2: IntRect) -> IntRect {
		let minX = Swift.min(self.minX, r2.minX)
		let minY = Swift.min(self.minY, r2.minY)
		let maxX = Swift.max(self.maxX, r2.maxX)
		let maxY = Swift.max(self.maxY, r2.maxY)
		return IntRect(origin: IntPoint(x: minX, y: minY), size: IntSize(width: maxX-minX, height: maxY-minY))
	}
	/// Returns the intersection of the two rectangles.
	/// 
	/// If the two rectangles merely touch along an edge or a corner, the intersection will be a line or a point which is represented by a rectangle with zero width or/and height.
	/// Similarly, if one or both of the rectangles themselves are lines or points, the result may be a line or point as well if they intersect.
	/// To check for true two-dimensional intersection, make sure the returned rectangle is not empty with ``isEmpty`` which is equivalent to using ``intersects(_:)``.
	/// 
	/// - Parameter r2: Another rectangle to intersect with this rectangle.
	/// - Returns: A rectangle that represents the intersection of the source rectangle and the specified rectangle. If the two rectangles do not intersect or touch (see discussion), returns `nil`.
	func intersection(_ r2: IntRect) -> IntRect? {
		let minX = Swift.max(self.minX, r2.minX)
		let minY = Swift.max(self.minY, r2.minY)
		let maxX = Swift.min(self.maxX, r2.maxX)
		let maxY = Swift.min(self.maxY, r2.maxY)
		let width = maxX-minX
		let height = maxY-minY
		if width < 0 || height < 0 { return nil }
		return IntRect(origin: IntPoint(x: minX, y: minY), size: IntSize(width: width, height: height))
	}
	
	/// Returns whether the rectangle contains a specified point.
	/// 
	/// A point is considered inside the rectangle if its coordinates lie inside the rectangle or on the minimum X or minimum Y edge.
	/// 
	/// - Parameter point: The point to examine.
	/// - Returns: `true` if the rectangle is not empty and the point is located within the rectangle; otherwise, `false`.
	func contains(_ point: IntPoint) -> Bool {
		minX <= point.x && minY <= point.y && point.x < maxX && point.y < maxY
	}
	/// Returns whether the rectangle contains another rectangle.
	/// 
	/// The source rectangle contains the other if the union of the two rectangles is equal to the source rectangle.
	/// 
	/// - Parameter rect2: The rectangle to test for containment within this rectangle.
	/// - Returns: `true` if the specified rectangle is completely contained in the source rectangle; otherwise, `false`.
	func contains(_ rect2: IntRect) -> Bool {
		union(rect2) == self
	}
	/// Returns whether the two rectangles intersect.
	/// 
	/// The source rectangle intersects the other if the intersection of the two rectangles is not an empty rectangle or `nil`.
	/// 
	/// - Parameter rect2: The rectangle to test for intersection with this rectangle.
	/// - Returns: `true` if the source rectangle and the specified rectangle intersect; otherwise, `false`.
	func intersects(_ rect2: IntRect) -> Bool {
		!(intersection(rect2)?.isEmpty ?? true)
	}
}

extension IntRect: RandomAccessCollection {
	public typealias Element = IntPoint
	public typealias Index = Int
	
	public var startIndex: Int {
		0
	}
	public var endIndex: Int {
		width * height
	}
	
	public subscript(index: Int) -> IntPoint {
		get {
			precondition(startIndex <= index && index < endIndex, "Index out of range")
			let (j, i) = index.quotientAndRemainder(dividingBy: width)
			return IntPoint(x: origin.x + i, y: origin.y + j)
		}
	}	
}

public extension IntRect {
	struct Iterator: IteratorProtocol {
		public typealias Element = IntRect.Element
		
		private let rangeX: Range<Int>
		private let rangeY: Range<Int>
		private var x: Int
		private var y: Int
		
		init(_ rect: IntRect) {
			self.rangeX = (rect.minX..<rect.maxX)
			self.rangeY = (rect.minY..<rect.maxY)
			self.x = rangeX.lowerBound
			self.y = rangeY.lowerBound
		}
		
		public mutating func next() -> Element? {
			if x >= rangeX.upperBound {
				x = rangeX.lowerBound
				y += 1
			}
			guard x < rangeX.upperBound, y < rangeY.upperBound else { return nil }
			let point = IntPoint(x: x, y: y)
			x += 1
			return point
		}
	}
	
	func makeIterator() -> Iterator {
		Iterator(self)
	}
}
