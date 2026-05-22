// This source file is part of the Swift Institute open source project
//
// Copyright (c) 2025 Swift Institute and the Swift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.md for license information
//
// SPDX-License-Identifier: Apache-2.0

public import Property_Primitives

/// Property.Inout extensions for comparison operations on `Comparison.Protocol` conformers.
extension Property.Inout
where Base: Comparison.`Protocol` & ~Copyable, Tag == Comparison.Compare {

    /// Compares this value to another.
    ///
    /// Returns a three-way comparison result indicating the relative order.
    ///
    /// ```swift
    /// var a = Token(id: 5)
    /// var b = Token(id: 10)
    ///
    /// a.compare.to(b)  // .less
    /// b.compare.to(a)  // .greater
    /// a.compare.to(a)  // .equal
    /// ```
    ///
    /// - Parameter other: The value to compare against.
    /// - Returns: `.less`, `.equal`, or `.greater`.
    @inlinable
    public func to(_ other: borrowing Base) -> Comparison {
        if base.value < other {
            return .less
        } else if base.value == other {
            return .equal
        } else {
            return .greater
        }
    }

    /// Checks if this value is less than another.
    ///
    /// - Parameter other: The value to compare against.
    /// - Returns: `true` if `self < other`.
    @inlinable
    public func isLess(than other: borrowing Base) -> Bool {
        base.value < other
    }

    /// Checks if this value is greater than another.
    ///
    /// - Parameter other: The value to compare against.
    /// - Returns: `true` if `self > other`.
    @inlinable
    public func isGreater(than other: borrowing Base) -> Bool {
        base.value > other
    }

    /// Checks if this value equals another.
    ///
    /// - Parameter other: The value to compare against.
    /// - Returns: `true` if `self == other`.
    @inlinable
    public func isEqual(to other: borrowing Base) -> Bool {
        base.value == other
    }

    /// Checks if this value is less than or equal to another.
    ///
    /// - Parameter other: The value to compare against.
    /// - Returns: `true` if `self <= other`.
    @inlinable
    public func isLessOrEqual(to other: borrowing Base) -> Bool {
        base.value <= other
    }

    /// Checks if this value is greater than or equal to another.
    ///
    /// - Parameter other: The value to compare against.
    /// - Returns: `true` if `self >= other`.
    @inlinable
    public func isGreaterOrEqual(to other: borrowing Base) -> Bool {
        base.value >= other
    }
}
