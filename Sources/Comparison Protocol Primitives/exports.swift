// exports.swift
// Re-export the Comparison namespace + Equation so consumers importing
// Comparison_Protocol_Primitives see Comparison + Comparison.Protocol +
// Equation.Protocol in scope via a single import.

@_exported public import Comparison_Namespace
@_exported public import Equation_Primitives
