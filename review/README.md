# Independent review and partial Lean verification

Reviewed 2026-10-07 against commit `adc7f1241` (initial commit).

## Repository at a glance

- **722 manuscripts in 372 result families**, which the README says were produced by an unreleased internal
  OpenAI model (~4,000 problems posed, ~3 h ChatGPT Pro compute each). The README warns that
  "some of the unformalized results could have issues." The zeta zero-free-region work and Hodge for CM
  abelian varieties were produced outside the standard procedure, and the 11/12 write-up was edited by humans.
- **Lean library:** ~122k `.lean` files (~11.5M lines), Lean `v4.34.1`, Mathlib plus ~25 external projects
  (some with compatibility patches in `lean/patches/`).
- **235 of 372 families** link to a Lean scope note (`lean/docs/NNN.md`). There are **405 comparator
  challenges** (`lean/ComparatorChallenges/*.lean|json`).
- A scan of `lean/OAI/` found **no `sorry`** and **no `axiom` declarations**. The only `sorry`s are in the
  challenge stubs, which is intended.

## Most significant claims

Each family below is marked **Lean-backed** (a comparator challenge exists) or **paper-only**.

| Family | Claim | Status |
|---|---|---|
| 003 | Quasi-Riemann hypothesis: ζ and all Dirichlet L-functions are zero-free for Re s > 7/8 (statement uses Mathlib's `riemannZeta`) | Lean-backed (not run here) |
| 102 | Unique Games Conjecture as explicit 3SAT reductions; optimal Max-Cut and 2−ε Vertex Cover hardness | Lean-backed |
| 107 | Matrix multiplication exponent ω ≤ 9/4 | Lean-backed |
| 017 | Irrationality exponent of π is 2 | Lean-backed |
| 287 | Free group factors are isomorphic | Lean-backed |
| 288 | Kadison's similarity problem | Lean-backed |
| 248 | Thompson's group F is nonamenable | Lean-backed |
| 246, 143, 156, 158, 173, 196/197 | Cannon's conjecture; uniform Hilbert-16th limit-cycle bounds; Borsuk fails in dimension 9; the plane is not 5-colourable; Seymour's second neighbourhood; Kaplansky counterexamples | Lean-backed |
| 002, 004, 103, 074, 030, 304, 309, 375, 001 | BSD at low Selmer corank; Hilbert's 10th over ℚ; L = RL = BPL; Kakeya in dimensions 3 and 4; modularity over imaginary quadratic fields; Hilbert–Smith; Kervaire invariant at p = 3; De Giorgi in dimension 8; Milne's rationality conjecture | **Paper-only** |

Caveats:
- A Lean proof certifies only the *formal statement*. The scope notes often narrow the paper's claim; for
  example, 003 omits the paper's applications and 017 omits the Flint–Hills consequence.
- Formal models of computation (polynomial time, arithmetic circuits) need expert review of their definitions.
- No independent peer review was found.

## Lean checks run

Each challenge was checked with [comparator](https://github.com/leanprover/comparator). It confirms that the
solution proves exactly the challenge statement, uses only `propext`, `Quot.sound` and `Classical.choice`,
and is accepted by the Lean kernel.

| Family | Challenge | Statement | Result |
|---|---|---|---|
| 206 | `FiniteCongruenceGraph` | A finite lattice is the congruence lattice of a finite algebra ⇔ it has a finite coloured-graph witness | ✅ pass |
| 173 | `SeymourSecondNeighborhood` | Every finite oriented graph has a vertex with \|N⁺⁺(v)\| ≥ \|N⁺(v)\| | ✅ pass |
| 049 | `AbhyankarSathaye` | For n ≥ 4 there is F ∈ ℂ[x₁..xₙ] with ℂ[x]/(F) ≅ ℂ[n−1 vars] but F not a coordinate | ✅ pass |
| 049 | `CommutingDerivations` | Companion locally nilpotent commuting derivations for that counterexample | ✅ pass |
| 175 | `TalagrandExpectationThreshold` | q_f(F) ≤ 25·512⁴·q(F) for nontrivial increasing families | ✅ pass |
| 127 | `GotsmanLinial` | Degree-≤d PTFs on {±1}ⁿ have average sensitivity ≤ 8d√n | ✅ pass |

Full output is in [`comparator-logs/`](comparator-logs/). Each log ends with
`Lean default kernel accepts the solution` / `Your solution is okay!`.

These six were chosen because their dependency closures use selective Mathlib imports. Nearly every other
challenge imports all of `Mathlib`, and the quasi-RH proof alone pulls in 2,924 project files.

### Environment and limitations

- The network policy blocked the Mathlib cache hosts (`mathlib4.lean-lang.org`,
  `lakecache.blob.core.windows.net`) and `release.lean-lang.org`. The Lean 4.34.1 toolchain was fetched from
  GitHub releases, and the required Mathlib modules were compiled from source: ~1 h on 4 cores, 3,321 jobs.
- comparator was built at commit `9093852~1` and lean4export at tag `v4.34.0`, both with toolchain overridden
  to `v4.34.1`. landrun was built from `main`.
- Solutions were compiled with `lake build` **before** comparator ran, so comparator's sandboxing guarantee
  against an adversarial solution does not apply. The check confirms statement match, axioms and kernel
  acceptance, assuming the repository's build is trusted.
- Only the default Lean kernel was used (`enable_nanoda: false` in these configs); comparator ran as root.

## Reproducing

See [`run_checks.sh`](run_checks.sh).
