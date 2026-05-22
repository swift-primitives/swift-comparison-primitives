// Comparison+Chaining.swift
// Lexicographic chaining operations for comparison results.

extension Comparison {
    /// Returns self if not equal, otherwise returns other.
    ///
    /// This operation implements the monoid structure of comparison results,
    /// enabling lexicographic comparison composition.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Compare persons by name, then age, then id
    /// Comparison(x.name, y.name)
    ///     .then(Comparison(x.age, y.age))
    ///     .then(Comparison(x.id, y.id))
    /// ```
    @inlinable
    public func then(_ other: Comparison) -> Comparison {
        switch self {
        case .equal: return other
        case .less, .greater: return self
        }
    }

    /// Returns self if not equal, otherwise evaluates and returns the closure result.
    ///
    /// Lazy variant that avoids computing subsequent comparisons when
    /// the result is already determined.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Expensive comparison only evaluated if names are equal
    /// Comparison(x.name, y.name)
    ///     .then(with: { Comparison(expensiveCompute(x), expensiveCompute(y)) })
    /// ```
    @inlinable
    public func then(with other: () -> Comparison) -> Comparison {
        switch self {
        case .equal: return other()
        case .less, .greater: return self
        }
    }
}
