// #map3 = affine_map<(d0) -> (d0)>
// #map4 = affine_map<(d0, d1) -> (d0)>
// #map5 = affine_map<(d0, d1) -> (d0, d1)>
// #executable_target_embedded_elf_x86_64_ = #hal.executable.target<"llvm-cpu", "embedded-elf-x86_64", {
//   cpu_features = "",
//   data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128",
//   native_vector_size = 16 : index,
//   target_triple = "x86_64-unknown-unknown-eabi-elf"}>
// #pipeline_layout5 = #hal.pipeline.layout<push_constants = 2, sets = [
//   #hal.descriptor_set.layout<0, bindings = [
//     #hal.descriptor_set.binding<0, storage_buffer>,
//     #hal.descriptor_set.binding<1, storage_buffer>]
//   >]>
// hal.executable private @check_no_cse {
//   hal.executable.variant public @embedded_elf_x86_64, target = #executable_target_embedded_elf_x86_64_ {
//     hal.executable.export public @check_no_cse ordinal(0) layout(#pipeline_layout5) {
//     ^bb0(%arg0: !hal.device, %arg1: index):
//       %x, %y, %z = flow.dispatch.workgroup_count_from_dag_root %arg1
//       hal.return %x, %y, %z : index, index, index
//     }
//     builtin.module {
//       func.func @check_no_cse() {
//         %c0 = arith.constant 0 : index
//         %cst = arith.constant 0.000000e+00 : f32
//         %0 = hal.interface.binding.subspan set(0) binding(0) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readonly:tensor<128x256xf32>>
//         %1 = hal.interface.binding.subspan set(0) binding(1) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readonly:tensor<256x512xf32>>
//         %2 = hal.interface.binding.subspan set(0) binding(2) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<writeonly:tensor<128x512xf32>>
//         %3 = flow.dispatch.tensor.load %0, offsets = [0, 0], sizes = [128, 256], strides = [1, 1] : !flow.dispatch.tensor<readonly:tensor<128x256xf32>> -> tensor<128x256xf32>
//         %4 = flow.dispatch.tensor.load %1, offsets = [0, 0], sizes = [256, 512], strides = [1, 1] : !flow.dispatch.tensor<readonly:tensor<256x512xf32>> -> tensor<256x512xf32>
//         %5 = tensor.empty() : tensor<128x512xf32>
//         %6 = linalg.fill ins(%cst : f32) outs(%5 : tensor<128x512xf32>) -> tensor<128x512xf32>
//         %7 = linalg.matmul {compilation_info = #iree_codegen.compilation_info<lowering_config = <tile_sizes = [[32, 32], [8, 8, 0], [0, 0, 8]]>, translation_info = <CPUDoubleTilingPadExpert>>} ins(%3, %4 : tensor<128x256xf32>, tensor<256x512xf32>) outs(%6 : tensor<128x512xf32>) -> tensor<128x512xf32>
//         flow.dispatch.tensor.store %7, %2, offsets = [0, 0], sizes = [128, 512], strides = [1, 1] : tensor<128x512xf32> -> !flow.dispatch.tensor<writeonly:tensor<128x512xf32>>
//         return
//       }
//     }
//   }
// }


#executable_target_embedded_elf_x86_64_ = #hal.executable.target<"llvm-cpu", "embedded-elf-x86_64", {
  cpu_features = "",
  data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128",
  native_vector_size = 16 : index,
  target_triple = "x86_64-unknown-unknown-eabi-elf"}>
#pipeline_layout = #hal.pipeline.layout<push_constants = 6, sets = [
  #hal.descriptor_set.layout<0, bindings = [
    #hal.descriptor_set.binding<0, storage_buffer>,
    #hal.descriptor_set.binding<1, storage_buffer>,
    #hal.descriptor_set.binding<2, storage_buffer>]
  >]>
hal.executable private @batch_matmul_dynamic {
  hal.executable.variant public @embedded_elf_x86_64, target = #executable_target_embedded_elf_x86_64_ {
    hal.executable.export public @batch_matmul_dynamic ordinal(0) layout(#pipeline_layout) {
    ^bb0(%arg0: !hal.device, %arg1: index, %arg2 : index, %arg3 : index, %arg4 : index):
      %x, %y, %z = flow.dispatch.workgroup_count_from_dag_root %arg1, %arg2, %arg3, %arg4
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @batch_matmul_dynamic() {
         %c0 = arith.constant 0 : index
        %cst = arith.constant 0.000000e+00 : f32
        %0 = hal.interface.binding.subspan set(0) binding(0) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readonly:tensor<128x256xf32>>
        %1 = hal.interface.binding.subspan set(0) binding(1) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readonly:tensor<256x512xf32>>
        %2 = hal.interface.binding.subspan set(0) binding(2) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<writeonly:tensor<128x512xf32>>
        %3 = flow.dispatch.tensor.load %0, offsets = [0, 0], sizes = [128, 256], strides = [1, 1] : !flow.dispatch.tensor<readonly:tensor<128x256xf32>> -> tensor<128x256xf32>
        %4 = flow.dispatch.tensor.load %1, offsets = [0, 0], sizes = [256, 512], strides = [1, 1] : !flow.dispatch.tensor<readonly:tensor<256x512xf32>> -> tensor<256x512xf32>
        %5 = tensor.empty() : tensor<128x512xf32>
        %6 = linalg.fill ins(%cst : f32) outs(%5 : tensor<128x512xf32>) -> tensor<128x512xf32>
        %7 = linalg.matmul {compilation_info = #iree_codegen.compilation_info<lowering_config = <tile_sizes = [[32, 32], [8, 8, 0], [0, 0, 8]]>, translation_info = <CPUDoubleTilingPadExpert>>} ins(%3, %4 : tensor<128x256xf32>, tensor<256x512xf32>) outs(%6 : tensor<128x512xf32>) -> tensor<128x512xf32>
        flow.dispatch.tensor.store %7, %2, offsets = [0, 0], sizes = [128, 512], strides = [1, 1] : tensor<128x512xf32> -> !flow.dispatch.tensor<writeonly:tensor<128x512xf32>>
        return
      }
    }
  }
}