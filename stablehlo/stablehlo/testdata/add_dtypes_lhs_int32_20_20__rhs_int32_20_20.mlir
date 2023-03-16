// RUN: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi32>, tensor<20x20xi32>)
    %1 = call @expected() : () -> tensor<20x20xi32>
    %2 = stablehlo.add %0#0, %0#1 : tensor<20x20xi32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi32>, tensor<20x20xi32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi32>, tensor<20x20xi32>) {
    %0 = stablehlo.constant dense<"0x0200000006000000040000000500000002000000FFFFFFFF01000000050000000300000002000000000000000000000000000000000000000200000000000000FAFFFFFFFDFFFFFFFBFFFFFF020000000200000000000000080000000600000000000000000000000000000000000000FEFFFFFFFFFFFFFF0200000001000000FEFFFFFF02000000FBFFFFFF0100000001000000FCFFFFFFFFFFFFFF0200000003000000000000000100000007000000FFFFFFFF01000000020000000300000000000000040000000000000000000000FFFFFFFF020000000000000001000000010000000200000001000000FCFFFFFF0400000000000000030000000200000002000000FFFFFFFF06000000FFFFFFFF00000000FEFFFFFFFFFFFFFF0200000007000000FEFFFFFFFEFFFFFF00000000FFFFFFFF01000000FFFFFFFF03000000FFFFFFFFFCFFFFFF03000000FFFFFFFFFFFFFFFF00000000040000000200000001000000FBFFFFFFFEFFFFFF00000000030000000200000000000000FBFFFFFF010000000100000001000000FEFFFFFFF7FFFFFF01000000F9FFFFFFFEFFFFFFFFFFFFFF010000000000000001000000FFFFFFFFFEFFFFFFFBFFFFFFFEFFFFFFFEFFFFFF0000000003000000FDFFFFFF01000000FFFFFFFFFFFFFFFFFEFFFFFF0200000005000000FEFFFFFF0000000004000000010000000400000002000000FCFFFFFF00000000000000000200000005000000030000000100000000000000FDFFFFFF000000000400000001000000010000000000000001000000000000000300000002000000FFFFFFFFFEFFFFFF03000000FBFFFFFF01000000FDFFFFFF030000000100000000000000FDFFFFFFFDFFFFFFFEFFFFFF01000000010000000100000004000000FFFFFFFF0000000000000000FDFFFFFF00000000FDFFFFFF000000000200000000000000000000000200000004000000FBFFFFFF00000000FDFFFFFF03000000FDFFFFFF030000000700000002000000FCFFFFFFFEFFFFFFFBFFFFFFFDFFFFFF0200000000000000FFFFFFFFFFFFFFFF020000000600000000000000010000000000000000000000FFFFFFFFFCFFFFFF00000000FDFFFFFF010000000000000001000000FFFFFFFFFFFFFFFF010000000000000007000000FFFFFFFFFCFFFFFF0000000000000000FFFFFFFFFBFFFFFFFEFFFFFFFEFFFFFF03000000FEFFFFFFFEFFFFFFFEFFFFFF0000000003000000FDFFFFFFFDFFFFFF0100000001000000FFFFFFFF00000000FDFFFFFF0100000004000000020000000000000002000000020000000000000004000000000000000400000002000000000000000100000003000000FBFFFFFF0100000000000000FBFFFFFF0100000000000000FCFFFFFFFDFFFFFF01000000030000000100000000000000FDFFFFFF0300000006000000FAFFFFFF0200000000000000F9FFFFFF0100000005000000FFFFFFFF01000000FFFFFFFF00000000FDFFFFFFFEFFFFFF0000000000000000FEFFFFFFFDFFFFFF00000000FFFFFFFF03000000FBFFFFFFFEFFFFFF0400000003000000010000000400000002000000FBFFFFFF020000000000000002000000000000000700000000000000050000000300000008000000030000000200000002000000FEFFFFFF00000000FDFFFFFF01000000FFFFFFFFFCFFFFFF030000000100000006000000000000000400000003000000000000000100000005000000FDFFFFFFFFFFFFFF050000000000000000000000000000000200000005000000FBFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF03000000040000000100000005000000FFFFFFFF0000000002000000FFFFFFFFFEFFFFFF0000000002000000FFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF0100000000000000F9FFFFFF05000000FFFFFFFFFCFFFFFFFEFFFFFF01000000050000000200000000000000FEFFFFFF0000000000000000FEFFFFFFFBFFFFFF0000000001000000FEFFFFFF02000000020000000000000000000000FBFFFFFF00000000000000000400000000000000000000000200000000000000FEFFFFFF01000000000000000300000002000000FFFFFFFFFFFFFFFF04000000FCFFFFFFFFFFFFFFFDFFFFFFFDFFFFFF020000000300000002000000FEFFFFFF0000000003000000FEFFFFFF0000000000000000FCFFFFFF040000000000000002000000FBFFFFFFFCFFFFFFFBFFFFFF0500000004000000"> : tensor<20x20xi32>
    %1 = stablehlo.constant dense<"0x01000000FDFFFFFF02000000FBFFFFFF01000000FFFFFFFF040000000200000000000000FFFFFFFF00000000FCFFFFFF010000000200000003000000FEFFFFFFFDFFFFFFFAFFFFFF0400000000000000FEFFFFFF000000000000000001000000FEFFFFFF030000000100000002000000FFFFFFFF05000000FFFFFFFFFDFFFFFF00000000FDFFFFFF0000000002000000FFFFFFFFFDFFFFFF00000000000000000000000001000000030000000000000001000000FFFFFFFF01000000FEFFFFFF000000000200000000000000FEFFFFFFFFFFFFFF050000000300000000000000FCFFFFFF0400000001000000FFFFFFFF0400000003000000FFFFFFFF00000000FFFFFFFF01000000020000000000000002000000FFFFFFFF020000000000000000000000040000000000000000000000FDFFFFFF0000000000000000FAFFFFFF0300000003000000010000000300000000000000FFFFFFFF0500000000000000FBFFFFFFFCFFFFFF00000000F9FFFFFF03000000FDFFFFFF0300000000000000000000000000000002000000FFFFFFFFFEFFFFFF00000000FCFFFFFFFFFFFFFF02000000020000000000000000000000FDFFFFFF000000000100000003000000FDFFFFFF0200000004000000FEFFFFFFFEFFFFFF010000000100000002000000010000000300000002000000FCFFFFFF01000000FDFFFFFF0000000001000000FFFFFFFF0500000005000000FFFFFFFFFCFFFFFFFEFFFFFFFEFFFFFFFFFFFFFF04000000FDFFFFFF03000000FEFFFFFF020000000200000000000000FEFFFFFF0100000005000000FAFFFFFF02000000FEFFFFFFFFFFFFFF000000000100000001000000FFFFFFFF0400000000000000FFFFFFFFFDFFFFFFFEFFFFFF00000000000000000300000000000000000000000500000003000000000000000000000003000000FEFFFFFFFDFFFFFFFFFFFFFF0300000003000000FEFFFFFFFDFFFFFF03000000FFFFFFFFFFFFFFFF0000000000000000FCFFFFFF00000000FEFFFFFF00000000FEFFFFFF05000000FFFFFFFF0100000001000000FCFFFFFF000000000000000001000000FEFFFFFFFFFFFFFFFCFFFFFFFFFFFFFFFBFFFFFF00000000FDFFFFFF00000000FCFFFFFF0000000006000000FFFFFFFF0200000003000000000000000100000003000000000000000000000003000000000000000400000002000000FEFFFFFF070000000100000001000000FFFFFFFF00000000FEFFFFFF0100000000000000FFFFFFFFFEFFFFFF0000000000000000000000000200000003000000050000000000000000000000FCFFFFFFFFFFFFFF0100000000000000FFFFFFFF01000000FFFFFFFF05000000FEFFFFFFFFFFFFFFFCFFFFFF0300000002000000FFFFFFFFFEFFFFFF05000000FFFFFFFF020000000400000000000000FFFFFFFF00000000040000000300000000000000000000000000000002000000FCFFFFFF00000000FFFFFFFF000000000000000004000000FCFFFFFF05000000FAFFFFFFFFFFFFFF00000000010000000000000001000000000000000000000002000000FCFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFEFFFFFF02000000010000000000000001000000FEFFFFFF010000000000000004000000FCFFFFFFFFFFFFFFFDFFFFFFFDFFFFFFFDFFFFFF05000000FFFFFFFFFFFFFFFFFDFFFFFF010000000200000000000000FEFFFFFF0000000002000000000000000400000002000000010000000000000003000000FFFFFFFF02000000040000000000000001000000FDFFFFFF000000000000000000000000FEFFFFFF01000000FDFFFFFF01000000FEFFFFFF060000000000000001000000FCFFFFFF01000000FEFFFFFF03000000FEFFFFFF0000000000000000FEFFFFFFFBFFFFFF0000000000000000020000000100000002000000FFFFFFFF0000000001000000FFFFFFFF00000000020000000000000000000000020000000100000003000000050000000300000001000000FDFFFFFF0000000000000000FEFFFFFFFCFFFFFFFEFFFFFF030000000300000000000000040000000100000000000000030000000000000000000000FFFFFFFF02000000000000000300000000000000FCFFFFFF040000000000000001000000FDFFFFFF0400000001000000FCFFFFFF00000000000000000200000000000000000000000000000002000000FCFFFFFFFEFFFFFF04000000"> : tensor<20x20xi32>
    return %0, %1 : tensor<20x20xi32>, tensor<20x20xi32>
  }
  func.func private @expected() -> tensor<20x20xi32> {
    %0 = stablehlo.constant dense<"0x0300000003000000060000000000000003000000FEFFFFFF0500000007000000030000000100000000000000FCFFFFFF010000000200000005000000FEFFFFFFF7FFFFFFF7FFFFFFFFFFFFFF0200000000000000000000000800000007000000FEFFFFFF030000000100000002000000FDFFFFFF0400000001000000FEFFFFFFFEFFFFFFFFFFFFFFFBFFFFFF0300000000000000F9FFFFFFFFFFFFFF020000000300000001000000040000000700000000000000000000000300000001000000000000000600000000000000FEFFFFFFFEFFFFFF070000000300000001000000FDFFFFFF0600000002000000FBFFFFFF08000000030000000200000002000000010000000000000008000000FFFFFFFF02000000FDFFFFFF01000000020000000700000002000000FEFFFFFF00000000FCFFFFFF01000000FFFFFFFFFDFFFFFF02000000FFFFFFFF0400000002000000FFFFFFFFFFFFFFFF0900000002000000FCFFFFFFF7FFFFFFFEFFFFFFF9FFFFFF06000000FFFFFFFF03000000FBFFFFFF010000000100000003000000FDFFFFFFF5FFFFFF01000000F5FFFFFFFDFFFFFF01000000030000000000000001000000FCFFFFFFFEFFFFFFFCFFFFFF01000000FBFFFFFF0200000007000000FBFFFFFFFFFFFFFF000000000000000000000000030000000800000000000000FCFFFFFF05000000FEFFFFFF0400000003000000FBFFFFFF0500000005000000010000000100000001000000FFFFFFFFFFFFFFFF01000000FDFFFFFF07000000FFFFFFFF030000000200000001000000FEFFFFFF0400000007000000F9FFFFFF0000000001000000FAFFFFFF01000000FEFFFFFF040000000000000004000000FDFFFFFFFCFFFFFFFBFFFFFFFFFFFFFF010000000100000007000000FFFFFFFF00000000050000000000000000000000FDFFFFFF0300000000000000FDFFFFFFFFFFFFFF0500000007000000F9FFFFFFFDFFFFFF0000000002000000FCFFFFFF0300000007000000FEFFFFFFFCFFFFFFFCFFFFFFFBFFFFFFFBFFFFFF07000000FFFFFFFF0000000000000000FEFFFFFF060000000000000002000000FEFFFFFFFFFFFFFFFBFFFFFFFBFFFFFFFBFFFFFFFDFFFFFFFEFFFFFF00000000FDFFFFFFFFFFFFFF0500000000000000020000000A000000FFFFFFFFFDFFFFFF0300000000000000FFFFFFFFFEFFFFFFFEFFFFFF0200000005000000FCFFFFFF05000000FFFFFFFF0100000002000000FDFFFFFFFBFFFFFF0200000001000000FEFFFFFFFEFFFFFFFDFFFFFF0100000004000000040000000300000007000000020000000000000000000000FFFFFFFF0500000002000000FFFFFFFF020000000200000000000000FFFFFFFFFFFFFFFFF7FFFFFF0400000002000000FBFFFFFFFBFFFFFF06000000020000000300000004000000FDFFFFFF0200000006000000FEFFFFFF0500000000000000F9FFFFFF0100000007000000FBFFFFFF01000000FEFFFFFF00000000FDFFFFFF02000000FCFFFFFF05000000F8FFFFFFFCFFFFFF000000000000000003000000FCFFFFFFFEFFFFFF0400000005000000FDFFFFFF0200000001000000FAFFFFFFFFFFFFFFFFFFFFFF000000000200000008000000000000000600000001000000090000000300000006000000FEFFFFFFFDFFFFFFFDFFFFFFFAFFFFFFFEFFFFFF04000000FBFFFFFF02000000FEFFFFFF070000000200000004000000010000000000000003000000050000000100000001000000060000000000000003000000FFFFFFFF0400000009000000FBFFFFFF00000000F9FFFFFFFFFFFFFF0300000004000000FFFFFFFF06000000FCFFFFFF010000000000000005000000FEFFFFFF01000000FEFFFFFF00000000FDFFFFFF00000000FDFFFFFF0100000000000000F7FFFFFF00000000FFFFFFFFFCFFFFFF0000000002000000070000000100000000000000FFFFFFFFFFFFFFFF0000000000000000FBFFFFFF0000000003000000FFFFFFFF05000000070000000300000001000000F8FFFFFF000000000000000002000000FCFFFFFFFEFFFFFF0500000003000000FEFFFFFF05000000010000000300000005000000FFFFFFFFFFFFFFFF03000000FEFFFFFFFFFFFFFF00000000FDFFFFFFFEFFFFFF0700000002000000FFFFFFFFFDFFFFFF07000000FFFFFFFFFCFFFFFF00000000FCFFFFFF060000000000000002000000FBFFFFFFFEFFFFFFF7FFFFFF0300000008000000"> : tensor<20x20xi32>
    return %0 : tensor<20x20xi32>
  }
}
