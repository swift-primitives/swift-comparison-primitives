// Comparison.Protocol.swift
// A Comparable fork with ~Copyable support.
//
// SE-0499 (Implemented Swift 6.4) extends Swift.Comparable to natively support
// ~Copyable conformers via borrowing parameters. Under Swift 6.4+, Comparison.Protocol
// is a typealias to Swift.Comparable; under Swift <6.4, it remains the fork.
// See: swift-institute/Research/se-0499-implications-for-equation-hash-comparison-primitives.md

public import Equation_Primitives

#if swift(>=6.4)

    extension Comparison {
        /// A type that defines a total ordering, supporting both `Copyable` and `~Copyable` types.
        ///
        /// Under Swift 6.4+ this is a namespace alias for `Swift.Comparable`, which
        /// natively supports `~Copyable` conformers per SE-0499. The dedicated fork
        /// is only present under Swift <6.4.
        public typealias `Protocol` = Swift.Comparable
    }

#else

    extension Comparison {
        /// A protocol for types that define a total ordering, supporting both
        /// `Copyable` and `~Copyable` types.
        ///
        /// This protocol mirrors `Swift.Comparable` but uses `borrowing` parameters
        /// to enable comparison of move-only types without consuming them.
        ///
        /// ## Conforming to Protocol
        ///
        /// Types conforming to `Comparison.Protocol` must implement `<` and `==`
        /// (via `Equation.Protocol`):
        ///
        /// ```swift
        /// struct Token: ~Copyable {
        ///     let id: Int
        /// }
        ///
        /// extension Token: Comparison.Protocol {
        ///     static func < (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
        ///         lhs.id < rhs.id
        ///     }
        ///
        ///     static func == (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
        ///         lhs.id == rhs.id
        ///     }
        /// }
        /// ```
        ///
        /// ## Semantic Requirements
        ///
        /// Conforming types must satisfy trichotomy: for any two values `a` and `b`,
        /// exactly one of `a < b`, `a == b`, or `a > b` must be true.
        ///
        /// ## Relationship to Equation.Protocol
        ///
        /// `Comparison.Protocol` refines `Equation.Protocol`, inheriting the equality
        /// requirement. This matches Swift stdlib's `Comparable: Equatable` pattern
        /// and enforces the semantic invariant that ordered types support equality.
        public protocol `Protocol`: Equation.`Protocol`, ~Copyable, ~Escapable {
            /// Returns whether the left-hand side is less than the right-hand side.
            ///
            /// - Parameters:
            ///   - lhs: The left-hand side value.
            ///   - rhs: The right-hand side value.
            /// - Returns: `true` if `lhs` is ordered before `rhs`.
            static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool
        }
    }

    // MARK: - Default Implementations

    extension Comparison.`Protocol` where Self: ~Copyable & ~Escapable {
        /// Default implementation: `lhs <= rhs` iff `!(rhs < lhs)`.
        ///
        /// - Note: Uses `@_disfavoredOverload` to prefer `Swift.Comparable` operators
        ///   when the type conforms to both protocols.
        @inlinable
        @_disfavoredOverload
        public static func <= (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
            !(rhs < lhs)
        }

        /// Default implementation: `lhs > rhs` iff `rhs < lhs`.
        ///
        /// - Note: Uses `@_disfavoredOverload` to prefer `Swift.Comparable` operators
        ///   when the type conforms to both protocols.
        @inlinable
        @_disfavoredOverload
        public static func > (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
            rhs < lhs
        }

        /// Default implementation: `lhs >= rhs` iff `!(lhs < rhs)`.
        ///
        /// - Note: Uses `@_disfavoredOverload` to prefer `Swift.Comparable` operators
        ///   when the type conforms to both protocols.
        @inlinable
        @_disfavoredOverload
        public static func >= (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
            !(lhs < rhs)
        }
    }

#endif
