

// // -----// IR Dump After TileAndDistributeToWorkgroups (iree-codegen-tile-and-distribute-to-workgroups) //----- //
// #executable_target_cuda_nvptx_fb = #hal.executable.target<"cuda", "cuda-nvptx-fb", {target_arch = "sm_70"}>
// #pipeline_layout = #hal.pipeline.layout<push_constants = 0, sets = [<0, bindings = [<0, storage_buffer, ReadOnly>, <1, storage_buffer, ReadOnly>, <2, storage_buffer>]>]>
// #translation = #iree_codegen.translation_info<LLVMGPUMatmulSimt>
// #device_target_cuda = #hal.device.target<"cuda", {executable_targets = [#executable_target_cuda_nvptx_fb], legacy_sync}>
// hal.executable.variant public @cuda_nvptx_fb, target = <"cuda", "cuda-nvptx-fb", {target_arch = "sm_70"}> {
//   hal.executable.export public @matmul_static_dispatch_0_matmul_512x1024x256 ordinal(0) layout(#hal.pipeline.layout<push_constants = 0, sets = [<0, bindings = [<0, storage_buffer, ReadOnly>, <1, storage_buffer, ReadOnly>, <2, storage_buffer>]>]>) attributes {translation_info = #iree_codegen.translation_info<LLVMGPUMatmulSimt>, workgroup_size = [32 : index, 8 : index, 1 : index]} {
//       ^bb0(%arg0: !hal.device, %arg1: index, %arg2 : index, %arg3 : index, %arg4 : index):
//       %x, %y, %z = flow.dispatch.workgroup_count_from_dag_root %arg1, %arg2, %arg3, %arg4
//       hal.return %x, %y, %z : index, index, index
//   }
//   builtin.module {
//     func.func @matmul_static_dispatch_0_matmul_512x1024x256() {
//         %c0 = arith.constant 0 : index
//         %0 = hal.interface.binding.subspan set(0) binding(0) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readonly:tensor<512x256xf32>>
//         %1 = hal.interface.binding.subspan set(0) binding(1) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readonly:tensor<256x1024xf32>>
//         %2 = hal.interface.binding.subspan set(0) binding(2) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readwrite:tensor<512x1024xf32>>
//         %3 = flow.dispatch.tensor.load %0, offsets = [0, 0], sizes = [512, 256], strides = [1, 1] : !flow.dispatch.tensor<readonly:tensor<512x256xf32>> -> tensor<512x256xf32>
//         %4 = flow.dispatch.tensor.load %1, offsets = [0, 0], sizes = [256, 1024], strides = [1, 1] : !flow.dispatch.tensor<readonly:tensor<256x1024xf32>> -> tensor<256x1024xf32>
//         %5 = flow.dispatch.tensor.load %2, offsets = [0, 0], sizes = [512, 1024], strides = [1, 1] : !flow.dispatch.tensor<readwrite:tensor<512x1024xf32>> -> tensor<512x1024xf32>
//         %6 = linalg.matmul ins(%3, %4 : tensor<512x256xf32>, tensor<256x1024xf32>) outs(%5 : tensor<512x1024xf32>) -> tensor<512x1024xf32>
//         flow.dispatch.tensor.store %6, %2, offsets = [0, 0], sizes = [512, 1024], strides = [1, 1] : tensor<512x1024xf32> -> !flow.dispatch.tensor<readwrite:tensor<512x1024xf32>>
//         return
//     }
//   }
// }


#device_target_cuda = #hal.device.target<"cuda", {executable_targets = [#hal.executable.target<"cuda", "cuda-nvptx-fb", {target_arch = "sm_70"}>]}>
#executable_target_cuda_nvptx_fb = #hal.executable.target<"cuda", "cuda-nvptx-fb", {target_arch = "sm_70"}>
#pipeline_layout = #hal.pipeline.layout<push_constants = 0, sets = [<0, bindings = [<0, storage_buffer, ReadOnly>, <1, storage_buffer, ReadOnly>, <2, storage_buffer>]>]>

module attributes {hal.device.targets = [#device_target_cuda]} {
  hal.executable private @matmul_static_dispatch_0_matmul_512x1024x256 {
    hal.executable.variant public @cuda_nvptx_fb, target = #executable_target_cuda_nvptx_fb {
      hal.executable.export public @matmul_static_dispatch_0_matmul_512x1024x256 ordinal(0) layout(#pipeline_layout) {
      ^bb0(%arg0: !hal.device, %arg1: index, %arg2: index, %arg3: index, %arg4: index, %arg5: index, %arg6: index, %arg7: index):
        %x, %y, %z = flow.dispatch.workgroup_count_from_dag_root %arg1, %arg2, %arg3, %arg4, %arg5, %arg6, %arg7
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @matmul_static_dispatch_0_matmul_512x1024x256() {
        %c0 = arith.constant 0 : index
        %0 = hal.interface.binding.subspan set(0) binding(0) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readonly:tensor<512x256xf32>>
        %1 = hal.interface.binding.subspan set(0) binding(1) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readonly:tensor<256x1024xf32>>
        %2 = hal.interface.binding.subspan set(0) binding(2) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readwrite:tensor<512x1024xf32>>
        %3 = flow.dispatch.tensor.load %0, offsets = [0, 0], sizes = [512, 256], strides = [1, 1] : !flow.dispatch.tensor<readonly:tensor<512x256xf32>> -> tensor<512x256xf32>
        %4 = flow.dispatch.tensor.load %1, offsets = [0, 0], sizes = [256, 1024], strides = [1, 1] : !flow.dispatch.tensor<readonly:tensor<256x1024xf32>> -> tensor<256x1024xf32>
        %5 = flow.dispatch.tensor.load %2, offsets = [0, 0], sizes = [512, 1024], strides = [1, 1] : !flow.dispatch.tensor<readwrite:tensor<512x1024xf32>> -> tensor<512x1024xf32>
        %6 = linalg.matmul ins(%3, %4 : tensor<512x256xf32>, tensor<256x1024xf32>) outs(%5 : tensor<512x1024xf32>) -> tensor<512x1024xf32>
        flow.dispatch.tensor.store %6, %2, offsets = [0, 0], sizes = [512, 1024], strides = [1, 1] : tensor<512x1024xf32> -> !flow.dispatch.tensor<readwrite:tensor<512x1024xf32>>
        return
        }
      }
    }
  }
}