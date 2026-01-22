// Comparison.Result+Chaining.swift
// Lexicographic chaining operations for comparison results.

extension Comparison.Result {
    /// Returns self if not equal, otherwise returns other.
    ///
    /// This operation implements the monoid structure of comparison results,
    /// enabling lexicographic comparison composition.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Compare persons by name, then age, then id
    /// Comparison.Result(x.name, y.name)
    ///     .then(Comparison.Result(x.age, y.age))
    ///     .then(Comparison.Result(x.id, y.id))
    /// ```
    @inlinable
    public func then(_ other: Comparison.Result) -> Comparison.Result {
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
    /// Comparison.Result(x.name, y.name)
    ///     .then(with: { Comparison.Result(expensiveCompute(x), expensiveCompute(y)) })
    /// ```
    @inlinable
    public func then(with other: () -> Comparison.Result) -> Comparison.Result {
        switch self {
        case .equal: return other()
        case .less, .greater: return self
        }
    }
}
