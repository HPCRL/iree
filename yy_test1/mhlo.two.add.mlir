

!A_size = tensor<512x256xf32>
!B_size = tensor<512x256xf32>
!intmed1_size = tensor<512x256xf32>
!C_size = tensor<512x256xf32>
!Out_size = tensor<512x256xf32>


// For generate defualt function 
func.func @twoadd_static(
    %A : !A_size, %B : !B_size, %C : !C_size) -> !Out_size {

  %0 = "mhlo.add"(%A, %B ) : (!A_size, !B_size) -> !intmed1_size
  %Out = "mhlo.add"(%0, %C ) : (!intmed1_size, !C_size) -> !Out_size
  
  
  return %Out : !Out_size
}