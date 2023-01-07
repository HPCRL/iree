IREE_OPT=/home/yufan/iree/iree-build/tools/iree-opt
IREE_CMP=/home/yufan/iree/iree-build/tools/iree-compile
### bufferize to scf
$IREE_OPT linag_mttkrp.mlir \
    --mlir-pretty-debuginfo  \
    --iree-hal-target-backends=llvm-cpu \
    --iree-codegen-iree-comprehensive-bufferize \
    --convert-linalg-to-loops \
    --dump-pass-pipeline \
    --mlir-disable-threading  

# ### print region info
# $IREE_OPT $1 --mlir-pretty-debuginfo  \
#   --iree-hal-target-backends=llvm-cpu \
#   --iree-codegen-iree-comprehensive-bufferize \
#   --convert-linalg-to-loops \
#   --dump-pass-pipeline \
#   --iree-codegen-yufan-ana \
#   --mlir-disable-threading  2>&1 | tee $2

