#if swift(<6.4)
    // Comparison.Protocol+Swift.Range.swift
    // Conditional conformance for Range when Bound is Copyable.

    extension Range: Comparison.`Protocol` where Bound: Comparison.`Protocol` & Copyable {
        /// Returns whether the left-hand side range is less than the right-hand side.
        ///
        /// Compares by lower bound first, then by upper bound if lower bounds are equal.
        ///
        /// - Note: Uses `copy` to enable property access on borrowed values.
        ///
        /// - Parameters:
        ///   - lhs: The left-hand side value.
        ///   - rhs: The right-hand side value.
        /// - Returns: `true` if `lhs` is ordered before `rhs`.
        @inlinable
        @_disfavoredOverload
        public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
            let lhsCopy = copy lhs
            let rhsCopy = copy rhs
            if lhsCopy.lowerBound < rhsCopy.lowerBound { return true }
            if rhsCopy.lowerBound < lhsCopy.lowerBound { return false }
            return lhsCopy.upperBound < rhsCopy.upperBound
        }
    }

    extension ClosedRange: Comparison.`Protocol` where Bound: Comparison.`Protocol` & Copyable {
        /// Returns whether the left-hand side closed range is less than the right-hand side.
        ///
        /// Compares by lower bound first, then by upper bound if lower bounds are equal.
        ///
        /// - Note: Uses `copy` to enable property access on borrowed values.
        ///
        /// - Parameters:
        ///   - lhs: The left-hand side value.
        ///   - rhs: The right-hand side value.
        /// - Returns: `true` if `lhs` is ordered before `rhs`.
        @_disfavoredOverload
        @inlinable
        public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
            let lhsCopy = copy lhs
            let rhsCopy = copy rhs
            if lhsCopy.lowerBound < rhsCopy.lowerBound { return true }
            if rhsCopy.lowerBound < lhsCopy.lowerBound { return false }
            return lhsCopy.upperBound < rhsCopy.upperBound
        }
    }

#endif
