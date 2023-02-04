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
  %0 = linalg.matmul ins(%A, %B : !A_size, !B_size)
                     outs(%C : !C_size) -> !C_size
  return %0 : !C_size
}

