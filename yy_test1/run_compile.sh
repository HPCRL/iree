IREE_OPT=/home/yufan/iree/iree-build/tools/iree-opt
IREE_CMP=/home/yufan/iree/iree-build/tools/iree-compile


# ### compile 
# $IREE_CMP linag_mm.mlir \
#   --iree-hal-target-backends=llvm-cpu \
#   --output-format=vm-bytecode \
#   --iree-input-type=mhlo \
#   --mlir-print-ir-after-all \
#   --mlir-disable-threading  -o linag_mm_default_tile.vmfb 2>&1 | tee linag_mm_default_tile.log.txt



# $IREE_OPT mm.mlir \
# --iree-hal-target-backends=llvm-cpu \
# --mlir-print-ir-after-all \
# --dump-pass-pipeline \
# --pass-pipeline='builtin.module(hal.executable(hal.executable.variant(iree-llvmcpu-lower-executable-target)))' \
# # 2>&1 | tee mm_ir_default_tile.log.txt



# $IREE_OPT mm.mlir \
# --iree-hal-target-backends=llvm-cpu \
# --mlir-print-ir-after-all \
# --dump-pass-pipeline \
# --pass-pipeline='builtin.module(hal.executable(hal.executable.variant(iree-llvmcpu-lower-executable-target)))' \
# 2>&1 | tee mm_ir_default_tile.log_change_tilesize.txt


# $IREE_OPT linag_mm.mlir \
# --iree-hal-target-backends=llvm-cpu \
# --mlir-print-ir-after-all \
# --dump-pass-pipeline \
# --pass-pipeline='builtin.module(hal.executable(hal.executable.variant(iree-llvmcpu-lower-executable-target)))' \



# $IREE_OPT linag_mm.mlir --iree-hal-target-backends=llvm-cpu \
#    --iree-abi-transformation-pipeline --iree-flow-transformation-pipeline \
#    --iree-flow-dispatch-generate-workload-region=false \
#    --iree-stream-transformation-pipeline \
#   --iree-hal-configuration-pipeline > mm.tmp.hal.mlir
# $IREE_OPT mm.tmp.hal.mlir --pass-pipeline='builtin.module(hal.executable(hal.executable.variant(iree-llvmcpu-lower-executable-target)))' \
