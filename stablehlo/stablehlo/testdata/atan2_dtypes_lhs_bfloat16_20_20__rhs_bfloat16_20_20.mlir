// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xbf16>, tensor<20x20xbf16>)
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.atan2 %0#0, %0#1 : tensor<20x20xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xbf16>, tensor<20x20xbf16>) {
    %0 = stablehlo.constant dense<"0x1040963F34C01140ED3E65BD9FBF8E402D409B3FAE40A640363F84BF033F8EBFC3BF57C0DC3F95C0473F203F013FEB3F05BF613E49BF1DC0053F2CBD0E40873F9BC0014005C0044046BE27404EC01E4009C0EFBF484086407A4041C04C40B0C09940683D5E3D0A4131402FBFC4402EBE2FC07ABFD63F233F5740F63F8DC04E4029406B409DC026C08AC08C3FF5BE38C0C53F4D3F7DBF013F3540B3BF10C0AC3FF73E4B408D3FB7BF323F9CBFA03E27BD71BF9CBFC3BE454047BF12C0F9BE18C01FBEA9BF824054404D401CC0AA3F4A40A6C0AD408DC0343EB9C054405240783DC140D740B03F37C030BFB93E7B4099C045BEA8BF104041BF6E401B409EC08A409EBF3FC06BBF8AC0E2BF0A3FF23E2840AC3F15C07EC016404640A73F4FC00940043D18405D3FE93D47BF86BE4540B64013C015C00FC0CB3F6EC09C40373FE0BFC1C08540E03F62C00BC088BF3940F5BFAC40D7C008417040E3BE3340CFBE17BF32BF1F40DA3D91C017C02CC0843F0F3FB03F0A40D1BF12C08FBF3840833FB5BF9540A2BFB53FEE3F98BF343F7BBE39C0D2405C3FE6BF3340733FA9BF41C0484057401EC0A2C0BBBF894058C00F404340F23E174042C0B63FA4BF1840E8BEFF3F79408440A8C063400C4039C006C0823F8CBF7440B0BFAEC0A43F3BBD37BFC5BD08C0D93E224008409F3D7FC0F23FB0C07B40DABE40BF98400CC09740494006C09C40903F0C3F8440923F8B3F11409A3DBCBF0A40F43FB04085C076404BC028C0A4BF3CC08DC077BFA8C0E1BFF83FD5405C40CC3FC34032C0F5BFE33FE83F3BC0C2BFE1BE8FC0B53F144029400DC01940F53F85BFE8BF1B40A9BF8040A040C6BF8FBF5DC0954037C091C060C0A43E80C07040414027404A404DC0AEBF3540E43E4EC09D3E6F4029C08A40BFBA5640C0BF41408FBE14C054C052C0B5BF1CBEDB3F4BC0E13F603F403F2ABE68C095C09ABE74407540B3BEB6BED0400AC078C0A83FAFBCB0C07440DDBFA2BFB83F03C087BF4240B140E03F963F5AC08C3E033FE5BF1040403FB63F17418140124152BE1E3F463F1C4037BF93BEB4BF41BD26C00F409BC000BF93408F3F88C0A73C8BC0C1406BBFBB40883F2640CA408AC01DBF64BE"> : tensor<20x20xbf16>
    %1 = stablehlo.constant dense<"0x09C02740F0BFA53E54C052C03AC0ADC0883F7AC07640BE3F03408CC00B40D6BF1ABE73BE89C022C0CDBF8940D5BF77C0F4BEC23F03C09ABF55405ABFE5BF42BDEF3F29BFF03FBAC047C0383E8D3FC0BF86404BBFFEBE2040494034BFE2BF43C06A4020C08CC0FEBD44405C409C3EAD3E6EBE31C07A3E54C0863FB0BDA1BF2EC08F40B1BEFBBF0240833F75C01940123EAD3E343FA3BEE4C06540543E70400C406340864021BF5D40A040E93F83C016400DC0CDBF1BC0BABEA83F2C4031C06D40E7403E40C1BF4AC0B240EF3EE4BF67C0F8BF073F97BEFA3A64BFAABFF7BF34BED33F604078BF4D3F0B4019C028BF8A40913FDC3F82C054C0063F23C00F3F03409FBF443EE73F60BF034005C09DC0E23FCC40144008C0CA3F03C0AA3FDE3EB9BF64BF06C08BC009BE933F91BF933F3BBF5EBE0140E03FC6C09A403A3F23C08E4017C03940843FECBF21C00F40ECBFE4BF8DC04E40F33F2BC094BF09BF22C018C033C053C0953ECB3FAF3FAABD5CC020C05BC03440CDBFAD407340B1C02F4042C04AC0A9BF1CBF32C09140ED3F8E40194016C006C0664015C08E3F32BF98C08140D1BFAA3F63C028C0053C61409BC02740A83FDA404440883FB53F7F4075BF48C076406F4061BFF2BF713F483F86BF68BED1C0C3BF1DC0AA3FEEBF32C0EF3ECBBFE140DBBF593E7C3F03C04D40E83F95401A40EEBF983F13400E4015C0FBBF9CC08FC0E63F8E3EB1BF6BBE5BC0ACC0773FBC40BDC0B4406F3E4AC0B23F0AC04D3E62C0F4BD6C3D544026C051BEA6C071C05EC0C83F36408DC080C015C0023FCEBF8B404E40D7BF1E3EF23F3D408740D93FD7BF89BF3C4011406340FE3F4C4089C0E23FD6BF89BF99C04440B6BF4E40A3BE12C03D4044BE9540AF3F7F3FE0BF353F08C03F40B2BE983FD8BF01BFA13E5E4085402E4095406B404CBEF83F11C09F409DC08C40A3C0224010BFE140BBC04F3F913F1F40EFC0DABF96BF0CBF22BF663F54BFB2409F40683E4740853F91BF9FBE6FC09FBF48BFF8BFB2BD7C3FA13F1CC007BFB9C08DBF30BFD2BF0740413C62C0913F9B4026BF01BFEB402040D33F3CC05B4006C08A408EBFDDBF96C00C40D6BE62C086BF8DBF5140F13FC2BF1DBF1840"> : tensor<20x20xbf16>
    return %0, %1 : tensor<20x20xbf16>, tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x1540D83E0AC0B73F404048C02FC01D40993F3640753FA53FAB3E3AC06D3E24C0D6BFD2BF314004C02C40143E36402D4014C0133E32C002C01F3E46C01040CF3F9ABFF23F56BF334045C0C03F9FBF0740F2BEFCBFDD3F843F653FE6BF054005C06B3F48404840CB3F3C3F49BEC33FEFBED4BF33C0B73F3D40A23FCF3FEDBF1140093FD53FFABF68BFABBF37404ABEC3BFAD3F5A3FF1BF45402B3FB6BF0ABF0D3F0A3E263F0640C9BE0D3E17BF44408EBC2FC01FC03FC0D83F09BF34BF3EC012BFB0BCD6BEF73F1540063FB1BF20401B40F7BFBD3FD2BFC83FDDBFFA3F07403440A73F8C3F0C40A6BF9DBE3F40DE3F56BF2CBE27BF29403BC0B73F1840BBBF903F17C0C1BFF1BEE3BF36BF394043407B3F553E4ABF04C07A3F0A40473FB8BF0B40474013403D401C4018BF3BC09B3FD93FD5BF5BBF68BF394028BFB63F3840C0BEF9BF773F853F03C01BC0E3BE094014C0104090BFAD3F0C4032C0E13F3FC039C039C02040B43E9EBF86BFCDBF36403B403140273F16C0CCBE93BE2A40B73E2DC00B4018C0FD3F234083BEBA3E62BD61BFF53F3040EDBE1140353F04C025C0293F01408ABF0CC029C0C93F44BF2D405D3FB13EAB3E48BF6E3F3CBF0A3F2DC025404B3F563FDEBF0440953FA7BF02C0E53F3EC0FA3F28C0AABF224048C07EBF45C096BE3A40BE3F923F474065BF4E3F5EBF833F3BC010BF8F3F47BF024008402FC014400F3F8D3FF23FE23F354030409F3D7BBE3340A73EC43F0EC09D3F0BC0BFBF33C0CEBFC7BF91BE02C0D8BF3240054017404C3F913F25C02CC01F40A63F05C0ACBE0BBEF7BFBB3F633F3B3FF6BE743F134018C00EBF523FB6BE8E3F803F33C010BF01C0E63F27C07ABFFABFCB3DD3BF08404C3FD23F193F95BF70BF0840103F0AC0D23DD53F93BFF93F49C0BD3FD1BE213FD2BDECBE3CBFD1BF21BF45C0AA3E24C0C43E3E40933E37C0F4BE1EC0B6BEA43F7F3F46C03CC0E03FE9BFDEBF783F47C048BF283FB8BFC6BE723F05C0EEBF1D40E53FFF3F2640CCBF8B3EC63E21C0E73F41400F40D23FFB3FAC3FC2BF3E40193FEF3E14C028C042BE9ABC81BF1F4075BF3AC0513F1740FABF49408DBFD23F39C0E03F18402C3FA43FF4BF17C0BFBD"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}
