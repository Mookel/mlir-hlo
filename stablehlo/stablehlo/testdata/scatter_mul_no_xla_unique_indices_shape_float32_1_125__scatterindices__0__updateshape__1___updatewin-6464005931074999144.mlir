// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x125xf32>, tensor<1xf32>)
    %2 = call @expected() : () -> tensor<1x125xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xf32>, tensor<1xi32>, tensor<1xf32>) -> tensor<1x125xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xf32>, tensor<1x125xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xf32>, tensor<1xf32>) {
    %0 = stablehlo.constant dense<"0xD06A263FE75262C0DFD37B40E0430040DADB1AC003283E3F464F9540A27B61BE0B81A2401A4F084042E87E3F0B9FD53F1D3D71BFE8E52340BBBF7E406C52FE3FAA7D714029BB9C3FBDBF243F99F283BD73645EBF628EB63FCFCC05C1F6366EBFEA6B3B40D8F8ED3F37A0D83EF372ACC089FEB4BE855BBAC0ADD0793FE6190D40F73A334091A308C05DCC81C05C5D1040068E9AC079E17B40577B02C00F1BD9BDE03A9FC0C33A213D1243074028D88CC02372874014CA62C0E8FDA4BF7D8DFCBF4A8184C03C810040C15683C06A0F0A3F3D42953F3DB5CAC0128220C0BF1E31C0BB7489C0758D8840B54FBAC08EFECFBF3CDE0540712CE43FA4367D3F18C143402EA34FC0997B14408288563EEB9F05C1E5C13340FAAF8AC0D8CEC440C7E115C0D49993C0EF61804026D58B3FA6DF73C09335FE3FB7FC35402C7595C05891B2BDA1EF0040AD359F401833A2BD187926C06C5E1B40A4B52FC0CFC1BCBFAAE2044003D0C9BECA114140EE21BF3E001765C06DB05B400BAFBBBCF115A2BFD6CB6C40D6554C4022CCA0BFF5938F4097D14FC0ECA712C0A687CCBFD6B9A6400FE64440DFDF8440EEF6F13F11A119405CCBD040AA6916C0ADF70AC06CC21C40108EDB3F17C9FCBF11B4DE3D0BB5B74033DC87C0364605C09658763F71F8A0BF7E59CFBFA087A3BEB447773FACFB8BBF540B0540F55C7A40"> : tensor<1x125xf32>
    %1 = stablehlo.constant dense<-3.07394314> : tensor<1xf32>
    return %0, %1 : tensor<1x125xf32>, tensor<1xf32>
  }
  func.func private @expected() -> tensor<1x125xf32> {
    %0 = stablehlo.constant dense<"0x50C7FFBFE75262C0DFD37B40E0430040DADB1AC003283E3F464F9540A27B61BE0B81A2401A4F084042E87E3F0B9FD53F1D3D71BFE8E52340BBBF7E406C52FE3FAA7D714029BB9C3FBDBF243F99F283BD73645EBF628EB63FCFCC05C1F6366EBFEA6B3B40D8F8ED3F37A0D83EF372ACC089FEB4BE855BBAC0ADD0793FE6190D40F73A334091A308C05DCC81C05C5D1040068E9AC079E17B40577B02C00F1BD9BDE03A9FC0C33A213D1243074028D88CC02372874014CA62C0E8FDA4BF7D8DFCBF4A8184C03C810040C15683C06A0F0A3F3D42953F3DB5CAC0128220C0BF1E31C0BB7489C0758D8840B54FBAC08EFECFBF3CDE0540712CE43FA4367D3F18C143402EA34FC0997B14408288563EEB9F05C1E5C13340FAAF8AC0D8CEC440C7E115C0D49993C0EF61804026D58B3FA6DF73C09335FE3FB7FC35402C7595C05891B2BDA1EF0040AD359F401833A2BD187926C06C5E1B40A4B52FC0CFC1BCBFAAE2044003D0C9BECA114140EE21BF3E001765C06DB05B400BAFBBBCF115A2BFD6CB6C40D6554C4022CCA0BFF5938F4097D14FC0ECA712C0A687CCBFD6B9A6400FE64440DFDF8440EEF6F13F11A119405CCBD040AA6916C0ADF70AC06CC21C40108EDB3F17C9FCBF11B4DE3D0BB5B74033DC87C0364605C09658763F71F8A0BF7E59CFBFA087A3BEB447773FACFB8BBF540B0540F55C7A40"> : tensor<1x125xf32>
    return %0 : tensor<1x125xf32>
  }
}

