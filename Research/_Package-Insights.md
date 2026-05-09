# swift-comparison-primitives Insights

<!--
---
title: swift-comparison-primitives Insights
version: 1.0.0
last_updated: 2026-03-31
applies_to: [swift-comparison-primitives]
normative: false
---
-->

Design decisions, implementation patterns, and lessons learned specific to this package.

## Overview

This document captures insights that emerged during development of swift-comparison-primitives.
These are not API requirements — they are recorded decisions and patterns that inform
future work on this package.

**Document type**: Non-normative (recorded decisions, not requirements).

**Consolidation source**: Reflection entries tagged with `[package: swift-comparison-primitives]`.

---

## Comparison.Clamp ~Copyable API Shape (2026-03-31)

**Date**: 2026-03-31

**Context**: `Comparison.Clamp` is currently Copyable-only by design (value-returning API). If clamp operations should be available for `~Copyable` types, a different API shape is needed: either mutating in-place (`clamp(&value, to: range)`) or indicator-returning (`clamp(value, to: range) -> ClampResult` where the caller acts on the result).

The current Copyable API is naturally protected from SE-0499 breakage because the backwards-compat implicit `Copyable` keeps the extension reachable — clamp only makes sense for types that can be copied (the result needs to be one of the bounds or the original value).

**Applies to**: Comparison.Clamp
