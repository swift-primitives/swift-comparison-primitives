// exports.swift
// Re-exports Comparison Protocol Primitives for access to
// Comparison.Protocol referenced by the Swift.Comparable bridge
// extensions (Int/UInt/etc. conformances + Comparison init from
// Swift.Comparable + Collection conformances).
//
// The Comparison.Compare / Comparison.Clamp tag types and their
// Swift.Comparable bridges (`var compare` / `var clamp` on
// `Swift.Comparable`) moved to the sibling
// swift-comparison-property-primitives package alongside the
// Property.Inout extensions.

@_exported public import Comparison_Protocol_Primitives
