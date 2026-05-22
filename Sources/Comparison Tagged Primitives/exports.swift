// exports.swift
// Re-export Comparison Protocol Primitives (transitively re-exports
// Comparison_Primitive) + Tagged so consumers importing
// Comparison_Tagged_Primitives see Comparison + Comparison.Protocol + Tagged
// in scope via a single import.

@_exported public import Comparison_Protocol_Primitives
@_exported public import Tagged_Primitives
