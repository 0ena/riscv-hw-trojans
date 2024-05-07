## The CVA6 commit we use for the IRTs implementation is: 9896c4052dcae483cfbd8b554aba85c1814a1b7b

## Clone the CVA6 repo and switch to the specific commit.
git clone https://github.com/openhwgroup/cva6.git
cd cva6
git checkout 9896c4052dcae483cfbd8b554aba85c1814a1b7b
git submodule update --init --recursive
cd ../

## DIFF
echo "*************** RTL modifications for IRT integration ***************" >> DIFFs.txt
echo "" >> DIFFs.txt

echo "*************** mmu ***************" >> DIFFs.txt
echo "" >> DIFFs.txt
diff ./irt_rtl/mmu.sv ./cva6/core/mmu_sv39/mmu.sv >> DIFFs.txt
cp ./irt_rtl/mmu.sv ./cva6/core/mmu_sv39/
echo "" >> DIFFs.txt

echo "*************** ariane_regfile_ff ***************" >> DIFFs.txt
echo "" >> DIFFs.txt
diff ./irt_rtl/ariane_regfile_ff_mod.sv ./cva6/core/ariane_regfile_ff.sv >> DIFFs.txt
cp ./irt_rtl/ariane_regfile_ff_mod.sv ./cva6/core/
echo "" >> DIFFs.txt

echo "" >> DIFFs.txt
echo "*************** Manual RTL port adjustments ***************" >> DIFFs.txt
echo "" >> DIFFs.txt

echo "*************** cva6 ***************" >> DIFFs.txt
echo "" >> DIFFs.txt
diff ./irt_rtl/cva6.sv ./cva6/core/cva6.sv >> DIFFs.txt
cp ./irt_rtl/cva6.sv ./cva6/core/
echo "" >> DIFFs.txt

echo "*************** ALU ***************" >> DIFFs.txt
echo "" >> DIFFs.txt
diff ./irt_rtl/alu.sv ./cva6/core/alu.sv >> DIFFs.txt
cp ./irt_rtl/alu.sv ./cva6/core/
echo "" >> DIFFs.txt

echo "*************** ex_stage ***************" >> DIFFs.txt
echo "" >> DIFFs.txt
diff ./irt_rtl/ex_stage.sv ./cva6/core/ex_stage.sv  >> DIFFs.txt
cp ./irt_rtl/ex_stage.sv ./cva6/core/
echo "" >> DIFFs.txt

echo "*************** issue_read_operands ***************" >> DIFFs.txt
echo "" >> DIFFs.txt
diff ./irt_rtl/issue_read_operands.sv ./cva6/core/issue_read_operands.sv >> DIFFs.txt
cp ./irt_rtl/issue_read_operands.sv ./cva6/core/
echo "" >> DIFFs.txt

echo "*************** issue_stage ***************" >> DIFFs.txt
echo "" >> DIFFs.txt
diff ./irt_rtl/issue_stage.sv ./cva6/core/issue_stage.sv >> DIFFs.txt
cp ./irt_rtl/issue_stage.sv ./cva6/core/
echo "" >> DIFFs.txt

echo "*************** load_store_unit ***************" >> DIFFs.txt
echo "" >> DIFFs.txt
diff ./irt_rtl/load_store_unit.sv ./cva6/core/load_store_unit.sv >> DIFFs.txt
cp ./irt_rtl/load_store_unit.sv ./cva6/core/
echo "" >> DIFFs.txt

## Add trojan GPR file to path.
## This is necessary, as original "ariane_regfile_ff.sv" is used for the floating point registers too.
echo "" >> cva6/core/Flist.cva6
echo "// TRJ_IRT" >> cva6/core/Flist.cva6
echo "\${CVA6_REPO_DIR}/core/ariane_regfile_ff_mod.sv" >> cva6/core/Flist.cva6

## Add trojan files to path.
mkdir ./cva6/core/trj
cp ./irt_rtl/trj_*.sv ./cva6/core/trj
echo "" >> cva6/core/Flist.cva6
echo "\${CVA6_REPO_DIR}/core/trj/trj_aotrig.sv" >> cva6/core/Flist.cva6
echo "\${CVA6_REPO_DIR}/core/trj/trj_sw_pay.sv" >> cva6/core/Flist.cva6
echo "\${CVA6_REPO_DIR}/core/trj/trj_sw_trig.sv" >> cva6/core/Flist.cva6

## Create definition for the respective generation of the trojan
echo "" >> cva6/corev_apu/fpga/src/genesysii.svh
echo "// TRJ_IRT" >> cva6/corev_apu/fpga/src/genesysii.svh
if [[ "$1" == "irt1" ]]
then
  echo "\`define MOD_TRJ_irt1" >> cva6/corev_apu/fpga/src/genesysii.svh
elif [[ "$1" == "irt2" ]]
then
  echo "\`define MOD_TRJ_irt2" >> cva6/corev_apu/fpga/src/genesysii.svh
fi

cd ./cva6
make fpga  > SynPnR.log 2>&1
