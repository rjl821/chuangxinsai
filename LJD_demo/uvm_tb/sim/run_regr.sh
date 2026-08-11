#!/usr/bin/env bash
set -euo pipefail

testlist=${1:-dut_testlist.f}
result=${RESULT:-out/regr_result.log}
seed_base=${SEED_BASE:-1}

mkdir -p out
{
  echo "========================================="
  echo "Regression started at $(date)"
  echo "Testlist: ${testlist}"
  echo "========================================="
} | tee "${result}"

pass=0
fail=0
idx=0

while IFS= read -r testname; do
  testname=${testname%%#*}
  testname=$(echo "${testname}" | awk '{$1=$1; print}')
  [[ -z "${testname}" ]] && continue

  seed=$((seed_base + idx))
  log="out/sim/${testname}_${seed}.log"

  echo "" | tee -a "${result}"
  echo ">>> Running ${testname} seed=${seed}" | tee -a "${result}"
  if make run TEST_NAME="${testname}" SEED="${seed}"; then
    if grep -q "TEST_REPORT :: PASSED" "${log}"; then
      echo "    RESULT: PASS" | tee -a "${result}"
      pass=$((pass + 1))
    else
      echo "    RESULT: FAIL, pass signature not found" | tee -a "${result}"
      fail=$((fail + 1))
    fi
  else
    echo "    RESULT: FAIL, simulator returned non-zero" | tee -a "${result}"
    fail=$((fail + 1))
  fi
  idx=$((idx + 1))
done < "${testlist}"

{
  echo ""
  echo "========================================="
  echo "Regression finished at $(date)"
  echo "PASS: ${pass}  FAIL: ${fail}  TOTAL: $((pass + fail))"
  echo "========================================="
} | tee -a "${result}"

[[ "${fail}" -eq 0 ]]
