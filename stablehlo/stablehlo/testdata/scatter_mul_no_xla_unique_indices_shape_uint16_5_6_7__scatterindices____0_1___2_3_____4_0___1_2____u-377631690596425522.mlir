// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<5x2x2xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2x2xi32>, tensor<5x2x2xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<5x2x2xui16>) {
    %0 = stablehlo.constant dense<"0x000002000300000005000100000006000600010002000300030001000400020002000300010006000000010004000000010000000000020001000100010002000100010001000100030002000100050001000500000000000200000000000000030003000300000001000100010002000000010000000400020002000100010000000000020000000400030002000800000000000100000001000100000003000500020001000300000001000400000003000000010000000000020002000600040000000200010001000400030002000100050000000100030000000100010000000000020002000200020001000000000000000300060001000000000000000000010000000000020001000000020003000400010000000300000004000300010000000400010000000500000000000300000000000100000002000000030005000000020002000600020002000100020001000500030001000400060005000200030000000100010000000100030001000200000003000300000002000000000002000500000000000100020000000200050001000600000004000300030008000300"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<[[[2, 0], [5, 1]], [[5, 1], [1, 5]], [[3, 4], [0, 1]], [[0, 0], [2, 1]], [[5, 3], [1, 1]]]> : tensor<5x2x2xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<5x2x2xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x000004000300000005000100000006000600010002000300030001000400020002000000010006000000010004000000010000000000020005000100010002000100010001000100030002000100050001000500000000000200000000000000030003000300000001000100010002000000010000000400020002000100010000000000020000000400030002000800000000000100000001000100000003000500020001000300000003000400000003000000010000000000020002000600040000000200010001001000030002000100050000000100030000000100010000000000020002000200020001000000000000000300060001000000000000000000010000000000020001000000020003000400010000000300000004000000010000000400010000000500000000000300000000000100000002000000030005000000020002000600020002000100020005000500030001000400060005000200030000000100010000000100030001000600000003000300000002000000000002000500000000000100020000000200050001000600000004000300030008000300"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}

