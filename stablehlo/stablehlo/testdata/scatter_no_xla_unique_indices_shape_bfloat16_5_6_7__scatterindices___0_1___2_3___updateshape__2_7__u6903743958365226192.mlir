// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xbf16>, tensor<2x7xbf16>)
    %2 = call @expected() : () -> tensor<5x6x7xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      stablehlo.return %arg1 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xbf16>, tensor<2x2xi32>, tensor<2x7xbf16>) -> tensor<5x6x7xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xbf16>, tensor<5x6x7xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xbf16>, tensor<2x7xbf16>) {
    %0 = stablehlo.constant dense<"0x44C0493F173E353F53C0073F5FC047C0E7BFF63F92BF47BE2EC040C0DF3FA140CA3E2940273F18C0A8407BC00AC090BF97C0C93F7CC0EA3F1F400F3FEBBF553FAB3F1D3C314010404CC0A8BFA2BF43C0EA3F88400AC0D33FDA3F86C09EBF9A3FD2C0A840AC40A6C0153EC3BF9040953F7A400BC042C025C184C0F1BF95BFF63F5740C5BFBE3FA8C003406C3E44C0F63FAE3F89406BC0F93F05408CC02B3EA04006C06FBFCB3D44BE364098BEE03E0B40344003401F405EBFE54031408E3CA1C06540AFBFD2BEFF3F7AC0063F60BFD93FF8BF5CC00340B53FAE40FF3F0EC083407E40FA3F88C038C0C93F3ABFB940D0BF853F90BFD5BF86C005C07240EDC0A13F19BF58BF90C01140D43F99BE1040DB3DCFBA533EA73FF53DEEBEA24024C058BF28C0DFBD6940823F403DD13F9CBF8FBFB83FAB3E89BFFCBFAD400ABF46406C4091BE60BF3D3EB2C03EBDAB400FC0F0BFD8BF07C0DB3EC74013BFCBC05B3F7D3F0C40AD3FC73F013F94405040AE3F3B40A0C09C3FD6BDF1BF83C054C0F43EB23F10BF36C0C7BF9D3FF33E64C064BF1A40E0BEE13F844006BF314051C09B4004C03F3E8340"> : tensor<5x6x7xbf16>
    %1 = stablehlo.constant dense<[[3.093750e+00, 2.421880e+00, 4.550780e-01, 2.828130e+00, -3.937500e+00, -2.734380e+00, 2.062500e+00], [-3.109380e+00, 6.500000e+00, 1.531250e+00, 1.796880e+00, -5.351560e-01, -8.164060e-01, -1.718750e+00]]> : tensor<2x7xbf16>
    return %0, %1 : tensor<5x6x7xbf16>, tensor<2x7xbf16>
  }
  func.func private @expected() -> tensor<5x6x7xbf16> {
    %0 = stablehlo.constant dense<"0x44C0493F173E353F53C0073F5FC046401B40E93E35407CC02FC00440DF3FA140CA3E2940273F18C0A8407BC00AC090BF97C0C93F7CC0EA3F1F400F3FEBBF553FAB3F1D3C314010404CC0A8BFA2BF43C0EA3F88400AC0D33FDA3F86C09EBF9A3FD2C0A840AC40A6C0153EC3BF9040953F7A400BC042C025C184C0F1BF95BFF63F5740C5BFBE3FA8C003406C3E44C0F63FAE3F89406BC0F93F05408CC02B3EA04006C06FBFCB3D44BE364098BEE03E0B40344003401F405EBFE54031408E3CA1C06540AFBFD2BEFF3F7AC0063F60BFD93FF8BF47C0D040C43FE63F09BF51BFDCBF7E40FA3F88C038C0C93F3ABFB940D0BF853F90BFD5BF86C005C07240EDC0A13F19BF58BF90C01140D43F99BE1040DB3DCFBA533EA73FF53DEEBEA24024C058BF28C0DFBD6940823F403DD13F9CBF8FBFB83FAB3E89BFFCBFAD400ABF46406C4091BE60BF3D3EB2C03EBDAB400FC0F0BFD8BF07C0DB3EC74013BFCBC05B3F7D3F0C40AD3FC73F013F94405040AE3F3B40A0C09C3FD6BDF1BF83C054C0F43EB23F10BF36C0C7BF9D3FF33E64C064BF1A40E0BEE13F844006BF314051C09B4004C03F3E8340"> : tensor<5x6x7xbf16>
    return %0 : tensor<5x6x7xbf16>
  }
}

