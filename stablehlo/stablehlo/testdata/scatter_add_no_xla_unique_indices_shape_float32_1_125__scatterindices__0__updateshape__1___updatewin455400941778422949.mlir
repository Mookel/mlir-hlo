// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x125xf32>, tensor<1xf32>)
    %2 = call @expected() : () -> tensor<1x125xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xf32>, tensor<1xi32>, tensor<1xf32>) -> tensor<1x125xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xf32>, tensor<1x125xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xf32>, tensor<1xf32>) {
    %0 = stablehlo.constant dense<"0x20F42CBF22DC1FBE609A973F3BA711C0415A40C01E063340E93AE73F8D4E05BF4681C9C00C3EBF4056FB25C05BB623BE138D89C0EA3E91BFE8C478408C2BAF3E6F05C7C07B89834094E1AEBDE0EB1AC07299E6BE1AE82040BCD0643F84CDA63FB803B43E59C8CEBE5076D2BE8E7FD7BD222B83C0919FCDC0629E22402BCDFC40CE0A953FEFD91940CEDAA5BF7B07B2BEA50CD3403C9554C082C10E405D72DEBED10EA1BFCDA9E1404484E4BF10715EC0E377C63F395C24C0CAC8DABFC85ABF402AAE31400F8F7B40B2792CBF6509DCBE30394BC0222DEEBFC56096400989DCBD918C70BE5CD627C0C761F9C0514F5AC0353E3DBF65BF8EBF33AEC13F0234B23E16FA4140556F37BFCFB99A4012268ABE33DF00BF82DB61C0B22D6E3FE8EB46C05644ECBF6A52A23E636E9F40327353C0230F0CBED39FD0BE7E4D8A3F3A8762BD51952D40F6D97CBF918B85C074AEC73F9BFC263FAD6ECDBF0C33CF3FB342313F461E82C0D7EF313FA88AF1BFA3C5D93F0F197EBFD45F08408FF90C3F25D42440C87364BFA63481C0FE2432BF71B89E3F1CC25840DB4D31C0C30F0140257FD0BF2F21A5BF3A35023FB21ACB3FCAFF52C0577061C0AFD1774011B7ACC04D0F3440151CED3F89DB69C0C21CC9BF88D318C07C9CEC3FFFC741405106494075035A40633D2BC0BA94A9C05474B7BFCD6CACC0ABA2783F"> : tensor<1x125xf32>
    %1 = stablehlo.constant dense<2.19309068> : tensor<1xf32>
    return %0, %1 : tensor<1x125xf32>, tensor<1xf32>
  }
  func.func private @expected() -> tensor<1x125xf32> {
    %0 = stablehlo.constant dense<"0x223DC23F22DC1FBE609A973F3BA711C0415A40C01E063340E93AE73F8D4E05BF4681C9C00C3EBF4056FB25C05BB623BE138D89C0EA3E91BFE8C478408C2BAF3E6F05C7C07B89834094E1AEBDE0EB1AC07299E6BE1AE82040BCD0643F84CDA63FB803B43E59C8CEBE5076D2BE8E7FD7BD222B83C0919FCDC0629E22402BCDFC40CE0A953FEFD91940CEDAA5BF7B07B2BEA50CD3403C9554C082C10E405D72DEBED10EA1BFCDA9E1404484E4BF10715EC0E377C63F395C24C0CAC8DABFC85ABF402AAE31400F8F7B40B2792CBF6509DCBE30394BC0222DEEBFC56096400989DCBD918C70BE5CD627C0C761F9C0514F5AC0353E3DBF65BF8EBF33AEC13F0234B23E16FA4140556F37BFCFB99A4012268ABE33DF00BF82DB61C0B22D6E3FE8EB46C05644ECBF6A52A23E636E9F40327353C0230F0CBED39FD0BE7E4D8A3F3A8762BD51952D40F6D97CBF918B85C074AEC73F9BFC263FAD6ECDBF0C33CF3FB342313F461E82C0D7EF313FA88AF1BFA3C5D93F0F197EBFD45F08408FF90C3F25D42440C87364BFA63481C0FE2432BF71B89E3F1CC25840DB4D31C0C30F0140257FD0BF2F21A5BF3A35023FB21ACB3FCAFF52C0577061C0AFD1774011B7ACC04D0F3440151CED3F89DB69C0C21CC9BF88D318C07C9CEC3FFFC741405106494075035A40633D2BC0BA94A9C05474B7BFCD6CACC0ABA2783F"> : tensor<1x125xf32>
    return %0 : tensor<1x125xf32>
  }
}

