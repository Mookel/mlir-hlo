// RUN: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xui16>, tensor<20x20xui16>)
    %1 = call @expected() : () -> tensor<20x20xui16>
    %2 = stablehlo.add %0#0, %0#1 : tensor<20x20xui16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xui16>, tensor<20x20xui16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xui16>, tensor<20x20xui16>) {
    %0 = stablehlo.constant dense<"0x00000000040003000100000000000000060000000000020008000200030002000000030000000200000000000100030002000100010001000200000000000300020001000000020003000A0002000500020004000200030002000500020000000000010003000000010000000000020000000100000004000300010000000300040001000000000000000500000003000300030000000200040003000300020000000400000000000700010000000400010000000500010000000100030004000000020001000100020004000200000001000100020001000100000002000100030000000200020000000300010002000100060001000000070003000600000002000300040002000100020003000200000001000100000003000400020004000500010000000000000001000100000004000100010002000100010002000000010004000000000000000100060000000100030000000300010003000300020003000100020000000300000003000400060003000000000003000300010000000300030000000000010001000000000002000100000001000300050000000100000003000100000005000000040000000200020004000100010000000200000001000100010000000200020005000000000003000100050001000200010004000000000003000000080006000100020001000100000001000400020004000100000000000200020004000200030004000100000001000200020001000300000000000500000001000300000003000100010004000400010004000000000006000000000002000100020004000400010001000000020005000200020000000500030006000600020002000200000004000200020001000200000001000100010001000100020000000200030002000000010000000000000000000000040002000000000001000300040000000300030006000100030001000000000000000100010003000200030000000400010000000000000004000100020000000000030008000000020000000100070001000200000000000300000000000200040003000300010000000500050000000300010002000300020002000100020000000100"> : tensor<20x20xui16>
    %1 = stablehlo.constant dense<"0x0300040001000000050000000100000004000000020000000100010000000200030006000400030003000700000001000300040000000000000001000800010004000200010003000100050001000200000001000200020001000200010001000200050000000300080001000100000001000400000002000000080002000000020001000300020002000300040005000200030005000300010000000000020002000000050000000100010002000200020002000400000001000000030002000000040006000200020002000600020002000100000000000000010000000300030001000700010000000300010001000000010004000300020003000200020003000200010002000200000004000200010000000200010002000500050000000000010002000200010000000300020001000200010000000000040002000000040003000100000003000100010002000500010000000100010000000000020001000000000000000100020000000100020001000000000001000100030000000600040001000200000000000200040005000300020002000300070003000300000000000100010001000500000000000100000004000400000002000300020003000200010003000100020001000500000000000200030000000200010002000100020004000700050003000000000001000400000000000700030000000200000001000300030001000300040000000300010000000000020001000100010004000600040003000100050002000300000001000500000000000400000000000100020000000200030003000400030001000100020001000000010001000400000002000000010006000200030004000000010002000100010001000000010000000000000000000100010001000100000001000000010002000200010000000400040002000500020000000300020000000100010001000300000003000500010002000100030000000300020001000200010002000000010007000000070000000300000005000000030003000400030003000200040004000100010002000100020003000400020000000100020003000000010000000300030001000100"> : tensor<20x20xui16>
    return %0, %1 : tensor<20x20xui16>, tensor<20x20xui16>
  }
  func.func private @expected() -> tensor<20x20xui16> {
    %0 = stablehlo.constant dense<"0x030004000500030006000000010000000A0000000200020009000300030004000300090004000500030007000100040005000500010001000200010008000400060003000100050004000F00030007000200050004000500030007000300010002000600030003000900010001000200010005000000060003000900020003000600020003000200020008000400080005000600050005000500030003000400020004000500000008000200020006000300020009000100010001000600060000000600070003000400060008000200030002000200010001000100020004000600010009000300000006000200030001000700050003000900060008000200050005000500040003000200070004000100010003000100050009000700040005000200020002000100010004000200050003000200020001000500040000000500070001000000030002000700020006000400000004000200030003000400040001000200000004000200030005000800040000000000040004000400000009000700010002000100010002000400070004000200030006000C00030004000000030002000100060005000400000003000200080005000100020005000200040003000200030003000400060005000000030003000800010004000200060001000200070007000D0009000100020002000500000001000B00050004000300000001000500050005000500070004000400010001000200040002000400010004000B000400040004000500050004000100050009000100040004000000060001000200020003000500070008000400020001000400060002000300010009000300080006000300080004000300080002000300030003000100020001000200010001000200000003000400030001000100010000000100020002000500020004000400030008000600000006000500060002000400020003000000030006000200050003000600000007000300010002000100060001000300070000000A00080003000200050001000A0004000600030003000500040004000300050005000400030003000900070000000400030005000300030002000400050001000200"> : tensor<20x20xui16>
    return %0 : tensor<20x20xui16>
  }
}
