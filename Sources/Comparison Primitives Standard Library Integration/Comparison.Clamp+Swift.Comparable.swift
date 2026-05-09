// This source file is part of the Swift Institute open source project
//
// Copyright (c) 2025 Swift Institute and the Swift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.md for license information
//
// SPDX-License-Identifier: Apache-2.0

public import Property_Primitives

// MARK: - Property.Inout Extension for Swift.Comparable

/// Property.Inout extensions for clamping operations on `Swift.Comparable` types.
///
/// This extension provides the same fluent API as `Comparison.Protocol` but for
/// standard library types that conform to `Swift.Comparable`.
///
/// Note: Methods are marked `@_disfavoredOverload` so that types conforming to
/// both `Comparison.Protocol` and `Swift.Comparable` (like `Int`) use the
/// `Comparison.Protocol` extension.
extension Property.Inout where Base: Swift.Comparable, Tag == Comparison.Clamp {

    /// Clamps this value between lower and upper bounds.
    ///
    /// ```swift
    /// var value = 15.0
    /// value.clamp.between(0.0, and: 10.0)  // 10.0
    /// ```
    ///
    /// - Parameters:
    ///   - lower: The minimum allowed value.
    ///   - upper: The maximum allowed value.
    /// - Returns: The clamped value.
    @_disfavoredOverload
    @inlinable
    public func between(_ lower: Base, and upper: Base) -> Base {
        let value = base.value
        if value < lower {
            return lower
        } else if value > upper {
            return upper
        } else {
            return value
        }
    }

    /// Clamps this value to be at least the minimum.
    ///
    /// ```swift
    /// var value = 5.0
    /// value.clamp.above(10.0)  // 10.0
    /// ```
    ///
    /// - Parameter minimum: The minimum allowed value.
    /// - Returns: The clamped value.
    @_disfavoredOverload
    @inlinable
    public func above(_ minimum: Base) -> Base {
        let value = base.value
        return value < minimum ? minimum : value
    }

    /// Clamps this value to be at most the maximum.
    ///
    /// ```swift
    /// var value = 15.0
    /// value.clamp.below(10.0)  // 10.0
    /// ```
    ///
    /// - Parameter maximum: The maximum allowed value.
    /// - Returns: The clamped value.
    @_disfavoredOverload
    @inlinable
    public func below(_ maximum: Base) -> Base {
        let value = base.value
        return value > maximum ? maximum : value
    }
}

// MARK: - .clamp Property for Swift.Comparable

/// Provides the `.clamp` property to all `Swift.Comparable` types.
///
/// This extension enables fluent clamping APIs for standard library types
/// like `String`, `Double`, `Float`, and `Character`.
///
/// ```swift
/// var temperature = 105.0
/// temperature.clamp.between(0.0, and: 100.0)  // 100.0
/// ```
///
/// Note: Marked `@_disfavoredOverload` so types that also conform to
/// `Comparison.Protocol` (like `Int`) use the `Comparison.Protocol` extension.
extension Swift.Comparable where Self: Copyable {
    /// Access clamping operations.
    ///
    /// Returns a `Property.Inout` that provides clamping methods like
    /// `.between(lower, and: upper)`, `.above(minimum)`, `.below(maximum)`.
    @_disfavoredOverload
    public var clamp: Property<Comparison.Clamp, Self>.Inout {
        mutating _read {
            yield Property<Comparison.Clamp, Self>.Inout(&self)
        }
    }
}
