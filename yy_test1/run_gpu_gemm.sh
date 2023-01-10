IREE_OPT=/home/yufan/iree/iree-build/tools/iree-opt
IREE_CMP=/home/yufan/iree/iree-build/tools/iree-compile
# ### bufferize to scf
# $IREE_OPT linag_mttkrp.mlir \
#     --mlir-pretty-debuginfo  \
#     --iree-hal-target-backends=llvm-cpu \
#     --iree-codegen-iree-comprehensive-bufferize \
#     --convert-linalg-to-loops \
#     --dump-pass-pipeline \
#     --mlir-disable-threading  




# $IREE_CMP mhlo.mm.mlir \
#     --iree-hal-target-backends=cuda \
#     --iree-input-type=mhlo \
#     --iree-hal-cuda-llvm-target-arch=sm_70 \
#     --mlir-print-ir-after-all \
#     -o gpu.mm.vmfb 2>&1 | tee gpu_mm_default_tile.log.txt




$IREE_OPT gpu.mm.mlir \
--iree-hal-target-backends=cuda \
--dump-pass-pipeline \
--mlir-print-ir-after-all \
--pass-pipeline='builtin.module(hal.executable(hal.executable.variant(iree-llvmgpu-lower-executable-target)))' \
 2>&1 | tee gpu_linag_mm_default_tile.log.txt

