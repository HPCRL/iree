//----> Yufan woof woof ----->
#executable_target_embedded_elf_x86_64_ = #hal.executable.target<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", native_vector_size = 16 : index, target_triple = "x86_64-unknown-unknown-eabi-elf"}>
#map = affine_map<(d0, d1, d2, d3) -> (d0, d2, d3)>
#map1 = affine_map<(d0, d1, d2, d3) -> (d3, d1)>
#map2 = affine_map<(d0, d1, d2, d3) -> (d2, d1)>
#map3 = affine_map<(d0, d1, d2, d3) -> (d0, d1)>
#pipeline_layout = #hal.pipeline.layout<push_constants = 0, sets = [<0, bindings = [<0, storage_buffer, ReadOnly>, <1, storage_buffer, ReadOnly>, <2, storage_buffer, ReadOnly>, <3, storage_buffer>]>]>
#device_target_llvm_cpu = #hal.device.target<"llvm-cpu", {executable_targets = [#executable_target_embedded_elf_x86_64_]}>
module attributes {hal.device.targets = [#device_target_llvm_cpu]} {
  hal.executable private @mttkrp_static_dispatch_0 {
    hal.executable.variant public @embedded_elf_x86_64, target = #executable_target_embedded_elf_x86_64_ {
      hal.executable.export public @mttkrp_static_dispatch_0_generic_512x256x1024x64 ordinal(0) layout(#pipeline_layout)
      builtin.module {
        func.func @mttkrp_static_dispatch_0_generic_512x256x1024x64() {
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan set(0) binding(0) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readonly:tensor<512x1024x64xf32>>
          %1 = hal.interface.binding.subspan set(0) binding(1) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readonly:tensor<64x256xf32>>
          %2 = hal.interface.binding.subspan set(0) binding(2) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readonly:tensor<1024x256xf32>>
          %3 = hal.interface.binding.subspan set(0) binding(3) type(storage_buffer) offset(%c0) alignment(64) : !flow.dispatch.tensor<readwrite:tensor<512x256xf32>>
          %4 = flow.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [512, 1024, 64], strides = [1, 1, 1] : !flow.dispatch.tensor<readonly:tensor<512x1024x64xf32>> -> tensor<512x1024x64xf32>
          %5 = flow.dispatch.tensor.load %1, offsets = [0, 0], sizes = [64, 256], strides = [1, 1] : !flow.dispatch.tensor<readonly:tensor<64x256xf32>> -> tensor<64x256xf32>
          %6 = flow.dispatch.tensor.load %2, offsets = [0, 0], sizes = [1024, 256], strides = [1, 1] : !flow.dispatch.tensor<readonly:tensor<1024x256xf32>> -> tensor<1024x256xf32>
          %7 = flow.dispatch.tensor.load %3, offsets = [0, 0], sizes = [512, 256], strides = [1, 1] : !flow.dispatch.tensor<readwrite:tensor<512x256xf32>> -> tensor<512x256xf32>
          %8 = linalg.generic {indexing_maps = [#map, #map1, #map2, #map3], iterator_types = ["parallel", "parallel", "reduction", "reduction"]} ins(%4, %5, %6 : tensor<512x1024x64xf32>, tensor<64x256xf32>, tensor<1024x256xf32>) outs(%7 : tensor<512x256xf32>) {
          ^bb0(%in: f32, %in_0: f32, %in_1: f32, %out: f32):
            %9 = arith.mulf %in_0, %in_1 : f32
            %10 = arith.mulf %9, %out : f32
            %11 = arith.addf %in, %10 : f32
            linalg.yield %11 : f32
          } -> tensor<512x256xf32>
          flow.dispatch.tensor.store %8, %3, offsets = [0, 0], sizes = [512, 256], strides = [1, 1] : tensor<512x256xf32> -> !flow.dispatch.tensor<readwrite:tensor<512x256xf32>>
          return
        }
      }
    }
  }
  func.func @mttkrp_static(%arg0: !hal.buffer_view, %arg1: !hal.buffer_view, %arg2: !hal.buffer_view, %arg3: !hal.buffer_view) -> !hal.buffer_view attributes {iree.abi.stub} {
    %c0 = arith.constant 0 : index
    %c524288 = arith.constant 524288 : index
    %c134217728 = arith.constant 134217728 : index
    %c1048576 = arith.constant 1048576 : index
    %c65536 = arith.constant 65536 : index
    %c64 = arith.constant 64 : index
    %c1024 = arith.constant 1024 : index
    %c553648160_i32 = arith.constant 553648160 : i32
    %c1_i32 = arith.constant 1 : i32
    %c512 = arith.constant 512 : index
    %c256 = arith.constant 256 : index
    hal.buffer_view.assert<%arg0 : !hal.buffer_view> message("tensor") shape([%c512, %c256]) type(%c553648160_i32) encoding(%c1_i32)
    %0 = stream.tensor.import %arg0 : !hal.buffer_view -> tensor<512x256xf32> in !stream.resource<external>{%c524288}
    hal.buffer_view.assert<%arg1 : !hal.buffer_view> message("tensor") shape([%c512, %c1024, %c64]) type(%c553648160_i32) encoding(%c1_i32)
    %1 = stream.tensor.import %arg1 : !hal.buffer_view -> tensor<512x1024x64xf32> in !stream.resource<external>{%c134217728}
    hal.buffer_view.assert<%arg2 : !hal.buffer_view> message("tensor") shape([%c1024, %c256]) type(%c553648160_i32) encoding(%c1_i32)
    %2 = stream.tensor.import %arg2 : !hal.buffer_view -> tensor<1024x256xf32> in !stream.resource<external>{%c1048576}
    hal.buffer_view.assert<%arg3 : !hal.buffer_view> message("tensor") shape([%c64, %c256]) type(%c553648160_i32) encoding(%c1_i32)
    %3 = stream.tensor.import %arg3 : !hal.buffer_view -> tensor<64x256xf32> in !stream.resource<external>{%c65536}
    %4 = stream.cmd.execute with(%1 as %arg4: !stream.resource<external>{%c134217728}, %3 as %arg5: !stream.resource<external>{%c65536}, %2 as %arg6: !stream.resource<external>{%c1048576}, %0 as %arg7: !stream.resource<external>{%c524288}) {
      stream.cmd.dispatch @mttkrp_static_dispatch_0::@mttkrp_static_dispatch_0_generic_512x256x1024x64 {
        ro %arg4[%c0 for %c134217728] : !stream.resource<external>{%c134217728},
        ro %arg5[%c0 for %c65536] : !stream.resource<external>{%c65536},
        ro %arg6[%c0 for %c1048576] : !stream.resource<external>{%c1048576},
        rw %arg7[%c0 for %c524288] : !stream.resource<external>{%c524288}
      } attributes {hal.interface.bindings = [#hal.interface.binding<0, 0>, #hal.interface.binding<0, 1>, #hal.interface.binding<0, 2>, #hal.interface.binding<0, 3>]}
    } => !stream.timepoint
    %5 = stream.timepoint.await %4 => %0 : !stream.resource<external>{%c524288}
    %6 = stream.tensor.export %5 : tensor<512x256xf32> in !stream.resource<external>{%c524288} -> !hal.buffer_view
    return %6 : !hal.buffer_view
  }
}

