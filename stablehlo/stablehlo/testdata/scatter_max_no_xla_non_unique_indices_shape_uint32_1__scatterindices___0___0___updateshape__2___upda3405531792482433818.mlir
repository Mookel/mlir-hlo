// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<1xui32>, tensor<2xui32>)
    %2 = call @expected() : () -> tensor<1xui32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui32>, %arg1: tensor<ui32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<ui32>
      stablehlo.return %5 : tensor<ui32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<inserted_window_dims = [0], scatter_dims_to_operand_dims = [0], index_vector_dim = 1>} : (tensor<1xui32>, tensor<2x1xi32>, tensor<2xui32>) -> tensor<1xui32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1xui32>, tensor<1xui32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1xui32>, tensor<2xui32>) {
    %0 = stablehlo.constant dense<3> : tensor<1xui32>
    %1 = stablehlo.constant dense<[0, 3]> : tensor<2xui32>
    return %0, %1 : tensor<1xui32>, tensor<2xui32>
  }
  func.func private @expected() -> tensor<1xui32> {
    %0 = stablehlo.constant dense<3> : tensor<1xui32>
    return %0 : tensor<1xui32>
  }
}

