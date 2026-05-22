// exports.swift
// Re-export Comparison Protocol Primitives (transitively re-exports
// Comparison_Namespace) + Property so consumers importing
// Comparison_Property_Primitives see Comparison + Comparison.Protocol +
// Property + the .compare/.clamp fluent accessors via a single import.

@_exported public import Comparison_Protocol_Primitives
@_exported public import Property_Primitives
