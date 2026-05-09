#if swift(<6.4)
    // Comparison.Protocol+Swift.EmptyCollection.swift
    // Conformance for EmptyCollection.

    extension EmptyCollection: Comparison.`Protocol` where Element: Comparison.`Protocol` {
        /// Returns whether the left-hand side is less than the right-hand side.
        ///
        /// Always returns `false` since all empty collections are equal.
        ///
        /// - Parameters:
        ///   - lhs: The left-hand side value.
        ///   - rhs: The right-hand side value.
        /// - Returns: `false`.
        @inlinable
        @_disfavoredOverload
        public static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
            false
        }
    }

#endif
