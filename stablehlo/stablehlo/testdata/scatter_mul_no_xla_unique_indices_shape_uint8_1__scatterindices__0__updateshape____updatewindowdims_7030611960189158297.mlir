// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1xui8>, tensor<ui8>)
    %2 = call @expected() : () -> tensor<1xui8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui8>, %arg1: tensor<ui8>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<ui8>
      stablehlo.return %5 : tensor<ui8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<inserted_window_dims = [0], scatter_dims_to_operand_dims = [0]>, unique_indices = true} : (tensor<1xui8>, tensor<1xi32>, tensor<ui8>) -> tensor<1xui8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1xui8>, tensor<1xui8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1xui8>, tensor<ui8>) {
    %0 = stablehlo.constant dense<1> : tensor<1xui8>
    %1 = stablehlo.constant dense<1> : tensor<ui8>
    return %0, %1 : tensor<1xui8>, tensor<ui8>
  }
  func.func private @expected() -> tensor<1xui8> {
    %0 = stablehlo.constant dense<1> : tensor<1xui8>
    return %0 : tensor<1xui8>
  }
}

