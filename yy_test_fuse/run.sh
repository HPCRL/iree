IREE_OPT=/home/yufan/iree/iree-build/tools/iree-opt
IREE_CMP=/home/yufan/iree/iree-build/tools/iree-compile


# ### compile 
# $IREE_CMP linag_mm.mlir \
#   --iree-hal-target-backends=llvm-cpu \
#   --output-format=vm-bytecode \
#   --iree-input-type=mhlo \
#   --mlir-print-ir-after-all \
#   --mlir-disable-threading  -o linag_mm_default_tile.vmfb 2>&1 | tee linag_mm_default_tile.log.txt





$IREE_OPT mm.mlir \
--mlir-print-ir-after-all \
--dump-pass-pipeline \
--pass-pipeline='builtin.module(hal.executable(hal.executable.variant(iree-llvmcpu-lower-executable-target)))' \
2>&1 | tee mm_ir_default_tile.log.txt