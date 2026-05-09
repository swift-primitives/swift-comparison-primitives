#if swift(<6.4)
    // Comparison.Protocol+Swift.PartialRange.swift
    // Conditional conformances for partial range types.

    extension PartialRangeFrom: Comparison.`Protocol` where Bound: Comparison.`Protocol` & Copyable {
        /// Returns whether the left-hand side is less than the right-hand side.
        ///
        /// - Parameters:
        ///   - lhs: The left-hand side value.
        ///   - rhs: The right-hand side value.
        /// - Returns: `true` if `lhs` is ordered before `rhs`.
        @inlinable
        @_disfavoredOverload
        public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
            lhs.lowerBound < rhs.lowerBound
        }
    }

    extension PartialRangeThrough: Comparison.`Protocol` where Bound: Comparison.`Protocol` & Copyable {
        /// Returns whether the left-hand side is less than the right-hand side.
        ///
        /// - Parameters:
        ///   - lhs: The left-hand side value.
        ///   - rhs: The right-hand side value.
        /// - Returns: `true` if `lhs` is ordered before `rhs`.
        @inlinable
        @_disfavoredOverload
        public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
            lhs.upperBound < rhs.upperBound
        }
    }

    extension PartialRangeUpTo: Comparison.`Protocol` where Bound: Comparison.`Protocol` & Copyable {
        /// Returns whether the left-hand side is less than the right-hand side.
        ///
        /// - Parameters:
        ///   - lhs: The left-hand side value.
        ///   - rhs: The right-hand side value.
        /// - Returns: `true` if `lhs` is ordered before `rhs`.
        @inlinable
        @_disfavoredOverload
        public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
            lhs.upperBound < rhs.upperBound
        }
    }

#endif
