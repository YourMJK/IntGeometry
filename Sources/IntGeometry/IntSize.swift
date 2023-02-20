//
//  IntSize.swift
//  IntGeometry
//
//  Created by Max-Joseph on 15.08.22.
//

import Foundation


/// A structure that contains width and height values.
public struct IntSize: Equatable {
	/// The width of the size.
	public var width: Int {
		willSet { precondition(newValue >= 0, "Width of IntSize must be positive") }
	}
	/// The height of the size.
	public var height: Int {
		willSet { precondition(newValue >= 0, "Height of IntSize must be positive") }
	}
	
	/// Creates a size with width and height specified as integer values.
	public init(width: Int, height: Int) {
		precondition(width >= 0 && height >= 0, "Width and height of IntSize must be positive")
		self.width = width
		self.height = height
	}
}

public extension IntSize {
	/// The size whose width and height are both zero.
	static let zero = Self(width: 0, height: 0)
}

public extension IntSize {
	/// Returns whether the size has zero width or height
	var isEmpty: Bool {
		width == 0 || height == 0
	}
}
