//----> Yufan woof woof ----->
#config = #iree_codegen.lowering_config<tile_sizes = [[32, 32, 0, 0], [1, 4, 0, 0], [0, 0, 1, 4]]>
#executable_target_embedded_elf_x86_64_ = #hal.executable.target<"llvm-cpu", "embedded-elf-x86_64", {cpu = "generic", cpu_features = "", data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", native_vector_size = 16 : index, target_triple = "x86_64-unknown-unknown-eabi-elf"}>
#map = affine_map<()[s0] -> (s0 * 32)>
#map1 = affine_map<(d0, d1, d2, d3) -> (d0, d2, d3)>
#map2 = affine_map<(d0, d1, d2, d3) -> (d3, d1)>
#map3 = affine_map<(d0, d1, d2, d3) -> (d2, d1)>
#map4 = affine_map<(d0, d1, d2, d3) -> (d0, d1)>
#pipeline_layout = #hal.pipeline.layout<push_constants = 0, sets = [<0, bindings = [<0, storage_buffer, ReadOnly>, <1, storage_buffer, ReadOnly>, <2, storage_buffer, ReadOnly>, <3, storage_buffer>]>]>
#translation = #iree_codegen.translation_info<CPUDoubleTilingExpert>
#device_target_llvm_cpu = #hal.device.target<"llvm-cpu", {executable_targets = [#executable_target_embedded_elf_x86_64_]}>
module attributes {hal.device.targets = [#device_target_llvm_cpu]} {
  hal.executable private @mttkrp_static_dispatch_0 {
    hal.executable.variant public @embedded_elf_x86_64, target = #executable_target_embedded_elf_x86_64_ {
      hal.executable.export public @mttkrp_static_dispatch_0_generic_512x256x1024x64 ordinal(0) layout(#pipeline_layout) attributes {translation_info = #translation}
      builtin.module {
        func.func @mttkrp_static_dispatch_0_generic_512x256x1024x64() {
          %c1024 = arith.constant 1024 : index
          %c64 = arith.constant 64 : index
          %c1 = arith.constant 1 : index
          %c4 = arith.constant 4 : index
          %c32 = arith.constant 32 : index
          %c512 = arith.constant 512 : index
          %c256 = arith.constant 256 : index
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan set(0) binding(0) type(storage_buffer) offset(%c0) alignment(64) : memref<512x1024x64xf32>
          memref.assume_alignment %0, 64 : memref<512x1024x64xf32>
          %1 = hal.interface.binding.subspan set(0) binding(1) type(storage_buffer) offset(%c0) alignment(64) : memref<64x256xf32>
          memref.assume_alignment %1, 64 : memref<64x256xf32>
          %2 = hal.interface.binding.subspan set(0) binding(2) type(storage_buffer) offset(%c0) alignment(64) : memref<1024x256xf32>
          memref.assume_alignment %2, 64 : memref<1024x256xf32>
          %3 = hal.interface.binding.subspan set(0) binding(3) type(storage_buffer) offset(%c0) alignment(64) : memref<512x256xf32>
          memref.assume_alignment %3, 64 : memref<512x256xf32>
          %workgroup_id_x = hal.interface.workgroup.id[0] : index
          %workgroup_count_x = hal.interface.workgroup.count[0] : index
          %workgroup_id_y = hal.interface.workgroup.id[1] : index
          %workgroup_count_y = hal.interface.workgroup.count[1] : index
          %4 = affine.apply #map()[%workgroup_id_y]
          %5 = affine.apply #map()[%workgroup_count_y]
          %6 = affine.apply #map()[%workgroup_id_x]
          %7 = affine.apply #map()[%workgroup_count_x]
          scf.for %arg0 = %4 to %c512 step %5 {
            %subview = memref.subview %0[%arg0, 0, 0] [32, 1024, 64] [1, 1, 1] : memref<512x1024x64xf32> to memref<32x1024x64xf32, strided<[65536, 64, 1], offset: ?>>
            scf.for %arg1 = %6 to %c256 step %7 {
              %subview_0 = memref.subview %1[0, %arg1] [64, 32] [1, 1] : memref<64x256xf32> to memref<64x32xf32, strided<[256, 1], offset: ?>>
              %subview_1 = memref.subview %2[0, %arg1] [1024, 32] [1, 1] : memref<1024x256xf32> to memref<1024x32xf32, strided<[256, 1], offset: ?>>
              %subview_2 = memref.subview %3[%arg0, %arg1] [32, 32] [1, 1] : memref<512x256xf32> to memref<32x32xf32, strided<[256, 1], offset: ?>>
              scf.for %arg2 = %c0 to %c32 step %c1 {
                %subview_3 = memref.subview %subview[%arg2, 0, 0] [1, 1024, 64] [1, 1, 1] : memref<32x1024x64xf32, strided<[65536, 64, 1], offset: ?>> to memref<1x1024x64xf32, strided<[65536, 64, 1], offset: ?>>
                scf.for %arg3 = %c0 to %c32 step %c4 {
                  %subview_4 = memref.subview %subview_0[0, %arg3] [64, 4] [1, 1] : memref<64x32xf32, strided<[256, 1], offset: ?>> to memref<64x4xf32, strided<[256, 1], offset: ?>>
                  %subview_5 = memref.subview %subview_1[0, %arg3] [1024, 4] [1, 1] : memref<1024x32xf32, strided<[256, 1], offset: ?>> to memref<1024x4xf32, strided<[256, 1], offset: ?>>
                  %subview_6 = memref.subview %subview_2[%arg2, %arg3] [1, 4] [1, 1] : memref<32x32xf32, strided<[256, 1], offset: ?>> to memref<1x4xf32, strided<[256, 1], offset: ?>>
                  scf.for %arg4 = %c0 to %c1024 step %c1 {
                    %subview_7 = memref.subview %subview_5[%arg4, 0] [1, 4] [1, 1] : memref<1024x4xf32, strided<[256, 1], offset: ?>> to memref<1x4xf32, strided<[256, 1], offset: ?>>
                    scf.for %arg5 = %c0 to %c64 step %c4 {
                      %subview_8 = memref.subview %subview_3[0, %arg4, %arg5] [1, 1, 4] [1, 1, 1] : memref<1x1024x64xf32, strided<[65536, 64, 1], offset: ?>> to memref<1x1x4xf32, strided<[65536, 64, 1], offset: ?>>
                      %subview_9 = memref.subview %subview_4[%arg5, 0] [4, 4] [1, 1] : memref<64x4xf32, strided<[256, 1], offset: ?>> to memref<4x4xf32, strided<[256, 1], offset: ?>>
                      linalg.generic {indexing_maps = [#map1, #map2, #map3, #map4], iterator_types = ["parallel", "parallel", "reduction", "reduction"]} ins(%subview_8, %subview_9, %subview_7 : memref<1x1x4xf32, strided<[65536, 64, 1], offset: ?>>, memref<4x4xf32, strided<[256, 1], offset: ?>>, memref<1x4xf32, strided<[256, 1], offset: ?>>) outs(%subview_6 : memref<1x4xf32, strided<[256, 1], offset: ?>>) attrs =  {lowering_config = #config} {
                      ^bb0(%in: f32, %in_10: f32, %in_11: f32, %out: f32):
                        %8 = arith.mulf %in_10, %in_11 : f32
                        %9 = arith.mulf %8, %out : f32
                        %10 = arith.addf %in, %9 : f32
                        linalg.yield %10 : f32
                      }
                    }
                  }
                }
              }
            }
          }
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

