//----> Yufan woof woof ----->
#executable_target_embedded_elf_x86_64_ = #hal.executable.target<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", native_vector_size = 16 : index, target_triple = "x86_64-unknown-unknown-eabi-elf"}>
#pipeline_layout = #hal.pipeline.layout<push_constants = 0, sets = [<0, bindings = [<0, storage_buffer, ReadOnly>, <1, storage_buffer, ReadOnly>, <2, storage_buffer>]>]>
#device_target_llvm_cpu = #hal.device.target<"llvm-cpu", {executable_targets = [#executable_target_embedded_elf_x86_64_]}>
module attributes {hal.device.targets = [#device_target_llvm_cpu]} {
  hal.executable private @matmul_static_dispatch_0 {
    hal.executable.variant public @embedded_elf_x86_64, target = #executable_target_embedded_elf_x86_64_ {
      hal.executable.export public @matmul_static_dispatch_0_matmul_512x1024x256 ordinal(0) layout(#pipeline_layout)
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
  func.func @matmul_static(%arg0: !hal.buffer_view, %arg1: !hal.buffer_view, %arg2: !hal.buffer_view) -> !hal.buffer_view attributes {iree.abi.stub} {
    %c0 = arith.constant 0 : index
    %c524288 = arith.constant 524288 : index
    %c1048576 = arith.constant 1048576 : index
    %c2097152 = arith.constant 2097152 : index
    %c1024 = arith.constant 1024 : index
    %c553648160_i32 = arith.constant 553648160 : i32
    %c1_i32 = arith.constant 1 : i32
    %c512 = arith.constant 512 : index
    %c256 = arith.constant 256 : index
    hal.buffer_view.assert<%arg0 : !hal.buffer_view> message("tensor") shape([%c512, %c256]) type(%c553648160_i32) encoding(%c1_i32)
    %0 = stream.tensor.import %arg0 : !hal.buffer_view -> tensor<512x256xf32> in !stream.resource<external>{%c524288}
    hal.buffer_view.assert<%arg1 : !hal.buffer_view> message("tensor") shape([%c256, %c1024]) type(%c553648160_i32) encoding(%c1_i32)
    %1 = stream.tensor.import %arg1 : !hal.buffer_view -> tensor<256x1024xf32> in !stream.resource<external>{%c1048576}
    hal.buffer_view.assert<%arg2 : !hal.buffer_view> message("tensor") shape([%c512, %c1024]) type(%c553648160_i32) encoding(%c1_i32)
    %2 = stream.tensor.import %arg2 : !hal.buffer_view -> tensor<512x1024xf32> in !stream.resource<external>{%c2097152}
    %3 = stream.cmd.execute with(%0 as %arg3: !stream.resource<external>{%c524288}, %1 as %arg4: !stream.resource<external>{%c1048576}, %2 as %arg5: !stream.resource<external>{%c2097152}) {
      stream.cmd.dispatch @matmul_static_dispatch_0::@matmul_static_dispatch_0_matmul_512x1024x256 {
        ro %arg3[%c0 for %c524288] : !stream.resource<external>{%c524288},
        ro %arg4[%c0 for %c1048576] : !stream.resource<external>{%c1048576},
        rw %arg5[%c0 for %c2097152] : !stream.resource<external>{%c2097152}
      } attributes {hal.interface.bindings = [#hal.interface.binding<0, 0>, #hal.interface.binding<0, 1>, #hal.interface.binding<0, 2>]}
    } => !stream.timepoint
    %4 = stream.timepoint.await %3 => %2 : !stream.resource<external>{%c2097152}
    %5 = stream.tensor.export %4 : tensor<512x1024xf32> in !stream.resource<external>{%c2097152} -> !hal.buffer_view
    return %5 : !hal.buffer_view
  }
}

