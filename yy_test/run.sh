IREE_OPT=/home/yufan/iree/iree-build/tools/iree-opt
IREE_CMP=/home/yufan/iree/iree-build/tools/iree-compile
### bufferize to scf
# $IREE_OPT $1 --mlir-pretty-debuginfo  \
#   --iree-hal-target-backends=llvm-cpu \
#   --iree-codegen-iree-comprehensive-bufferize \
#   --convert-linalg-to-loops \
#   --dump-pass-pipeline \
#   --mlir-print-ir-after-all \
#   --mlir-disable-threading  2>&1 | tee $2
  

# ### print region info
# $IREE_OPT $1 --mlir-pretty-debuginfo  \
#   --iree-hal-target-backends=llvm-cpu \
#   --iree-codegen-iree-comprehensive-bufferize \
#   --convert-linalg-to-loops \
#   --dump-pass-pipeline \
#   --iree-codegen-yufan-ana \
#   --mlir-disable-threading  2>&1 | tee $2


# ### compile 
# $IREE_CMP $1 \
#   --iree-hal-target-backends=llvm-cpu \
#   --output-format=vm-bytecode \
#   --iree-input-type=mhlo \
#   --mlir-print-ir-after-all \
#   --mlir-disable-threading  -o b.vmfb 2>&1 | tee $2



$IREE_OPT $1 --pass-pipeline='builtin.module(hal.executable(hal.executable.variant(iree-llvmcpu-lower-executable-target)))' 
#  --iree-llvmcpu-enable-triple-tiling-pipeline \
#  --dump-pass-pipeline \
#   --mlir-print-ir-after-all \
#   --mlir-disable-threading  2>&1 | tee $2




    # --iree-codegen-iree-comprehensive-bufferize \
  # --convert-linalg-to-loops \
#some flags
# $IREE_OPT $1 --mlir-pretty-debuginfo  \
#   --iree-hal-target-backends=llvm-cpu \
#   --iree-abi-transformation-pipeline \
#   --iree-flow-transformation-pipeline \
#   --iree-stream-transformation-pipeline \
#   --iree-hal-configuration-pipeline  \
#   --dump-pass-pipeline \
#   --mlir-print-ir-after-all \
#   --mlir-disable-threading 2>&1 | tee $2



# echo "------------------------------------------------------"
# $IREE_OPT tmp.mlir --mlir-print-debuginfo \
# --pass-pipeline='builtin.module(hal.executable(hal.executable.variant(iree-llvmcpu-lower-executable-target)))' \
# --iree-codegen-llvmcpu-use-transform-dialect=matmul_cust_spec.mlir

#   --iree-codegen-yufan-ana \
#   --mlir-print-ir-after-all \

# --convert-linalg-to-loops
#   --iree-abi-transformation-pipeline \
#   --iree-flow-transformation-pipeline \
#   --iree-stream-transformation-pipeline \
#   --iree-hal-configuration-pipeline  \
  
# $IREE_OPT  $1 --iree-hal-target-backends=llvm-cpu \
#    --iree-abi-transformation-pipeline --iree-flow-transformation-pipeline \
#    --iree-stream-transformation-pipeline \
#    --iree-hal-configuration-pipeline | \
# $IREE_OPT --pass-pipeline='builtin.module(hal.executable(hal.executable.variant(iree-llvmcpu-lower-executable-target)))' \
#    --iree-codegen-llvmcpu-use-transform-dialect=matmul_cust_spec.mlir 

# $IREE_OPT $1 --mlir-print-debuginfo  --mlir-print-ir-after-all \
#   --iree-hal-target-backends=llvm-cpu \
#   --iree-codegen-yufan-ana \
#   --iree-codegen-linalg-to-llvm-pipeline \
# --iree-codegen-llvm-mmt4d-workgroup-tile-sizes=1024 2>&1 | tee tmp.mlir