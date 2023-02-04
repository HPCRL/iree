IREE_OPT=/home/yufan/iree/iree-build/tools/iree-opt
IREE_CMP=/home/yufan/iree/iree-build/tools/iree-compile



$IREE_OPT $1 --iree-hal-target-backends=llvm-cpu \
  --iree-abi-transformation-pipeline --iree-flow-transformation-pipeline \
   --iree-flow-dispatch-generate-workload-region=false \
   --iree-stream-transformation-pipeline \
  --iree-hal-configuration-pipeline |


$IREE_OPT --pass-pipeline='builtin.module(hal.executable(hal.executable.variant(iree-llvmcpu-lower-executable-target)))' \
   --iree-codegen-llvmcpu-use-transform-dialect=matmul_cust_spec.mlir


# $IREE_OPT --pass-pipeline='builtin.module(hal.executable(hal.executable.variant(iree-llvmcpu-lower-executable-target)))' \
#   --iree-codegen-llvmcpu-use-transform-dialect=matmul_cust_spec.mlir

