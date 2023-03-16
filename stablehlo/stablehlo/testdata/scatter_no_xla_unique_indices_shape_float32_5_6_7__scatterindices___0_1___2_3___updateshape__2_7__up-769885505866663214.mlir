// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<2x7xf32>)
    %2 = call @expected() : () -> tensor<5x6x7xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      stablehlo.return %arg1 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xf32>, tensor<2x2xi32>, tensor<2x7xf32>) -> tensor<5x6x7xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32>, tensor<2x7xf32>) {
    %0 = stablehlo.constant dense<"0xD58EB3BE156162BF3CEA4E4051FB63400455743F1B8C72BFAD7CCA3F1841493FFAE70E4194C6C0C021549FBF3B24493FAD610A3F0BB6D8BF51952640C14F103FA17F633FE5B0BEBF2C07CFBFCE04F9BE746CB9409A983D4097C5A9402DB8AE409715DABF10A44FC03BF601BF441076C0419666C0FC678CBFACD5C93E557E093E2FC1F3BE0B6A7A3F6CB4753EE3EB7FC019E5F0BF1A8CC0BF1C1ADF3EDC4FE13E6F8EF0BE67ECB4BFFA563C40011605BF3B94A640E98C2BC01C4612402858D9BE5C67733F90C29A4035418AC01968AC3F93967ABFC933803E3C05E5BFDD62E93FDE39CEBE91259B406A3B19C0C13FEE3FF0122240F85C50402E94893FB66E05C095072B4000C54640F9A004C0D6AD0A3F8F95DD3FD91383C00D92873EEFD5B0BF2A5604C06FF0DCBD882C89BE0840B1C0D713CBBFB221B1BFCA47513F581EE3BF4EEED6BF7076283FC288994008980C402DB3B9BFFE710BC09BB7843F9ACD6CBF64378240D3C219401940D5401212153FBF2C1FC0EA91E6BEAA6FC6BE66E675C0E76EE73F75AB6EBF460A2D3EB723BC3E8AE9FB3FA35110C0959EC23FBA38353F5A9A32403094B7BF0C06833F2A4A2DC0DDC58BBE2763E0BF5536AB40BE88173F1F1E8BC0FB8608C0362FCB3F5A93393F8BD583BF9840B83FBD4283BF98F0473FC1390040565AEBBF8416ED400519A9C0FEF68E4026E9B73FD3B50AC02411723F63BE85402DF960BF476E91405127B3BF206FE43FD583F5BFF02C8D409F32BFBE57133CBF693D16BF5AC206C021EA74BC71D73540A2004E3FED967C40CD5693C0AAD501C073B218405C25653F9519BD3F360353C0ABB8DA3F103897C0167836BFFF5F573E3316CEBFCFCA72BF35538640AE4B64C0B79655BF30772CC0D96529BF01AB94BFDF51923E60DBCA3F9718E6409697FCBE12146B402479193F55F513C0913169C0378724BEA9431241D8C32B3FEE2359402A6C9D40484542BF6E9E064068AB25400ED37BC02E89DD4004FF773D9975CD3F693B904008F2B8C0BF3D2D3F5182B93FF0B15940F93C39C0070A0240AD39833F139E55C0CB86434014ADA8405FF89F40C2FC4AC0EE0A463F76687A407F9FA5C03F23D2C0A16903416B1C1DBE4BEB26BFC2EC664064FD883F08D9D5BF47EF0B404F848ABF6BEB0FC07B938C3F95F904404E34FE3F"> : tensor<5x6x7xf32>
    %1 = stablehlo.constant dense<[[-3.12693405, 0.533375084, -0.480674505, 0.555456161, 6.14491224, -1.21969569, 4.5974946], [0.0123986574, -3.88335967, -1.03441834, 1.73412406, -3.37098098, -1.43496692, -1.18785357]]> : tensor<2x7xf32>
    return %0, %1 : tensor<5x6x7xf32>, tensor<2x7xf32>
  }
  func.func private @expected() -> tensor<5x6x7xf32> {
    %0 = stablehlo.constant dense<"0xD58EB3BE156162BF3CEA4E4051FB63400455743F1B8C72BFAD7CCA3FB01F48C0458B083FF81AF6BE60320E3F1FA3C440FD1E9CBFAD1E934051952640C14F103FA17F633FE5B0BEBF2C07CFBFCE04F9BE746CB9409A983D4097C5A9402DB8AE409715DABF10A44FC03BF601BF441076C0419666C0FC678CBFACD5C93E557E093E2FC1F3BE0B6A7A3F6CB4753EE3EB7FC019E5F0BF1A8CC0BF1C1ADF3EDC4FE13E6F8EF0BE67ECB4BFFA563C40011605BF3B94A640E98C2BC01C4612402858D9BE5C67733F90C29A4035418AC01968AC3F93967ABFC933803E3C05E5BFDD62E93FDE39CEBE91259B406A3B19C0C13FEE3FF0122240F85C50402E94893FB66E05C095072B4000C54640F9A004C0D6AD0A3F8F95DD3FD91383C00D92873EEFD5B0BF2A5604C06FF0DCBD882C89BE0840B1C0D713CBBFB221B1BFCA47513F581EE3BF4EEED6BF7076283FC288994008980C402DB3B9BFFE710BC09BB7843F9ACD6CBF64378240D3C219401940D5401212153FBF2C1FC0EA91E6BEAA6FC6BE66E675C0E76EE73F75AB6EBF460A2D3EB723BC3E8AE9FB3FA35110C0959EC23FBA38353F5A9A3240BD234B3CF78878C0D26784BFC7F7DD3F27BE57C0FFACB7BF960B98BF1F1E8BC0FB8608C0362FCB3F5A93393F8BD583BF9840B83FBD4283BF98F0473FC1390040565AEBBF8416ED400519A9C0FEF68E4026E9B73FD3B50AC02411723F63BE85402DF960BF476E91405127B3BF206FE43FD583F5BFF02C8D409F32BFBE57133CBF693D16BF5AC206C021EA74BC71D73540A2004E3FED967C40CD5693C0AAD501C073B218405C25653F9519BD3F360353C0ABB8DA3F103897C0167836BFFF5F573E3316CEBFCFCA72BF35538640AE4B64C0B79655BF30772CC0D96529BF01AB94BFDF51923E60DBCA3F9718E6409697FCBE12146B402479193F55F513C0913169C0378724BEA9431241D8C32B3FEE2359402A6C9D40484542BF6E9E064068AB25400ED37BC02E89DD4004FF773D9975CD3F693B904008F2B8C0BF3D2D3F5182B93FF0B15940F93C39C0070A0240AD39833F139E55C0CB86434014ADA8405FF89F40C2FC4AC0EE0A463F76687A407F9FA5C03F23D2C0A16903416B1C1DBE4BEB26BFC2EC664064FD883F08D9D5BF47EF0B404F848ABF6BEB0FC07B938C3F95F904404E34FE3F"> : tensor<5x6x7xf32>
    return %0 : tensor<5x6x7xf32>
  }
}

