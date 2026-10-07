#!/usr/bin/env bash
# Reproduce the comparator checks recorded in review/README.md.
# Requires: elan with leanprover/lean4:v4.34.1, and comparator, lean4export (v4.34-compatible)
# and landrun on PATH. Run from the repository root.
set -euo pipefail

CHALLENGES=(
  FiniteCongruenceGraph
  SeymourSecondNeighborhood
  AbhyankarSathaye
  CommutingDerivations
  TalagrandExpectationThreshold
  GotsmanLinial
)

LOG_DIR="$(pwd)/review/comparator-logs"
mkdir -p "$LOG_DIR"
cd lean

for c in "${CHALLENGES[@]}"; do
  if lake env comparator "ComparatorChallenges/$c.json" > "$LOG_DIR/$c.log" 2>&1; then
    echo "PASS $c"
  else
    echo "FAIL $c (see $LOG_DIR/$c.log)"
  fi
done
