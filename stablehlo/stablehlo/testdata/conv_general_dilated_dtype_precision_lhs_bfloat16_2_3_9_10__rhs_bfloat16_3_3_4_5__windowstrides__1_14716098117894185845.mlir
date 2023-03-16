// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xbf16>, tensor<3x3x4x5xbf16>)
    %1 = call @expected() : () -> tensor<2x3x6x6xbf16>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xbf16>, tensor<3x3x4x5xbf16>) -> tensor<2x3x6x6xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x6x6xbf16>, tensor<2x3x6x6xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xbf16>, tensor<3x3x4x5xbf16>) {
    %0 = stablehlo.constant dense<"0x8B3F2AC0DCBF7C3F96408940A23D2FC0894004C02D3FD7BFBABFF53EC9C0F23DAD3FBFBFE7C006BE533F9FC053BFA0401BBF5A4036C0553FF63F9BBF1940373F24409BC078401D40823F5CBF2F4008BFB53FFBC02340A1409EC06B40553DBEBF224054BF9B40EEBE1B408F400BC08F3F7A3F9340F63FDD3F2C40624098C0084012BF27BD80C0D63F34C02D402A409FC093C05D3F9540F6BF6CC091C0983F9140E93F73C092C05140B740FE3F7F40913EBE3F0A40203F0740F1BF294001C066BFA8BFB1BF02409FBE24C0A4BF444006403AC01B40403F6ABF873FF8C055C097BFE83DC0BF9CC0BC3E2CC0B3BEA03E45BFC3C0173F6B40FF3F4AC0943F834026407FC08CBDE43E5B3F0E404DBF63BFA43EB13E54BF19BFCCBF7640AABF1A4043BF06401B4021BE1040D4BF6EBFC940E03F83BE2A3F263FD23F4EC0DB3E6E408F40DD3FE5BDDBBFEE3F9BBF59C004C04D40CB3F2C40BB3FFA3FBF3F84408340F33F073C8C40823E5F3F313F8840343F5EC056C07BC0A9BFB8BFB9BF9FBE85C011C068C0FE3FA83EDABFC53DF1BF33C0CBBF84C093C0843FC1BF984093BFE73E73400B409ABD9440E5B9E53FD1BF02C01F3F4D3F89BF2A3F883F6AC03DC0F43F81C0AF3F63C042C09A40B4BF2BBE7340E63FA7BF004088401D40EE3F2CC0FABE273EE5BF0A40873FE03EA33FA7C0ABBF5B405140DDBF92BF43BFE03F2BC08D4084C090C0DBBFAF3E804015C005400AC075C023C096C0C73E2840A33FA2C0F93EC040B33F14C021BEABC0953F3E3F12410DC0D740A33FE53F8F3FFEBFE1C0CEBEA44025BFBA4082BF0F40F63FB33F82C097BC0BC07ABF79C07CBF4C405C406BBEE43F96BF81405C40F1BF35C0F93FD73EE94062BF0CC093C01A40C8BFA4BDCB4072C0213F26C01A408DBEA140FDBFE9C099C0E0C0FB3F8A40943FB0C006BF96BF2BBDADC08A40C83FFC3FC3BFE0BF97BFCCBF5DC093C074C00F40EABF2C40C93ECE3FC5BE8C408F4021401BC0C14059BD3D406C402540A94006400C3E843F0BC0CFBFAC40823C58BD1EC0164025C0013F074010C00B40D3BE4FBF59C023C0F64047C0AE3FBBBEC3BED53E8FC0CDBFDB3F44C02EC0993F9BC0A23E21BF8340333F8E4098C0BEBE11BF28C0833ED03F19BF37C03C3E8DC09DC02640BDBF833F42C0B9BF67C087C046408F4034C07E4021BC5740F83D2A409740BFBFB63F1140DFBE723F9D3F17C0B23D8CC034C0A7BFB23F0ABFFC3F9940584027C07B40733F0640C7BEB8C048C07E3E1AC08740B54007C0903F98C0DD3F1BC05740B4408540A2C0A9BF543F34C049C0C1C0E0BF2C3F0040AC3FE43ED23F6C3D88BF8D4012BF1F4085BEA13F6F3ECBBE1F3F50406FBE24407440803F8040A0BFAB3DF8BFC33F1DC0BE3F5EBFBDC0833EBFBF2E4050BE32BE4840ACBF5C3EB53C9E40C3BF4FBF833FEF3F86C099408F4004C0A63F383F5B3F0C3F083DB93F46C0843FCC3F3140863E1240BABF39C032BFB3BF8B3F9EC05940E53F44C0AF3EA43FDABF"> : tensor<2x3x9x10xbf16>
    %1 = stablehlo.constant dense<"0x0AC0F63FA23FCDC07CBF25C0A9C04EC0B3BE75C091BE6A3FA2C067C05040983F64C002BEE4BFB03F2D401C4030BEBF40D0400C40EDBF7E4066C07F3E1DC047C0A7C09FC0DDBFF73F11C060409A40334039BE93BF44404FC0CABF133F594056C01AC076406B4016BF4B40843F9D3FC8BFA63FFF3F1B40573FAC4015C01FC05FC01E40E7BF3340F83F98BFADBFD540F93E0F404640C5BF3640A940FC3FAB3E9EBD94BF0240B53B0A3F9D4030BF3440254003BF2EC08A3F7C3E2040AA3E0C41BAC0A740E33E43409BC0793F9EBD95BEA2C086C0CC4077401F40963FAFBE80C0E1BD1840B8BF824067BF0C3F614079406BC08BBF55C0FDBF02C0CCBEC03EA1BE89C04340E83FDCC012BF78BF1ABFCDBD0C40A1BD4EC02BC089BEF63FFBBF84C0C03F88409B3F00BF423F82408A40A53B73C080BFF93F5C3E70C0EF3F0DC0DCBFDDC01940954076BE9EC00640803FFBBD6AC0A7409EBEC93E5D4028406EBF93C0CE3F8BBF84C00AC138C0"> : tensor<3x3x4x5xbf16>
    return %0, %1 : tensor<2x3x9x10xbf16>, tensor<3x3x4x5xbf16>
  }
  func.func private @expected() -> tensor<2x3x6x6xbf16> {
    %0 = stablehlo.constant dense<"0x324291C23042B842F94250C2E341FA41ACC2BFC117C215C13DC37CC12442AAC261C225C11E42C3C15CC2BA428CC294C1E94107C2B3C29DC283416B412942BF41B1410E42A242F0C1DF4206C2D6C2993E0143854228C35742BA42D3C136424A42304293C2E0C1BB4270C22642934258427F42C5C2D1C13BC201415B41D741F64081C1094244C2F1C2E3C1864282C123419542AC418DC1EDC221C278C287C28DC28D416E42B9C136C223C3DEC11DC23DC28EC107C211C350C2C84235C1F3C124C3F841B7C1DF423F42B3C1DBC1F341E9417BC11AC2A2C00EC25242884172C051424C42C6421FC2214235431CC277C19C41E4C15A42B1C2D7C1EDC1AFC017C291C18141CA42E942274371C2C6418FC2B3417942EAC236C2AB419642FD42B841A542454269429042BAC2424203C3FD4277426C414E4381416542CF418D429BBF94C2F7C1AFC229C237C285C2A4C219C25DC1B93FF942374279C18FC20CC2FDC1E1C208C2154244423B414FC20DC22AC137C2994158C29541DBC188418342724266C1DCC1A2C2C742C44217421EC0E6C1CEC2AEC1FAC1A6C24D42BAC20A42F440D0C1C640DCBFAB415BC28CC2A3421D434143"> : tensor<2x3x6x6xbf16>
    return %0 : tensor<2x3x6x6xbf16>
  }
}

