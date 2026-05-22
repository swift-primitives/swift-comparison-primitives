// exports.swift
// Umbrella re-export of the full Comparison surface: Namespace + Protocol
// + Tagged + SLI. Per [MOD-005] this target's sole content is
// `@_exported public import` re-exports of the sub-namespace targets.
// Consumers importing Comparison_Primitives get the union plus
// Equation_Primitives (preserved as a convenience re-export from the
// pre-migration shape).
//
// Property surface (Property.Inout extensions + Swift.Comparable bridge)
// extracted to swift-comparison-property-primitives; consumers needing
// `.compare` / `.clamp` accessors depend on that sibling directly.

@_exported public import Comparison_Primitive
@_exported public import Comparison_Protocol_Primitives
@_exported public import Comparison_Tagged_Primitives
@_exported public import Comparison_Primitives_Standard_Library_Integration
@_exported public import Equation_Primitives
