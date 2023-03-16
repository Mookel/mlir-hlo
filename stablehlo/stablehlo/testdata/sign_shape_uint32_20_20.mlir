// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xui32>
    %1 = call @expected() : () -> tensor<20x20xui32>
    %2 = stablehlo.constant dense<0> : tensor<ui32>
    %3 = stablehlo.broadcast_in_dim %2, dims = [] : (tensor<ui32>) -> tensor<20x20xui32>
    %4 = stablehlo.compare  EQ, %0, %3,  UNSIGNED : (tensor<20x20xui32>, tensor<20x20xui32>) -> tensor<20x20xi1>
    %5 = stablehlo.constant dense<0> : tensor<ui32>
    %6 = stablehlo.broadcast_in_dim %5, dims = [] : (tensor<ui32>) -> tensor<20x20xui32>
    %7 = stablehlo.constant dense<1> : tensor<ui32>
    %8 = stablehlo.broadcast_in_dim %7, dims = [] : (tensor<ui32>) -> tensor<20x20xui32>
    %9 = stablehlo.select %4, %6, %8 : tensor<20x20xi1>, tensor<20x20xui32>
    %10 = stablehlo.custom_call @check.eq(%9, %1) : (tensor<20x20xui32>, tensor<20x20xui32>) -> tensor<i1>
    return %10 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xui32> {
    %0 = stablehlo.constant dense<"0x02000000030000000200000000000000000000000100000000000000000000000100000000000000000000000200000002000000040000000000000004000000000000000200000001000000010000000300000002000000000000000000000000000000010000000300000000000000000000000000000002000000020000000200000000000000040000000000000001000000000000000000000003000000000000000000000002000000010000000400000004000000030000000200000005000000050000000600000000000000050000000200000004000000020000000000000002000000020000000300000001000000000000000200000003000000070000000100000001000000020000000100000001000000040000000000000007000000020000000500000003000000000000000100000005000000010000000400000003000000010000000200000000000000060000000100000000000000010000000600000002000000000000000300000000000000040000000000000000000000000000000100000002000000030000000200000004000000000000000000000002000000000000000000000000000000030000000400000002000000020000000000000000000000020000000700000000000000000000000200000002000000010000000400000000000000010000000200000002000000030000000000000002000000060000000200000000000000020000000600000002000000000000000100000005000000010000000100000002000000010000000000000001000000040000000500000004000000000000000200000001000000000000000200000003000000020000000300000000000000010000000200000003000000030000000400000002000000000000000200000001000000020000000000000002000000020000000000000000000000030000000200000001000000010000000700000000000000010000000000000006000000070000000400000001000000030000000200000001000000000000000600000004000000060000000000000001000000010000000100000002000000010000000100000001000000050000000000000002000000000000000100000001000000010000000000000004000000010000000000000000000000030000000200000000000000020000000000000000000000030000000200000000000000000000000300000000000000010000000000000003000000000000000000000001000000030000000100000000000000000000000100000000000000020000000100000003000000030000000200000002000000010000000200000000000000020000000100000000000000000000000200000000000000020000000400000002000000040000000000000003000000010000000000000003000000000000000100000005000000000000000200000003000000020000000200000000000000010000000200000002000000010000000200000000000000020000000100000001000000020000000500000004000000020000000500000003000000040000000600000001000000060000000100000003000000000000000500000003000000010000000200000001000000010000000000000005000000000000000400000004000000010000000100000000000000000000000100000001000000030000000000000004000000020000000400000000000000010000000100000002000000040000000100000001000000050000000100000004000000000000000100000004000000000000000400000004000000020000000200000006000000010000000300000003000000000000000200000000000000020000000100000004000000030000000000000003000000040000000400000000000000020000000300000001000000030000000400000000000000000000000400000004000000030000000400000005000000010000000200000000000000000000000500000002000000010000000200000001000000010000000500000002000000020000000600000002000000010000000300000000000000010000000200000003000000000000000000000003000000010000000100000002000000000000000200000001000000030000000200000004000000040000000000000004000000010000000400000003000000010000000000000000000000"> : tensor<20x20xui32>
    return %0 : tensor<20x20xui32>
  }
  func.func private @expected() -> tensor<20x20xui32> {
    %0 = stablehlo.constant dense<"0x01000000010000000100000000000000000000000100000000000000000000000100000000000000000000000100000001000000010000000000000001000000000000000100000001000000010000000100000001000000000000000000000000000000010000000100000000000000000000000000000001000000010000000100000000000000010000000000000001000000000000000000000001000000000000000000000001000000010000000100000001000000010000000100000001000000010000000100000000000000010000000100000001000000010000000000000001000000010000000100000001000000000000000100000001000000010000000100000001000000010000000100000001000000010000000000000001000000010000000100000001000000000000000100000001000000010000000100000001000000010000000100000000000000010000000100000000000000010000000100000001000000000000000100000000000000010000000000000000000000000000000100000001000000010000000100000001000000000000000000000001000000000000000000000000000000010000000100000001000000010000000000000000000000010000000100000000000000000000000100000001000000010000000100000000000000010000000100000001000000010000000000000001000000010000000100000000000000010000000100000001000000000000000100000001000000010000000100000001000000010000000000000001000000010000000100000001000000000000000100000001000000000000000100000001000000010000000100000000000000010000000100000001000000010000000100000001000000000000000100000001000000010000000000000001000000010000000000000000000000010000000100000001000000010000000100000000000000010000000000000001000000010000000100000001000000010000000100000001000000000000000100000001000000010000000000000001000000010000000100000001000000010000000100000001000000010000000000000001000000000000000100000001000000010000000000000001000000010000000000000000000000010000000100000000000000010000000000000000000000010000000100000000000000000000000100000000000000010000000000000001000000000000000000000001000000010000000100000000000000000000000100000000000000010000000100000001000000010000000100000001000000010000000100000000000000010000000100000000000000000000000100000000000000010000000100000001000000010000000000000001000000010000000000000001000000000000000100000001000000000000000100000001000000010000000100000000000000010000000100000001000000010000000100000000000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000000000000100000001000000010000000100000001000000010000000000000001000000000000000100000001000000010000000100000000000000000000000100000001000000010000000000000001000000010000000100000000000000010000000100000001000000010000000100000001000000010000000100000001000000000000000100000001000000000000000100000001000000010000000100000001000000010000000100000001000000000000000100000000000000010000000100000001000000010000000000000001000000010000000100000000000000010000000100000001000000010000000100000000000000000000000100000001000000010000000100000001000000010000000100000000000000000000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000000000000010000000100000001000000000000000000000001000000010000000100000001000000000000000100000001000000010000000100000001000000010000000000000001000000010000000100000001000000010000000000000000000000"> : tensor<20x20xui32>
    return %0 : tensor<20x20xui32>
  }
}
