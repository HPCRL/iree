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


# ### compile 
# $IREE_CMP mhlo.mm.activate.mlir \
#   --iree-hal-target-backends=llvm-cpu \
#   --output-format=vm-bytecode \
#   --iree-input-type=mhlo \
#   --mlir-print-ir-after-all \
#   --mlir-disable-threading  -o  mhlo.mm.activate.vmfb 2>&1 | tee  mhlo.mm.activate.log.txt




$IREE_CMP mhlo.two.mm.mlir \
  --iree-hal-target-backends=llvm-cpu \
  --output-format=vm-bytecode \
  --iree-input-type=mhlo \
  --mlir-print-ir-after-all \
  --mlir-disable-threading  \
    -o llvmcpu.mm.vmfb 2>&1 | tee llvmcpu_two_mm_fullir.log.txt

# $IREE_CMP mhlo.two.add.mlir -debug-only=greedy-rewriter \
#     --iree-hal-target-backends=cuda \
#     --iree-input-type=mhlo \
#     --iree-hal-cuda-llvm-target-arch=sm_70 \
#     --mlir-print-ir-after-all \
#     -o gpu.add.vmfb 2>&1 | tee debug_gpu_two_add_fullir.log.txt



# $IREE_OPT gpu.mm.mlir \
# --iree-hal-target-backends=cuda \
# --dump-pass-pipeline \
# --mlir-print-ir-after-all \
# --pass-pipeline='builtin.module(hal.executable(hal.executable.variant(iree-llvmgpu-lower-executable-target)))' \
#  2>&1 | tee gpu_linag_mm_default_tile.log.txt

