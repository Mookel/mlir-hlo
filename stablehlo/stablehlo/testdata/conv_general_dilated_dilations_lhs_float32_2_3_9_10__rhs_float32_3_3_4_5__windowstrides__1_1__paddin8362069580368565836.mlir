// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>)
    %1 = call @expected() : () -> tensor<2x3x3x2xf32>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {rhs_dilate = [2, 2]} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) -> tensor<2x3x3x2xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x3x2xf32>, tensor<2x3x3x2xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) {
    %0 = stablehlo.constant dense<"0x5A4D64C04E44803F0748DD40364D61C00C9663C0A12EC6BFCC8068C0BAC5BC406F14DE3F5C1DAA3FFEF1A23FF6C60D40E725A740D8DD71409235833F83B7FE3FAAFA67C0413F1B3F76F0164072F4ABC055D618BFA72087C0A641B340ADE8683F4CA0B1BFCBD7ECBF408094BF64C7AFBFE6A314BD80CF6A40FF167FBDC660E43F77D2723D01A5FBBF116F803F3A1EC840184EF5BF30A78BC0CB1FDBBF75BE883F94ACD53FEE8FBEBEC0D01F40CC213E408E920A40B182DCBF593DE03F2AC39F3FB1307C3F710DD7401A386BC0CE5B39C0AC01773F3DDBE23E16EFCE3C6A34A43F97DFA63E59564240F331ADC0298DD0BF4BEF22C0EB5F6FBF315438C0FDED9BC0B31EB2BFA52366BF88A4F83FAC0D97BFA537F1BFBBBC8BC0199E0FBEC70D903E3F3EC2BF54A7DF3F5EA02640391E5ABFE95E3EBF0FED98BF1550EABEFFD0E63FC762404093F719403BC5943FF723983F8A2BF0C02F5D77BF86E584C03618C9BFE350BE3FA20C9D3E1A78C8C0194E84C0DD796140FC75AD4024515DC09ABF9CBB802CABBEFC1786C0594DABC0BDABD5BC7126F0C04C41243F173934C0030CE6C0A57236409E625E404F246AC0F00EC9402C1934BFD650D6409FB84C3F5C560C3EECAE30C03FA2CF405AB760C0A9FDF7C053526C4048D2CB3FE44F6E3EA4A59C3F62C069C081577B3F39A5393E22F1284031930F4088718DBF78DF4DBF53AE38407A3BC0BE83C9B1BF4770873D6ED6A93F04D67C3F6D831840489F24BF312306C05EE10640F7B510400B5F933F004C154046FC9ABF85D4B5BFBB5B10C0D15B87BF4A06E23EB990F540AD4C9440EED93A3F595CA440DBB5CCC00F9E023F76618D40E8169C3FE8A0134031E21CC0F74CC3BF69722A40A7DC58C051810DBFD70703C01187BBBFF06F974083A288BF5392873FE06BF1BF2ED15B40EA0EB93F2E13B43BF7262F40B7A9D33F62DAC340FFB123C09B711CC070A79C40D5DBF3BFE1D6913F97AD8140C7B086BF3ADD8ABF023B9C40584D803F4CCF773FF9BB7740E9BF0A40BF2669BECB3A9ABE1F0B2E3F5C2DBABF05D08D405F2B8FC0C4B715C0E3CCE4C0104B0FC0D7511D406C6E86404B59AD40674D6AC0049FA13FC63253C081189240F283F13FE53993BEC3BE963E7FB2CF3F0156ACBF157871BE66E65D40C0603040075CD3BF2D3C453F9DC3E6BF5853A3C05E7801408689EB3FEA613FC0F6CC8F40C3F08F409D8B4240F9EE80C0D7DE29BF3C602940BFA5ED408A139DC02817D9C0F980B2BEE43F70C08FA3D0C0B5FFDABFD06883405DF620400F93CABF21186A40A2D4843FCD5A04C06080E4BFCD27403E8BBCF1BF26F6CABF9C48D9BF8A947A40017894407F38F7BF813583BF19B311C1CCD2A23F67895B40809FB83EC2590540CC56743FB99A4C401A00CBC06F6DACC01C35464036AF71BFDCC7224010CF46C03456A2C0C1DA683F6B5D673EBDC69F3F8B24D73F9D5FBF3D50AA71407FB66940C0A53FC0738B973F58C669BE5A7E1B40C26E7AC024E606401820FC3D41D424409F92DB3EB756E0C0D9C0CEC0B4FEFC3F52B036C0488BCABFA18249C0B619B84055A6533F72C2BABE6B773CBFB6459640944409BEC56898C05B0C953F0BEA62406C93823F544BF83F3C26D03E81FCBD40AC0E8D40882C003FA9978640E5E89C38F6C4D93F5B5F683FF4A3724027C3D6BF4FBF853F4E5FBDC03966C63F0CD1E8BE7D6A4140A05002C0D5763EC06B3480C0B845ABC030AF603E53443E4069184FC00D10DCBE56D513C0F7E954C0CAB1DD3D7F85B0C0D652FABD0D8E3BBEC13C44BE023FB1C06BA99B407F7312C0119239C0550DA040FD4124BF4A3507C03D0202C031138C3FA0596140AD42B93C4E9C7CBFC7D61FC04847BC40362E00409D49A43F9F5132BF68273EC0BDF782400E59D33F9F96E0403165ACBF6EC19FBEDDD784C0EC97A440BA42A1C04DBC993FC36E0A3FD558F53EB51EAB3FC58581406920F6BF7797E13FFC12B33F0C1510C0584376BF08A259BEF858DFBFD7301A40A2C9CD40054CB8BF75BBA0C0EDF961C0F12A6F40266B93BF8C06454032B6C5C007B70DBE25F2ECBF7B66DDBE60889E3DEE5F1E400165103F460AE13E7B7795405FB21B401FFB99BFAA2141BF8000083F13F78F40810A84BF3822594003F045C0823F584088900AC0108A4F400470663FCA6BB3BF60FEFE3E1BFF9FBFF3A82C40350FA03DD41698BF3385AF40344DB1BFA216FE3FDD8560BFB3106B4067BAF93FEDBABEC02DC9A0C03173E8BFD8EBEFBFF02E44C0C2112A3FE793FABE276B713F81A0D4BE5607283F049082BF83BE4FC051F61740F300F03FC786923D924AB93E8410E93FCF28ADBF85BA65C00ADAFF3FBC5664C076106AC053DA4DC03EA3623FEB5B2BBD7724B33F3AB08E407FC719C09B6A37405A21AEBFE6A935C08AB0FABF591D88BF3C35A040F327C5BF693DE43D4FC9BBC0324ECCBE600699C08F6505418E78E7C0F7D9F2BEE61EA83F147C9740C6C5123F532BBABF894926C09A64C5BFEE6B6740E46C0FC0F236E8BF71864AC0F72A5340DF3986BE38B7004055147D40C33A2F3F3209EC3FC4AA1E404121973F2EC3773F04B54D3E553A16C088FA733F8AA97A40F440BFBF8146354061041A40D6C12E40EDA6B9408D0735C0FBCF73BFA3CFC8BFA5B43FC013283E4077178D40DD3F94BF921682BFC6524540F635ED3FC889023F1BD206BF78AC72C03151B5BFDB6F74C051659E403AF21CC00F1D7440C4B0C93FD0B1D83FDF5604C05C4DE43F376F69BF6757083F37D41DC071C68FC0CD9AB4BE3CC53340A0EC75404225E63E271726409C52D6BFF813AC3FA4E2B63F88E1583E28F005BE6DAC6BC0E08AA8C058B6E83E7D543D3EC28208C0851DFD3F20D92D3FC5962F40AF533C3FE06E90BFEF3A994053F81240783FA93F1D6C4140FC6C703ED1CA8140AEB6C8BFCF04B7C02B484140B204CC402521C5C09FC4BA40E95004C0619455C0DAA817C0074E2B409D774EBE711464409C05CCC07C13763F1490B03F923BDA3E62CB4C40A882E1C03AA3F4C0"> : tensor<2x3x9x10xf32>
    %1 = stablehlo.constant dense<"0xCFB07040F23E89C0D3D08BBE97B56EBF26CE37C053C0C03D7ECC12401DE2CCBF4944E2C064382EC001769DBFD84CAB3E85D1D94000C104C072414C40FB0C4340BCA428408F24094057F54EC0281E6E40152F3B3FABC8E93F021A65BFF0D8BBC0B77D88C05F4B70BFAA940140A8C9C44048B1B9C03BC5263E4C28E73F4DDA573FE3457A3F666A8CBF930A0ABD052CB7402FE957C06EC0194056B145BFA31490C0739B6A40857594BFC9BC78400E5668BEB3B586C0894C8D3FBAB02DC0966D2EBFB62AF4BF05C2B9BF45E9193E4B66D8BF6FB1D53F6E02A14089EF6B40FEB8C1407F323940D90011C0EB660D3F66C46C3EFBC47CC0F6EED3C081454AC0ECB6C4C0EABC04C14BFE9BBF56570AC0418A07BFB8549B40B5EC1340724D6FC0BC87673F9E18A13F6AF3993F2C968ABF6E684A3FB03D9F40DFA61D3F66F74B3F160557BF1AA780BEC3E3DCBF18ADD1C01BDF4140CE640AC091A50E40C0024FC07AE130C0015FF2BD77EA40BE64898D3F03864BC0440373C0EF3F2E40440326C0BD114640A21AF4BF2661BA3FBF322A40142D893EBF4DA4C069383CC0EF5B45BF1FDD89402338E93E6BF0BC3F94844A409759434042B28C407DA32E3F99C85840C92D1FC0C458EB3FC3A0B9C0B39EC1BFA33B03C1B98D93C09EFFE740FC9D653DA4D0DF3FC62AF0BF866030C0F56AADBF3DCD663F02479F40B1068DBF73596840BD703A3E71A8E23FD1DFEF3F5AE9C1C03ADD0B4080F1D13F4E8A2240C50A0A3FE3E690C049EC22BFEC3536C0D00E54C06E4B98401C462EBD1307C5401D8DAFBFBB15E73F876FCDBF67D0D43F534619BFB25736403F2187C032D52E3F1CDBE5BF365243C0495030C009885FBFD71EFBBF0A1224C0FF63B3C0B764DD3ECF7C3E3EB32CC7BF6BCE26C07D71BEC0F702ACBF5863BEC002DD17C0AF3489C0A87B1BC0DC8E8F3FDB7A5EC02ED0144088E62DC008ECAFBF51908E3FD59D67C057EE26C00B8A90401EFBDABFA3489E40108FF2BBC958D3C0"> : tensor<3x3x4x5xf32>
    return %0, %1 : tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>
  }
  func.func private @expected() -> tensor<2x3x3x2xf32> {
    %0 = stablehlo.constant dense<[[[[-76.6495438, -22.5911961], [-55.6019859, -100.335007], [26.6736469, -30.2512379]], [[42.2553482, 61.9655266], [-4.50302315, 112.150879], [-6.27026844, 24.0557175]], [[-10.2137318, -17.9561272], [-16.2657814, -173.396362], [31.1004601, 0.151023865]]], [[[17.2322083, 111.025894], [-33.428524, 16.5310249], [83.803894, 5.253740e+01]], [[-8.29826545, 5.39624596], [17.9915733, -258.807465], [-182.896545, 25.1346512]], [[-54.0725861, 89.7837829], [13.5437155, -63.3894081], [-34.5224838, 7.740200e+01]]]]> : tensor<2x3x3x2xf32>
    return %0 : tensor<2x3x3x2xf32>
  }
}

