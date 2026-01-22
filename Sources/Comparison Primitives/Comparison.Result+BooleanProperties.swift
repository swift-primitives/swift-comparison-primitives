// Comparison.Result+BooleanProperties.swift
// Boolean query properties for comparison results.

extension Comparison.Result {
    /// Whether the comparison is `.less`.
    @inlinable
    public var isLess: Bool { self == .less }

    /// Whether the comparison is `.equal`.
    @inlinable
    public var isEqual: Bool { self == .equal }

    /// Whether the comparison is `.greater`.
    @inlinable
    public var isGreater: Bool { self == .greater }

    /// Whether the comparison is `.less` or `.equal`.
    @inlinable
    public var isLessOrEqual: Bool { self != .greater }

    /// Whether the comparison is `.greater` or `.equal`.
    @inlinable
    public var isGreaterOrEqual: Bool { self != .less }
}
