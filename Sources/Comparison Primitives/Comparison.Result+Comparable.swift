// Comparison.Result+Comparable.swift
// Construction from Comparable types.

extension Comparison.Result {
    /// Creates a comparison result from two comparable values.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side value.
    ///   - rhs: The right-hand side value.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result = Comparison.Result(5, 10)
    /// print(result)  // less
    ///
    /// let equal = Comparison.Result("hello", "hello")
    /// print(equal)   // equal
    /// ```
    @inlinable
    public init<T: Comparison.`Protocol`>(_ lhs: T, _ rhs: T) {
        if lhs < rhs {
            self = .less
        } else if lhs > rhs {
            self = .greater
        } else {
            self = .equal
        }
    }
}
