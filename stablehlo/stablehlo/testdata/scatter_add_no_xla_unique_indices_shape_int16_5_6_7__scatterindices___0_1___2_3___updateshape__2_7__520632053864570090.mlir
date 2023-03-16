// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi16>, tensor<2x7xi16>)
    %2 = call @expected() : () -> tensor<5x6x7xi16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i16>, %arg1: tensor<i16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<i16>
      stablehlo.return %5 : tensor<i16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xi16>, tensor<2x2xi32>, tensor<2x7xi16>) -> tensor<5x6x7xi16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi16>, tensor<5x6x7xi16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi16>, tensor<2x7xi16>) {
    %0 = stablehlo.constant dense<"0x0000FCFF000003000100FFFF0700FCFFFEFFFBFF0000FDFF0100FFFF0400040002000000FDFFFDFF000000000000FDFF0000010001000000FCFF0500000001000300010001000000FCFF0000FCFF0200010000000200FFFF00000100FCFFFFFF010001000000000000000500010002000300FBFFFCFFFEFFFEFF0100FEFF0000FBFF00000000010000000100000004000200FEFF05000100FEFF0600FEFFFCFF01000000000003000600FBFFFEFFFDFF020003000100FEFFFEFFFFFF0200FEFF04000000000004000000F8FF0100070001000200FDFF0100F8FF00000200FEFF0400010001000400040000000000FEFF000000000000FCFF0000FDFF010003000400FEFF05000000FFFF02000200FAFF0000FBFF0200010000000000FEFFF9FF00000100FDFF000002000000000000000300FEFF020000000000FFFFFEFF050000000000FDFF0400040004000300FEFF00000400000002000300FEFF02000000010001000100FFFF0000FFFFFDFF00000500010004000300FCFF0000020000000000000000000100FDFF0400FFFF0100FFFF03000300FBFF010000000000FFFFFFFFFDFF"> : tensor<5x6x7xi16>
    %1 = stablehlo.constant dense<[[4, 3, 1, 0, -2, -1, -2], [7, 2, 2, 5, 0, -1, 0]]> : tensor<2x7xi16>
    return %0, %1 : tensor<5x6x7xi16>, tensor<2x7xi16>
  }
  func.func private @expected() -> tensor<5x6x7xi16> {
    %0 = stablehlo.constant dense<"0x0000FCFF000003000100FFFF070000000100FCFF0000FBFF0000FDFF0400040002000000FDFFFDFF000000000000FDFF0000010001000000FCFF0500000001000300010001000000FCFF0000FCFF0200010000000200FFFF00000100FCFFFFFF010001000000000000000500010002000300FBFFFCFFFEFFFEFF0100FEFF0000FBFF00000000010000000100000004000200FEFF05000100FEFF0600FEFFFCFF01000000000003000600FBFFFEFFFDFF020003000100FEFFFEFFFFFF0200FEFF04000000000004000000F8FF0100070001000900FFFF0300FDFF00000100FEFF0400010001000400040000000000FEFF000000000000FCFF0000FDFF010003000400FEFF05000000FFFF02000200FAFF0000FBFF0200010000000000FEFFF9FF00000100FDFF000002000000000000000300FEFF020000000000FFFFFEFF050000000000FDFF0400040004000300FEFF00000400000002000300FEFF02000000010001000100FFFF0000FFFFFDFF00000500010004000300FCFF0000020000000000000000000100FDFF0400FFFF0100FFFF03000300FBFF010000000000FFFFFFFFFDFF"> : tensor<5x6x7xi16>
    return %0 : tensor<5x6x7xi16>
  }
}

