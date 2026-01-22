// Comparison.swift
// Namespace for comparison-related types.

/// Namespace for comparison-related types.
///
/// `Comparison` provides types for representing and working with the results
/// of three-way comparisons between ordered values.
///
/// ## Core Types
///
/// - ``Result``: The outcome of a three-way comparison (less, equal, greater)
///
/// ## Example
///
/// ```swift
/// let result = Comparison.Result(5, 10)
/// print(result)              // less
/// print(result.reversed)     // greater
/// print(result.isLess)       // true
/// ```
public enum Comparison: Sendable {
    /// The protocol for types that define a total ordering.
    ///
    /// This is a typealias for `Swift.Comparable`, namespaced within
    /// the `Comparison` enum for API consistency.
    public typealias `Protocol` = Swift.Comparable
}
