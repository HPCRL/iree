#executable_target_embedded_elf_x86_64_ = #hal.executable.target<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", native_vector_size = 16 : index, target_triple = "x86_64-unknown-unknown-eabi-elf"}>
#pipeline_layout = #hal.pipeline.layout<push_constants = 0, sets = [<0, bindings = [<0, storage_buffer, ReadOnly>, <1, storage_buffer, ReadOnly>, <2, storage_buffer>]>]>
#device_target_llvm_cpu = #hal.device.target<"llvm-cpu", {executable_targets = [#executable_target_embedded_elf_x86_64_]}>
module attributes {hal.device.targets = [#device_target_llvm_cpu]} {
  hal.executable private @matmul_static_dispatch_0 {
    hal.executable.variant public @embedded_elf_x86_64, target = #executable_target_embedded_elf_x86_64_ {
      hal.executable.export public @matmul_static_dispatch_0_matmul_512x1024x256 ordinal(0) layout(#pipeline_layout) {
      ^bb0(%arg0: !hal.device, %arg1: index, %arg2: index, %arg3: index):
        %x, %y, %z = flow.dispatch.workgroup_count_from_dag_root %arg1, %arg2, %arg3
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @matmul_static_dispatch_0_matmul_512x1024x256() {
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan set(0) binding(0) type(storage_buffer) alignment(64) offset(%c0) flags(ReadOnly) : !flow.dispatch.tensor<readonly:tensor<512x256xf32>>
          %1 = hal.interface.binding.subspan set(0) binding(1) type(storage_buffer) alignment(64) offset(%c0) flags(ReadOnly) : !flow.dispatch.tensor<readonly:tensor<256x1024xf32>>
          %2 = hal.interface.binding.subspan set(0) binding(2) type(storage_buffer) alignment(64) offset(%c0) : !flow.dispatch.tensor<readwrite:tensor<512x1024xf32>>
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

