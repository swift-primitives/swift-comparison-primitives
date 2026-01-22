// This source file is part of the Swift Institute open source project
//
// Copyright (c) 2025 Swift Institute and the Swift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.md for license information
//
// SPDX-License-Identifier: Apache-2.0

public import Property_Primitives

/// Property.View extensions for clamping operations on `Comparison.Protocol` conformers.
///
/// Note: Clamping requires `Copyable` because it may return a bound value.
extension Property.View
where Base: Comparison.`Protocol` & Copyable, Tag == Comparison.Clamp {

    /// Clamps this value between lower and upper bounds: `.clamp.between(lower, and: upper)`
    ///
    /// Returns the value if within the bounds, otherwise returns the
    /// nearest bound.
    ///
    /// ```swift
    /// var value = 15
    /// value.clamp.between(0, and: 10)  // 10
    ///
    /// var value2 = -5
    /// value2.clamp.between(0, and: 10) // 0
    ///
    /// var value3 = 5
    /// value3.clamp.between(0, and: 10) // 5
    /// ```
    ///
    /// - Parameters:
    ///   - lower: The minimum allowed value.
    ///   - upper: The maximum allowed value.
    /// - Returns: The clamped value.
    @inlinable
    public func between(_ lower: Base, and upper: Base) -> Base {
        let value = unsafe base.pointee
        if value < lower {
            return lower
        } else if value > upper {
            return upper
        } else {
            return value
        }
    }

    /// Clamps this value to be at least the minimum: `.clamp.above(minimum)`
    ///
    /// Returns the value if greater than or equal to minimum,
    /// otherwise returns the minimum.
    ///
    /// ```swift
    /// var value = 5
    /// value.clamp.above(10)  // 10
    ///
    /// var value2 = 15
    /// value2.clamp.above(10) // 15
    /// ```
    ///
    /// - Parameter minimum: The minimum allowed value.
    /// - Returns: The clamped value.
    @inlinable
    public func above(_ minimum: Base) -> Base {
        let value = unsafe base.pointee
        return value < minimum ? minimum : value
    }

    /// Clamps this value to be at most the maximum: `.clamp.below(maximum)`
    ///
    /// Returns the value if less than or equal to maximum,
    /// otherwise returns the maximum.
    ///
    /// ```swift
    /// var value = 15
    /// value.clamp.below(10)  // 10
    ///
    /// var value2 = 5
    /// value2.clamp.below(10) // 5
    /// ```
    ///
    /// - Parameter maximum: The maximum allowed value.
    /// - Returns: The clamped value.
    @inlinable
    public func below(_ maximum: Base) -> Base {
        let value = unsafe base.pointee
        return value > maximum ? maximum : value
    }
}
