// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x4xui32>, tensor<3x2x4xui32>)
    %2 = call @expected() : () -> tensor<3x5x4xui32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui32>, %arg1: tensor<ui32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<ui32>
      stablehlo.return %5 : tensor<ui32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 2], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 1>} : (tensor<3x5x4xui32>, tensor<2x1xi32>, tensor<3x2x4xui32>) -> tensor<3x5x4xui32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x4xui32>, tensor<3x5x4xui32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x4xui32>, tensor<3x2x4xui32>) {
    %0 = stablehlo.constant dense<[[[0, 2, 0, 1], [2, 1, 2, 1], [0, 6, 0, 1], [0, 4, 4, 3], [2, 0, 1, 4]], [[0, 6, 4, 0], [2, 2, 4, 1], [1, 2, 1, 5], [0, 2, 1, 0], [0, 3, 1, 0]], [[2, 1, 0, 1], [2, 4, 5, 2], [2, 3, 0, 3], [2, 3, 0, 0], [2, 7, 2, 3]]]> : tensor<3x5x4xui32>
    %1 = stablehlo.constant dense<[[[4, 3, 1, 2], [2, 3, 6, 3]], [[2, 2, 0, 0], [1, 5, 2, 3]], [[2, 3, 3, 2], [0, 1, 4, 1]]]> : tensor<3x2x4xui32>
    return %0, %1 : tensor<3x5x4xui32>, tensor<3x2x4xui32>
  }
  func.func private @expected() -> tensor<3x5x4xui32> {
    %0 = stablehlo.constant dense<[[[0, 2, 0, 1], [2, 1, 1, 1], [0, 6, 0, 1], [0, 4, 4, 3], [2, 0, 1, 4]], [[0, 6, 4, 0], [1, 2, 0, 0], [1, 2, 1, 5], [0, 2, 1, 0], [0, 3, 1, 0]], [[2, 1, 0, 1], [0, 1, 3, 1], [2, 3, 0, 3], [2, 3, 0, 0], [2, 7, 2, 3]]]> : tensor<3x5x4xui32>
    return %0 : tensor<3x5x4xui32>
  }
}

