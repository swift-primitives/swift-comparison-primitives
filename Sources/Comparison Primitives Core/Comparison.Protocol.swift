// Comparison.Protocol.swift
// A Comparable fork with ~Copyable support.

public import Equation_Primitives

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
    public protocol `Protocol`: Equation.`Protocol`, ~Copyable {
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

extension Comparison.`Protocol` where Self: ~Copyable {
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
