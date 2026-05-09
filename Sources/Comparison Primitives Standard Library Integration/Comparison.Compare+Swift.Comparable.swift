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

// Property.Inout extensions for comparison operations on Swift.Comparable types.
// This extension provides the same fluent API as Comparison.Protocol but for
// standard library types that conform to Swift.Comparable.
//
// Methods are marked @_disfavoredOverload so that types conforming to both
// Comparison.Protocol and Swift.Comparable (like Int) use the
// Comparison.Protocol extension which supports `borrowing` parameters.
//
// SE-0499: Swift.Comparable no longer implies Copyable in Swift 6.4.
// Without ~Copyable, the extension gains implicit `where Base: Copyable` on 6.4,
// making it unreachable for ~Copyable types.
#if compiler(>=6.4)
    extension Property.Inout where Base: Swift.Comparable & ~Copyable, Tag == Comparison.Compare {

        /// Compares this value to another.
        ///
        /// Returns a three-way comparison result indicating the relative order.
        ///
        /// ```swift
        /// var apple = "apple"
        /// let banana = "banana"
        ///
        /// apple.compare.to(banana)  // .less
        /// ```
        ///
        /// - Parameter other: The value to compare against.
        /// - Returns: `.less`, `.equal`, or `.greater`.
        @_disfavoredOverload
        @inlinable
        public func to(_ other: borrowing Base) -> Comparison {
            Comparison(comparing: base.value, to: other)
        }

        /// Checks if this value is less than another.
        ///
        /// - Parameter other: The value to compare against.
        /// - Returns: `true` if `self < other`.
        @_disfavoredOverload
        @inlinable
        public func isLess(than other: borrowing Base) -> Bool {
            base.value < other
        }

        /// Checks if this value is greater than another.
        ///
        /// - Parameter other: The value to compare against.
        /// - Returns: `true` if `self > other`.
        @_disfavoredOverload
        @inlinable
        public func isGreater(than other: borrowing Base) -> Bool {
            base.value > other
        }

        /// Checks if this value equals another.
        ///
        /// - Parameter other: The value to compare against.
        /// - Returns: `true` if `self == other`.
        @_disfavoredOverload
        @inlinable
        public func isEqual(to other: borrowing Base) -> Bool {
            base.value == other
        }

        /// Checks if this value is less than or equal to another.
        ///
        /// - Parameter other: The value to compare against.
        /// - Returns: `true` if `self <= other`.
        @_disfavoredOverload
        @inlinable
        public func isLessOrEqual(to other: borrowing Base) -> Bool {
            base.value <= other
        }

        /// Checks if this value is greater than or equal to another.
        ///
        /// - Parameter other: The value to compare against.
        /// - Returns: `true` if `self >= other`.
        @_disfavoredOverload
        @inlinable
        public func isGreaterOrEqual(to other: borrowing Base) -> Bool {
            base.value >= other
        }
    }
#else
    extension Property.Inout where Base: Swift.Comparable, Tag == Comparison.Compare {

        /// Compares this value to another.
        ///
        /// Returns a three-way comparison result indicating the relative order.
        ///
        /// ```swift
        /// var apple = "apple"
        /// let banana = "banana"
        ///
        /// apple.compare.to(banana)  // .less
        /// ```
        ///
        /// - Parameter other: The value to compare against.
        /// - Returns: `.less`, `.equal`, or `.greater`.
        @_disfavoredOverload
        @inlinable
        public func to(_ other: Base) -> Comparison {
            Comparison(comparing: base.value, to: other)
        }

        /// Checks if this value is less than another.
        ///
        /// - Parameter other: The value to compare against.
        /// - Returns: `true` if `self < other`.
        @_disfavoredOverload
        @inlinable
        public func isLess(than other: Base) -> Bool {
            base.value < other
        }

        /// Checks if this value is greater than another.
        ///
        /// - Parameter other: The value to compare against.
        /// - Returns: `true` if `self > other`.
        @_disfavoredOverload
        @inlinable
        public func isGreater(than other: Base) -> Bool {
            base.value > other
        }

        /// Checks if this value equals another.
        ///
        /// - Parameter other: The value to compare against.
        /// - Returns: `true` if `self == other`.
        @_disfavoredOverload
        @inlinable
        public func isEqual(to other: Base) -> Bool {
            base.value == other
        }

        /// Checks if this value is less than or equal to another.
        ///
        /// - Parameter other: The value to compare against.
        /// - Returns: `true` if `self <= other`.
        @_disfavoredOverload
        @inlinable
        public func isLessOrEqual(to other: Base) -> Bool {
            base.value <= other
        }

        /// Checks if this value is greater than or equal to another.
        ///
        /// - Parameter other: The value to compare against.
        /// - Returns: `true` if `self >= other`.
        @_disfavoredOverload
        @inlinable
        public func isGreaterOrEqual(to other: Base) -> Bool {
            base.value >= other
        }
    }
#endif

// MARK: - .compare Property for Swift.Comparable

/// Provides the `.compare` property to all `Swift.Comparable` types.
///
/// This extension enables fluent comparison APIs for standard library types
/// like `String`, `Double`, `Float`, and `Character`.
///
/// ```swift
/// var name = "alice"
/// name.compare.to("bob")           // .less
/// name.compare.isLess(than: "bob") // true
/// ```
///
/// Note: Marked `@_disfavoredOverload` so types that also conform to
/// `Comparison.Protocol` (like `Int`) use the `Comparison.Protocol` extension.
extension Swift.Comparable where Self: Copyable {
    /// Access fluent comparison APIs.
    ///
    /// Returns a `Property.Inout` that provides comparison methods like
    /// `.to(other)`, `.isLess(than:)`, `.isGreater(than:)`, etc.
    @_disfavoredOverload
    public var compare: Property<Comparison.Compare, Self>.Inout {
        mutating _read {
            yield Property<Comparison.Compare, Self>.Inout(&self)
        }
    }
}
