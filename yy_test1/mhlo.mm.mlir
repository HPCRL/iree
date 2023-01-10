// func.func @lowering_config_test() {
//   %a = util.unfoldable_constant dense<1.0> : tensor<128x256xf32>
//   %b = util.unfoldable_constant dense<2.0> : tensor<256x512xf32>
//   %c = util.unfoldable_constant dense<2.0> : tensor<256x1024xf32>
//   %0 = "mhlo.dot"(%a, %b) {compilation_info = #compilation0} : (tensor<128x256xf32>, tensor<256x512xf32>) -> tensor<128x512xf32>
//   %1 = "mhlo.dot"(%a, %c) {compilation_info = #compilation1} : (tensor<128x256xf32>, tensor<256x1024xf32>) -> tensor<128x1024xf32>
//   %2 = "mhlo.dot"(%a, %c) {compilation_info = #compilation2} : (tensor<128x256xf32>, tensor<256x1024xf32>) -> tensor<128x1024xf32>
//   check.expect_almost_eq_const(%0, dense<512.0> : tensor<128x512xf32>) : tensor<128x512xf32>
//   check.expect_almost_eq_const(%1, dense<512.0> : tensor<128x1024xf32>) : tensor<128x1024xf32>
//   check.expect_almost_eq_const(%2, dense<512.0> : tensor<128x1024xf32>) : tensor<128x1024xf32>
//   return
// }

!A_size = tensor<512x256xf32>
!B_size = tensor<256x1024xf32>
!C_size = tensor<512x1024xf32>

// For user provide 
// #compilation0 = #iree_codegen.compilation_info<
// lowering_config = <tile_sizes = [[32, 32], [8, 8, 0], [0, 0, 8]]>,
// translation_info = <CPUDoubleTilingPadExpert>,
// workgroup_size = []>

// func.func @matmul_static(
//     %A : !A_size, %B : !B_size, %C : !C_size) -> !C_size {
//   %0 = linalg.matmul{compilation_info = #compilation0} ins(%A, %B : !A_size, !B_size)
//                      outs(%C : !C_size) -> !C_size
//   return %0 : !C_size
// }



// For generate defualt function 
func.func @matmul_static(
    %A : !A_size, %B : !B_size, %C : !C_size) -> !C_size {
  %0 = "mhlo.dot"(%A, %B ) : (!A_size, !B_size) -> !C_size
  return %0 : !C_size
}