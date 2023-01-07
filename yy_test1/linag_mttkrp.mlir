!A_size = tensor<512x256xf32>
!B_size = tensor<512x1024x64xf32>
!D_size = tensor<64x256xf32>
!C_size = tensor<1024x256xf32>

// i = 512; j = 256; k = 1024; l = 64
// A[i,j] = sum{k l} B[i,k,l] D[l,j] C[k,j]

#mttkrp_accesses = [
  affine_map<(i, j, k, l) -> (i, k, l)>,
  affine_map<(i, j, k, l) -> (l, j)>,
  affine_map<(i, j, k, l) -> (k, j)>,
  affine_map<(i, j, k, l) -> (i, j)>
]

func.func @mttkrp_static( %A : !A_size, %B : !B_size, %C : !C_size, %D : !D_size) -> !A_size {
  %0 = linalg.generic  {
    indexing_maps = #mttkrp_accesses,
    iterator_types = ["parallel", "parallel", "reduction", "reduction"]
  }
  ins(%B, %D, %C: !B_size, !D_size, !C_size)
  outs(%A: !A_size)
  {
    ^bb0(%a: f32, %b: f32, %d: f32, %c: f32) :
      %tmp0 = arith.mulf %b, %d: f32
      %tmp1 = arith.mulf %tmp0, %c: f32
      %res = arith.addf %a, %tmp1: f32
      linalg.yield %res : f32
  } -> !A_size

  return %0 : !A_size
}


//////////////////
// #mttkrp_trait = {
//   doc = "A(i, j) += B(i, k, l) * D(l, j) * C(k, j)",
//   indexing_maps = #mttkrp_accesses,
//   library_call = "linalg_mttkrp",
//   iterator_types = ["parallel", "parallel", "reduction", "reduction"]
// }

// linalg.generic #mttkrp_trait
//   ins(%BB, %DD, %CC: memref<?x?x?xf32, 1>, memref<?x?xf32, 1>, memref<?x?xf32, 1>)
//   outs(%AA : memref<?x?xf32, 1>)
//  {
//   ^bb0(%a: f32, %b: f32, %d: f32, %c: f32) :
//     %tmp0 = arith.mulf %b, %d: f32
//     %tmp1 = arith.mulf %tmp0, %c: f32
//     %res = arith.addf %a, %tmp1: f32
//     linalg.yield %res : f32
// }

// func.func @mttkrp_static( %A : !A_size, %B : !B_size, %C : !C_size, %D : !D_size) -> !A_size {
//   %0 = linalg_mttkrp  ins(%B : !B_size, %D : !D_size, %C : !C_size)
//                       outs(%A : !A_size) -> !A_size
//   return %0 : !A_size
// }
