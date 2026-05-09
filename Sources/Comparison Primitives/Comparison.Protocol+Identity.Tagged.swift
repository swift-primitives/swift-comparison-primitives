#if swift(<6.4)
    // Comparison.Protocol+Identity.Tagged.swift
    // Comparison.Protocol conformance for Tagged types.

    public import Tagged_Primitives

    extension Tagged: Comparison.`Protocol` where Tag: ~Copyable, Underlying: ~Copyable & Comparison.`Protocol` {
        /// Returns whether the left-hand side tagged value is less than the right-hand side.
        ///
        /// Compares the underlying values using `Comparison.Protocol` semantics,
        /// enabling ordering comparison for `~Copyable` underlying values without consuming them.
        ///
        /// - Note: Uses `@_disfavoredOverload` to prefer `Swift.Comparable` when Underlying
        ///   conforms to both. This ensures Copyable types use the standard library operator.
        @inlinable
        @_disfavoredOverload
        public static func < (lhs: borrowing Tagged, rhs: borrowing Tagged) -> Bool {
            lhs.underlying < rhs.underlying
        }
    }

#endif
