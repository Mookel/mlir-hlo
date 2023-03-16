// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[0, 4]> : tensor<2xi32>
    %1:2 = call @inputs() : () -> (tensor<4x2x3x5xui32>, tensor<4x3xui32>)
    %2 = call @expected() : () -> tensor<4x2x3x5xui32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui32>, %arg1: tensor<ui32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<ui32>
      stablehlo.return %5 : tensor<ui32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1, 3], scatter_dims_to_operand_dims = [1, 3]>, unique_indices = true} : (tensor<4x2x3x5xui32>, tensor<2xi32>, tensor<4x3xui32>) -> tensor<4x2x3x5xui32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<4x2x3x5xui32>, tensor<4x2x3x5xui32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<4x2x3x5xui32>, tensor<4x3xui32>) {
    %0 = stablehlo.constant dense<"0x020000000200000000000000030000000200000004000000000000000600000005000000000000000100000000000000030000000700000000000000020000000200000000000000020000000100000002000000020000000200000000000000000000000100000005000000000000000200000000000000010000000300000001000000010000000000000001000000020000000200000000000000030000000000000000000000030000000000000000000000020000000200000003000000010000000300000001000000050000000300000004000000000000000000000000000000010000000100000002000000020000000100000000000000010000000400000002000000000000000000000002000000010000000200000004000000010000000000000000000000020000000200000006000000030000000000000000000000050000000500000006000000000000000200000003000000000000000100000001000000010000000000000001000000020000000200000001000000020000000000000002000000010000000100000002000000050000000200000002000000030000000300000001000000000000000400000000000000010000000100000000000000030000000200000000000000040000000500000002000000"> : tensor<4x2x3x5xui32>
    %1 = stablehlo.constant dense<[[0, 3, 2], [5, 7, 3], [4, 0, 1], [3, 0, 1]]> : tensor<4x3xui32>
    return %0, %1 : tensor<4x2x3x5xui32>, tensor<4x3xui32>
  }
  func.func private @expected() -> tensor<4x2x3x5xui32> {
    %0 = stablehlo.constant dense<"0x020000000200000000000000030000000000000004000000000000000600000005000000000000000100000000000000030000000700000000000000020000000200000000000000020000000100000002000000020000000200000000000000000000000100000005000000000000000200000000000000010000000300000001000000010000000000000001000000020000000200000000000000150000000000000000000000030000000000000000000000020000000200000003000000010000000300000001000000050000000300000004000000000000000000000000000000010000000100000002000000020000000100000000000000010000001000000002000000000000000000000002000000000000000200000004000000010000000000000000000000020000000200000006000000030000000000000000000000050000000500000006000000000000000200000003000000000000000100000001000000010000000000000001000000020000000600000001000000020000000000000002000000000000000100000002000000050000000200000002000000030000000300000001000000000000000400000000000000010000000100000000000000030000000200000000000000040000000500000002000000"> : tensor<4x2x3x5xui32>
    return %0 : tensor<4x2x3x5xui32>
  }
}

