// ComparisonResultTests.swift
// Tests for Comparison.Result

import Testing
@testable import Comparison_Primitives

@Suite("Comparison.Result")
struct ComparisonResultTests {

    // MARK: - Basic Cases

    @Suite("Cases")
    struct CasesTests {
        @Test("All cases exist")
        func allCasesExist() {
            let cases = Comparison.Result.allCases
            #expect(cases.count == 3)
            #expect(cases.contains(.less))
            #expect(cases.contains(.equal))
            #expect(cases.contains(.greater))
        }
    }

    // MARK: - Reversal (Involution Property)

    @Suite("Reversal")
    struct ReversalTests {
        @Test("Reversal mapping")
        func reversalMapping() {
            #expect(Comparison.Result.less.reversed == .greater)
            #expect(Comparison.Result.equal.reversed == .equal)
            #expect(Comparison.Result.greater.reversed == .less)
        }

        @Test("Reversal is involution: rev(rev(x)) = x")
        func reversalIsInvolution() {
            for value in Comparison.Result.allCases {
                #expect(value.reversed.reversed == value)
            }
        }

        @Test("Prefix ! operator")
        func prefixOperator() {
            #expect(!Comparison.Result.less == .greater)
            #expect(!Comparison.Result.equal == .equal)
            #expect(!Comparison.Result.greater == .less)
        }

        @Test("Prefix ! is equivalent to reversed")
        func prefixOperatorEquivalence() {
            for value in Comparison.Result.allCases {
                #expect(!value == value.reversed)
            }
        }
    }

    // MARK: - Chaining (Monoid Properties)

    @Suite("Chaining")
    struct ChainingTests {
        @Test("Left identity: equal.then(x) = x")
        func leftIdentity() {
            for value in Comparison.Result.allCases {
                #expect(Comparison.Result.equal.then(value) == value)
            }
        }

        @Test("Right identity: x.then(equal) = x")
        func rightIdentity() {
            for value in Comparison.Result.allCases {
                #expect(value.then(.equal) == value)
            }
        }

        @Test("Associativity: (x.then(y)).then(z) = x.then(y.then(z))")
        func associativity() {
            let cases = Comparison.Result.allCases
            for x in cases {
                for y in cases {
                    for z in cases {
                        let left = x.then(y).then(z)
                        let right = x.then(y.then(z))
                        #expect(left == right)
                    }
                }
            }
        }

        @Test("Short-circuit behavior")
        func shortCircuit() {
            #expect(Comparison.Result.less.then(.greater) == .less)
            #expect(Comparison.Result.greater.then(.less) == .greater)
            #expect(Comparison.Result.equal.then(.less) == .less)
            #expect(Comparison.Result.equal.then(.greater) == .greater)
        }

        @Test("Lazy chaining with then(with:)")
        func lazyChaining() {
            var evaluationCount = 0

            let lazyValue: () -> Comparison.Result = {
                evaluationCount += 1
                return .greater
            }

            // Should NOT evaluate when primary is decisive
            _ = Comparison.Result.less.then(with: lazyValue)
            #expect(evaluationCount == 0)

            _ = Comparison.Result.greater.then(with: lazyValue)
            #expect(evaluationCount == 0)

            // Should evaluate when primary is equal
            let result = Comparison.Result.equal.then(with: lazyValue)
            #expect(evaluationCount == 1)
            #expect(result == .greater)
        }
    }

    // MARK: - Boolean Properties

    @Suite("Boolean Properties")
    struct BooleanPropertiesTests {
        @Test("isLess")
        func isLess() {
            #expect(Comparison.Result.less.isLess == true)
            #expect(Comparison.Result.equal.isLess == false)
            #expect(Comparison.Result.greater.isLess == false)
        }

        @Test("isEqual")
        func isEqual() {
            #expect(Comparison.Result.less.isEqual == false)
            #expect(Comparison.Result.equal.isEqual == true)
            #expect(Comparison.Result.greater.isEqual == false)
        }

        @Test("isGreater")
        func isGreater() {
            #expect(Comparison.Result.less.isGreater == false)
            #expect(Comparison.Result.equal.isGreater == false)
            #expect(Comparison.Result.greater.isGreater == true)
        }

        @Test("isLessOrEqual")
        func isLessOrEqual() {
            #expect(Comparison.Result.less.isLessOrEqual == true)
            #expect(Comparison.Result.equal.isLessOrEqual == true)
            #expect(Comparison.Result.greater.isLessOrEqual == false)
        }

        @Test("isGreaterOrEqual")
        func isGreaterOrEqual() {
            #expect(Comparison.Result.less.isGreaterOrEqual == false)
            #expect(Comparison.Result.equal.isGreaterOrEqual == true)
            #expect(Comparison.Result.greater.isGreaterOrEqual == true)
        }
    }

    // MARK: - Construction from Comparable

    @Suite("Comparable Construction")
    struct ComparableConstructionTests {
        @Test("Int comparison")
        func intComparison() {
            #expect(Comparison.Result(1, 2) == .less)
            #expect(Comparison.Result(2, 2) == .equal)
            #expect(Comparison.Result(3, 2) == .greater)
        }

        @Test("String comparison")
        func stringComparison() {
            #expect(Comparison.Result("apple", "banana") == .less)
            #expect(Comparison.Result("hello", "hello") == .equal)
            #expect(Comparison.Result("zebra", "apple") == .greater)
        }

        @Test("Double comparison")
        func doubleComparison() {
            #expect(Comparison.Result(1.5, 2.5) == .less)
            #expect(Comparison.Result(2.5, 2.5) == .equal)
            #expect(Comparison.Result(3.5, 2.5) == .greater)
        }
    }

    // MARK: - Protocol Conformances

    @Suite("Protocol Conformances")
    struct ProtocolConformancesTests {
        @Test("Hashable - can be used in Set")
        func hashable() {
            let set: Set<Comparison.Result> = [.less, .equal, .greater]
            #expect(set.count == 3)
        }

        @Test("Hashable - can be used as dictionary key")
        func dictionaryKey() {
            let dict: [Comparison.Result: String] = [
                .less: "less",
                .equal: "equal",
                .greater: "greater"
            ]
            #expect(dict[.less] == "less")
            #expect(dict[.equal] == "equal")
            #expect(dict[.greater] == "greater")
        }

        @Test("Sendable - can pass to actor")
        func sendable() async {
            actor TestActor {
                var value: Comparison.Result = .equal
                func set(_ v: Comparison.Result) { value = v }
                func get() -> Comparison.Result { value }
            }

            let actor = TestActor()
            await actor.set(.less)
            let result = await actor.get()
            #expect(result == .less)
        }
    }

    // MARK: - Lexicographic Comparison Example

    @Suite("Lexicographic Comparison")
    struct LexicographicComparisonTests {
        struct Person: Equatable {
            let name: String
            let age: Int
            let id: Int
        }

        func compare(_ lhs: Person, _ rhs: Person) -> Comparison.Result {
            Comparison.Result(lhs.name, rhs.name)
                .then(Comparison.Result(lhs.age, rhs.age))
                .then(Comparison.Result(lhs.id, rhs.id))
        }

        @Test("Multi-field comparison")
        func multiFieldComparison() {
            let alice1 = Person(name: "Alice", age: 30, id: 1)
            let alice2 = Person(name: "Alice", age: 30, id: 2)
            let alice3 = Person(name: "Alice", age: 25, id: 1)
            let bob = Person(name: "Bob", age: 30, id: 1)

            // Same name, same age, different id
            #expect(compare(alice1, alice2) == .less)

            // Same name, different age
            #expect(compare(alice1, alice3) == .greater)

            // Different name
            #expect(compare(alice1, bob) == .less)

            // Same person
            #expect(compare(alice1, alice1) == .equal)
        }
    }
}
