

!A_size = tensor<512x256xf32>
!B_size = tensor<256x1024xf32>
!intmed1_size = tensor<512x1024xf32>
!Out_size = tensor<512x1024xf32>


// For generate defualt function 
func.func @mm_cosine_static(
    %A : !A_size, %B : !B_size) -> !Out_size {

  %0 = "mhlo.dot"(%A, %B ) : (!A_size, !B_size) -> !intmed1_size
  %Out = "mhlo.cosine"(%0) : (!intmed1_size) -> !Out_size
  
  
  return %Out : !Out_size
}