// Comparison.Result+Reversal.swift
// Reversal operations for comparison results.

extension Comparison.Result {
    /// Returns the reversed comparison (less becomes greater, greater becomes less, equal unchanged).
    ///
    /// Reversal is an involution: `result.reversed.reversed == result`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = Comparison.Result(5, 10)  // .less
    /// print(result.reversed)                  // .greater
    /// print(result.reversed.reversed)         // .less
    /// ```
    @inlinable
    public var reversed: Comparison.Result {
        switch self {
        case .less: return .greater
        case .equal: return .equal
        case .greater: return .less
        }
    }

    /// Returns the reversed comparison.
    ///
    /// Equivalent to `value.reversed`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = Comparison.Result(5, 10)  // .less
    /// print(!result)                          // .greater
    /// ```
    @inlinable
    public static prefix func ! (value: Comparison.Result) -> Comparison.Result {
        value.reversed
    }
}
