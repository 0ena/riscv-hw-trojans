#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
LOG_DIR="$REPO_ROOT/log"
DIFF_LOG="$LOG_DIR/diff.log"
RTL_DIR="$REPO_ROOT/hw/rtl"
CVA6_DIR="$REPO_ROOT/cva6"
CVA6_RTL_DIR="$CVA6_DIR/core"
CVA6_GIT_REPO="https://github.com/openhwgroup/cva6.git"
CVA6_COMMIT="26e6a8de4e5e1bf95b0044d2825aaf005a3a62cc" ## The CVA6 commit we use for the IRTs implementation

## Clone the CVA6 repo and checkout the specific commit.
if [ -d "$CVA6_DIR/.git" ]; then
  echo "CVA6 already present at $CVA6_DIR"
else
  git clone "$CVA6_GIT_REPO" "$CVA6_DIR"
fi
cd "$CVA6_DIR" && git checkout "$CVA6_COMMIT" && git submodule update --init --recursive
cd "$REPO_ROOT"

## DIFF
mkdir -p "$LOG_DIR"
: > "$DIFF_LOG"

echo "*************** RTL modifications for IRT integration ***************" >> "$DIFF_LOG"
echo "" >> "$DIFF_LOG"

echo "*************** mmu ***************" >> "$DIFF_LOG"
echo "" >> "$DIFF_LOG"
diff $RTL_DIR/cva6_mmu.sv $CVA6_RTL_DIR/cva6_mmu/cva6_mmu.sv >> "$DIFF_LOG"
cp $RTL_DIR/cva6_mmu.sv $CVA6_RTL_DIR/cva6_mmu/cva6_mmu.sv
echo "" >> "$DIFF_LOG"

echo "*************** ariane_regfile_ff ***************" >> "$DIFF_LOG"
echo "" >> "$DIFF_LOG"
diff $RTL_DIR/ariane_regfile_ff_mod.sv $CVA6_RTL_DIR/ariane_regfile_ff.sv >> "$DIFF_LOG"
cp $RTL_DIR/ariane_regfile_ff_mod.sv $CVA6_RTL_DIR/
echo "" >> "$DIFF_LOG"

echo "" >> "$DIFF_LOG"
echo "*************** Manual RTL port adjustments ***************" >> "$DIFF_LOG"
echo "" >> "$DIFF_LOG"

echo "*************** cva6 ***************" >> "$DIFF_LOG"
echo "" >> "$DIFF_LOG"
diff $RTL_DIR/cva6.sv $CVA6_RTL_DIR/cva6.sv >> "$DIFF_LOG"
cp $RTL_DIR/cva6.sv $CVA6_RTL_DIR/
echo "" >> "$DIFF_LOG"

echo "*************** ALU ***************" >> "$DIFF_LOG"
echo "" >> "$DIFF_LOG"
diff $RTL_DIR/alu.sv $CVA6_RTL_DIR/alu.sv >> "$DIFF_LOG"
cp $RTL_DIR/alu.sv $CVA6_RTL_DIR/
echo "" >> "$DIFF_LOG"

echo "*************** ex_stage ***************" >> "$DIFF_LOG"
echo "" >> "$DIFF_LOG"
diff $RTL_DIR/ex_stage.sv $CVA6_RTL_DIR/ex_stage.sv  >> "$DIFF_LOG"
cp $RTL_DIR/ex_stage.sv $CVA6_RTL_DIR/
echo "" >> "$DIFF_LOG"

echo "*************** issue_read_operands ***************" >> "$DIFF_LOG"
echo "" >> "$DIFF_LOG"
diff $RTL_DIR/issue_read_operands.sv $CVA6_RTL_DIR/issue_read_operands.sv >> "$DIFF_LOG"
cp $RTL_DIR/issue_read_operands.sv $CVA6_RTL_DIR/
echo "" >> "$DIFF_LOG"

echo "*************** issue_stage ***************" >> "$DIFF_LOG"
echo "" >> "$DIFF_LOG"
diff $RTL_DIR/issue_stage.sv $CVA6_RTL_DIR/issue_stage.sv >> "$DIFF_LOG"
cp $RTL_DIR/issue_stage.sv $CVA6_RTL_DIR/
echo "" >> "$DIFF_LOG"

echo "*************** load_store_unit ***************" >> "$DIFF_LOG"
echo "" >> "$DIFF_LOG"
diff $RTL_DIR/load_store_unit.sv $CVA6_RTL_DIR/load_store_unit.sv >> "$DIFF_LOG"
cp $RTL_DIR/load_store_unit.sv $CVA6_RTL_DIR/
echo "" >> "$DIFF_LOG"

## Add trojan GPR file to path.
## This is necessary, as original "ariane_regfile_ff.sv" is used for the floating point registers too.
echo "" >> cva6/core/Flist.cva6
echo "// TRJ_IRT" >> cva6/core/Flist.cva6
echo "\${CVA6_REPO_DIR}/core/ariane_regfile_ff_mod.sv" >> cva6/core/Flist.cva6

## Add trojan files to path.
mkdir $CVA6_RTL_DIR/irt_rtl
cp $RTL_DIR/trj_*.sv $CVA6_RTL_DIR/irt_rtl
echo "" >> $CVA6_RTL_DIR/Flist.cva6
echo "\${CVA6_REPO_DIR}/core/irt_rtl/trj_aotrig.sv" >> $CVA6_RTL_DIR/Flist.cva6
echo "\${CVA6_REPO_DIR}/core/irt_rtl/trj_pay.sv" >> $CVA6_RTL_DIR/Flist.cva6
echo "\${CVA6_REPO_DIR}/core/irt_rtl/trj_seltrig.sv" >> $CVA6_RTL_DIR/Flist.cva6

## Create definition for the respective generation of the trojan
echo "" >> $CVA6_DIR/corev_apu/fpga/src/genesysii.svh
echo "// TRJ_IRT" >> $CVA6_DIR/corev_apu/fpga/src/genesysii.svh
if [[ "$1" == "irt1" ]]
then
  echo "\`define TRJ_IRT1" >> $CVA6_DIR/corev_apu/fpga/src/genesysii.svh
elif [[ "$1" == "irt2" ]]
then
  echo "\`define TRJ_IRT2" >> $CVA6_DIR/corev_apu/fpga/src/genesysii.svh
fi

cd $CVA6_DIR
make fpga  > SynPnR.log 2>&1
