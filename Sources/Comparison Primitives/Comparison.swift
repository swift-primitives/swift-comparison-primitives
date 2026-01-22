// Comparison.swift
// Namespace for comparison-related types.

/// Namespace for comparison-related types.
///
/// `Comparison` provides types for representing and working with the results
/// of three-way comparisons between ordered values.
///
/// ## Core Types
///
/// - ``Protocol``: A `Comparable` fork with `~Copyable` support
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
///
/// ## Move-Only Types
///
/// Unlike `Swift.Comparable`, `Comparison.Protocol` supports `~Copyable` types:
///
/// ```swift
/// struct Token: ~Copyable, Comparison.Protocol {
///     let id: Int
///     static func < (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
///         lhs.id < rhs.id
///     }
///     static func == (lhs: borrowing Token, rhs: borrowing Token) -> Bool {
///         lhs.id == rhs.id
///     }
/// }
/// ```
public enum Comparison: Sendable {}
