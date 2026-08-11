#!/usr/bin/env bash
set -euo pipefail

TESTLIST=${1:-testlist.f}
RESULT=${RESULT:-out/regr_result.log}
SEED_BASE=${SEED_BASE:-1}

mkdir -p out
{
  echo "========================================="
  echo "Regression started at $(date)"
  echo "Testlist: ${TESTLIST}"
  echo "========================================="
} | tee "${RESULT}"

pass=0
fail=0
idx=0

while IFS= read -r testname; do
  testname=${testname%%#*}
  testname=$(echo "${testname}" | awk '{$1=$1; print}')
  [[ -z "${testname}" ]] && continue

  seed=$((SEED_BASE + idx))
  log="out/sim/${testname}_${seed}.log"

  echo "" | tee -a "${RESULT}"
  echo ">>> Running ${testname} seed=${seed}" | tee -a "${RESULT}"
  if make run TEST_NAME="${testname}" SEED="${seed}"; then
    if grep -q "TEST_REPORT :: PASSED" "${log}"; then
      echo "    RESULT: PASS" | tee -a "${RESULT}"
      pass=$((pass + 1))
    else
      echo "    RESULT: FAIL, pass signature not found" | tee -a "${RESULT}"
      fail=$((fail + 1))
    fi
  else
    echo "    RESULT: FAIL, simulator returned non-zero" | tee -a "${RESULT}"
    fail=$((fail + 1))
  fi
  idx=$((idx + 1))
done < "${TESTLIST}"

{
  echo ""
  echo "========================================="
  echo "Regression finished at $(date)"
  echo "PASS: ${pass}  FAIL: ${fail}  TOTAL: $((pass + fail))"
  echo "========================================="
} | tee -a "${RESULT}"

[[ "${fail}" -eq 0 ]]
