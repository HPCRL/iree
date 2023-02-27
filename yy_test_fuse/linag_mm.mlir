!A_size = tensor<512x256xf32>
!B_size = tensor<256x1024xf32>
!C_size = tensor<512x1024xf32>


// For generate defualt function 
func.func @matmul_static(
    %A : !A_size, %B : !B_size, %C : !C_size) -> !C_size {
  %0 = linalg.matmul ins(%A, %B : !A_size, !B_size)
                     outs(%C : !C_size) -> !C_size
  return %0 : !C_size
}