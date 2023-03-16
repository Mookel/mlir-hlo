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
      stablehlo.return %arg1 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xf32>, tensor<1xi32>, tensor<1xf32>) -> tensor<1x125xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xf32>, tensor<1x125xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xf32>, tensor<1xf32>) {
    %0 = stablehlo.constant dense<"0x75FBA23F3CE2B340E8E68A3FECFE9D3FFF028EC027640EC09E2C86409E912B40A963A940D94493C0563F0BC00E1355C0A2C8AF3FFACDAEBFC63F23BFD1E712404DD954BFE56514C0C85F023F35AAE140CD57F1BF55917D40EE5530C00CA55C403DAE1B4023C92040FF21EB3F15E6213EC4CB54C0313E2F3ECC5B224004EB143F7089C23FE74B85C0D4D6413F286CEEBE34B9DD3F490251402AF955C0F35B873F6A5E97BF1748B13FFB84844029475B40FD1465C0615B5140F280333FA7C16A40C2260940CBD0D5BFA8287740B2593E3F33813D3F64E0DBBFBFC5A8404BF9B33EDDC75BBFE7AE95C0D7A191C0E99509C0E0659A3FC7928A3E5648A6409ED4A93F17602B3E3EBA8BC0931B01C04107AB4044D1DC3E08C1D740557C9740C05B0FC08C8980C08A4807C05CE28DBFBEC180402358984024C639C05834A33FA6E67BC0504E733F5C7A7B4042AD15C07DCFF8BF36C5A33F4018D4C0AC8A9C3FE70D37BF09D14A40D62DA53FD59A8040052DA13F3DE4DFC0D04CD7BF687A4BC0E1FF25C0B23C853F6F7F10C0D158B3402DFF19BFFC85C23EDE3786BFA470E23FEEF436C0E764BE3E7CAC153B0C6D23C0670832C0076A99BF4E230EBFFAAE04C048C14040DBF743BFE3279DBD9FEF5BC0062D8F40DF155B406E44C43F9F7EB63FDD790D4052849AC0FE1B743DC2CEE2C05FD7AFBEA7693AC0"> : tensor<1x125xf32>
    %1 = stablehlo.constant dense<2.21206093> : tensor<1xf32>
    return %0, %1 : tensor<1x125xf32>, tensor<1xf32>
  }
  func.func private @expected() -> tensor<1x125xf32> {
    %0 = stablehlo.constant dense<"0x68920D403CE2B340E8E68A3FECFE9D3FFF028EC027640EC09E2C86409E912B40A963A940D94493C0563F0BC00E1355C0A2C8AF3FFACDAEBFC63F23BFD1E712404DD954BFE56514C0C85F023F35AAE140CD57F1BF55917D40EE5530C00CA55C403DAE1B4023C92040FF21EB3F15E6213EC4CB54C0313E2F3ECC5B224004EB143F7089C23FE74B85C0D4D6413F286CEEBE34B9DD3F490251402AF955C0F35B873F6A5E97BF1748B13FFB84844029475B40FD1465C0615B5140F280333FA7C16A40C2260940CBD0D5BFA8287740B2593E3F33813D3F64E0DBBFBFC5A8404BF9B33EDDC75BBFE7AE95C0D7A191C0E99509C0E0659A3FC7928A3E5648A6409ED4A93F17602B3E3EBA8BC0931B01C04107AB4044D1DC3E08C1D740557C9740C05B0FC08C8980C08A4807C05CE28DBFBEC180402358984024C639C05834A33FA6E67BC0504E733F5C7A7B4042AD15C07DCFF8BF36C5A33F4018D4C0AC8A9C3FE70D37BF09D14A40D62DA53FD59A8040052DA13F3DE4DFC0D04CD7BF687A4BC0E1FF25C0B23C853F6F7F10C0D158B3402DFF19BFFC85C23EDE3786BFA470E23FEEF436C0E764BE3E7CAC153B0C6D23C0670832C0076A99BF4E230EBFFAAE04C048C14040DBF743BFE3279DBD9FEF5BC0062D8F40DF155B406E44C43F9F7EB63FDD790D4052849AC0FE1B743DC2CEE2C05FD7AFBEA7693AC0"> : tensor<1x125xf32>
    return %0 : tensor<1x125xf32>
  }
}

