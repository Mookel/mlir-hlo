// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi16>, tensor<5x2x2x7xi16>)
    %2 = call @expected() : () -> tensor<5x6x7xi16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i16>, %arg1: tensor<i16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<i16>
      stablehlo.return %5 : tensor<i16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi16>, tensor<2x2x1xi32>, tensor<5x2x2x7xi16>) -> tensor<5x6x7xi16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi16>, tensor<5x6x7xi16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi16>, tensor<5x2x2x7xi16>) {
    %0 = stablehlo.constant dense<"0xFDFFFDFFFEFF000000000200FEFFFFFF00000300010005000100FDFF0200FEFFFFFF020001000000FFFFFDFF0000FFFFFEFFFEFFFCFF0100FAFF00000200FEFFFEFF0000FEFFFEFF0400FFFFFEFF0000000007000400FEFF00000200FDFF000001000200FBFFFFFF0400FDFF0100080000000300FEFFFAFF000003000000020002000200FEFF0300FDFFFDFF000000000300FFFF00000000FFFF02000100FEFF0100FDFF0000FFFF00000000FBFF0200FFFF0300FFFF020002000000FFFFFDFFFFFF0300FDFF02000000FFFF020000000300000000000000FEFFFAFF0100010000000300FFFF010002000000060000000600FDFFFFFF0000FDFF0200FFFF02000600FFFF0400FEFF0000FAFFFDFF060000000300FEFFFCFF0500FEFF0500020004000300FFFFFDFF0000FFFFFBFFFCFFFFFF00000000FDFF0000FAFF0300010004000200F9FF0200FBFFFFFFFDFFFFFF02000000000000000400F8FFFEFF0000FFFFFEFFFFFF000000000000FDFF01000000FEFF0200FFFFFBFF00000400FEFFFDFFFFFF00000000FDFF0000FEFF0000000002000500FEFFFFFF0300FAFF0000FAFFFFFF"> : tensor<5x6x7xi16>
    %1 = stablehlo.constant dense<"0xFFFFFAFF0100000000000600FDFFFDFF0300FFFF0100010000000000FEFF030000000000000001000500FFFF02000100FEFF0500FFFF0300FFFF0000FBFF01000300FAFF0100FAFFFEFF00000100FEFFFFFFFEFF00000200FEFFFEFF020000000300FAFF00000000FFFF00000500FDFF010001000200FDFF010002000300FDFFFEFF0200060000000100FFFF040001000000FFFF0100FEFF0000FEFF030000000000FCFFFEFFFEFF0000FDFF01000000FEFF0000FDFFFFFF02000400000003000000FEFF0200FFFF0000FEFFFFFF01000100FDFF0000FDFFFDFF00000300FDFF0000FFFF0000FFFFFFFF0200000000000200FCFFFDFFFEFF00000200FFFF0000FDFFFFFF0400FFFF0000FEFF0500FEFF000000000000FFFF"> : tensor<5x2x2x7xi16>
    return %0, %1 : tensor<5x6x7xi16>, tensor<5x2x2x7xi16>
  }
  func.func private @expected() -> tensor<5x6x7xi16> {
    %0 = stablehlo.constant dense<"0x03001200FEFF000000000C00060003000000FDFF0100050000000000FCFFFAFF0000000000000000FBFF03000000FFFF0400F6FF04000300FAFF00000200FEFFFEFF0000FEFFFEFF0400FFFFFEFF000000000700FCFF000000000200F7FF00000100F4FF0A00000004000600FFFFF0FF0000060004000C00000000000000F4FF0000000002000000F1FF0900000000000300FFFF00000000FFFF02000100FEFF0100FDFF0000FFFF00000000F6FFFAFFFFFF0600FDFFFAFFFCFF0000FAFF0000FFFFFDFFF4FF02000000010002000000000000000000000000001800FEFFFEFF00000300FFFF010002000000060000000600FDFFFFFF0000FDFF02000000FAFF06000000F8FF000000000600FAFF180000000900000008000A0002000000FCFFFCFF0300FFFF0900000003000F000000FDFF00000000FDFF0000FAFF0300010004000200F9FF0200FBFFFFFFFDFFFFFF0000000000000000FCFFF0FF00000000FEFF0800030000000000000003000000000002000800010000000000140004000000000000000000FDFF0000FEFF0000000002000500FEFFFFFF0300FAFF0000FAFFFFFF"> : tensor<5x6x7xi16>
    return %0 : tensor<5x6x7xi16>
  }
}

