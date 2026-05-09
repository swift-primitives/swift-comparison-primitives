#if swift(<6.4)
    // Comparison.Protocol+Swift.ReversedCollection.swift
    // Conditional conformance for ReversedCollection.

    extension ReversedCollection: Comparison.`Protocol` where Base.Element: Comparison.`Protocol` & Copyable {
        /// Returns whether the left-hand side is lexicographically less than the right-hand side.
        ///
        /// Compares elements in reversed order.
        ///
        /// - Parameters:
        ///   - lhs: The left-hand side value.
        ///   - rhs: The right-hand side value.
        /// - Returns: `true` if `lhs` is lexicographically ordered before `rhs`.
        @inlinable
        @_disfavoredOverload
        public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
            for (l, r) in zip(lhs, rhs) {
                if l < r { return true }
                if r < l { return false }
            }
            return lhs.count < rhs.count
        }
    }

#endif
