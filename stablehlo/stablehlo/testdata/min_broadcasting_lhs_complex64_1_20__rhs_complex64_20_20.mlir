// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<1x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>)
    %1 = call @expected() : () -> tensor<20x20xcomplex<f32>>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [0, 1] : (tensor<1x20xcomplex<f32>>) -> tensor<20x20xcomplex<f32>>
    %3 = stablehlo.real %2 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %4 = stablehlo.real %0#1 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %5 = stablehlo.compare  EQ, %3, %4,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %6 = stablehlo.compare  LT, %3, %4,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %7 = stablehlo.imag %2 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %8 = stablehlo.imag %0#1 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %9 = stablehlo.compare  LT, %7, %8,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %10 = stablehlo.select %5, %9, %6 : tensor<20x20xi1>, tensor<20x20xi1>
    %11 = stablehlo.select %10, %2, %0#1 : tensor<20x20xi1>, tensor<20x20xcomplex<f32>>
    %12 = stablehlo.custom_call @check.eq(%11, %1) : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> tensor<i1>
    return %12 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) {
    %0 = stablehlo.constant dense<[[(1.931916,3.19750237), (-0.142546758,0.608027339), (-0.876049995,-1.16844451), (-1.95387363,0.962346494), (-6.47362471,-4.22718191), (-3.30392265,-0.841038703), (2.29783678,3.46856952), (-3.84464812,-2.33700275), (-3.081170e+00,2.74097538), (2.23805523,-0.62088555), (-1.24081099,-1.74586284), (-2.88839769,-0.641518533), (6.16750145,-3.08076954), (-2.3175168,1.78012872), (3.11903381,0.899800121), (1.07036495,3.68648362), (-1.622082,1.72356427), (1.65563023,4.51393414), (0.806820213,-2.27611589), (-1.99339461,-4.01276159)]]> : tensor<1x20xcomplex<f32>>
    %1 = stablehlo.constant dense<"0x01B195BF232B40C0A4885F40C0AE1840F15D51C00760A4406C0362C0BCBDEE3F018A8ABF4DD084C0C0E8F340C36014400BF8BDBF2337EBBF9C84A73E8063C8BEC2D00DBE79706D3FD68D42C0251445C0B551093F0FC42F40A96702BF5C310AC036F6B8C08CF813C0D75123403E2814BF4CAC6A3FCB7045BF5812F6C0C9C22E403089A1BE18FE953FED5C604012D93D400B44E7BE6CAC88405DDC5D40295F4BBF0A7A1BC04141093F1E825040DFBFA2C0959242409D43C2401842E53F7FD5D0BD94AB46BF3C80314032520AC07CB12E40F3E787C0C5997140B87769BED8144E3FE6B126BF468D08BE4F0DF03E28CE5140574232BF163243BF0A07DDC03A6C2EC084811DBFF4E8164040AC3CC0E3FB22C065BCD8BE4F8CC63E5107BABF941427C01A8FA14041813EC03E1F30C0290823C01B0812C0ACB9C8BFA96F3CC00C202CC07A8DADBF31EB72BF280A77C0F32F87BF1E63693FA56FA9BF483A2E40EBA32FC017F3B93E07DF40BF21EAB040E26E444077B6E8BFAA55503E1355E0C0886AC3C0B2A9773E27C2094092B1A640A0EA823F29FB2D3F530971BF9E1F04C094CA10C083CE05C011670D4028BCBD3E2214143F758601BFDD7178C035A7FDBF46844EBF91B51640E9AF44BE3FF6C23CB58A37C07BD5F8BE2446643E6FDBDA3FC2A09A3E1FFB6CC0D1557D3E4FBAC3C07C5B134069F61840D8E7A0C0C9D038C0F74AF6BF1AD8A740F021EC40769198409C6126C081A4B540EFC004C04BF20640026BCA3E5AAB833FE6B85C402A927F4025B2794049E681BEB5F306C0452902C0A00B393FE6A9F4BFC01A7CC065F425C056BF183E7BF00C3F6E5D95403AB9DFBEC46DCF3FB3AA2FC0BE4008400D158C40848026405B679ABFECAB70BEE7ABB940920607C0AD39D2BFE2002ABBBBA279C065CC16C06456494015899B403A65F2BF9C6CE7BF256641C09AFFE33FD16D9CBF9CBE99BF43DF16C063BB424084EB2C40076A36C09D5C6AC04B6EBC3F3ABB8A40893737C032CD2EBFE5E684BFA5270D40D2963AC092D7863E98DC10C0C69CDEBFE01B0CC046007140C51BA13F47843B3D66C3A140D1C18ABDF9135E40C2A13CC01731E23EA364A93F04CA76C0CC995D40CB021CBFF82CDBBF01321E3D3EF20940371D1CC192DBA9BEAE3448C0897A0D40AD3276C0EC397940C85D893FE2BDE840995C463C6959E5C0CD9C44C0B9CC36BF34F0FABD53B879BF796AF73F064CB6406E8BC1BF6A1138C06FE168C0C67D23C0348E0A40053EB540C2CA9E3FBE8E1DC1124A62C04310874070978D4064ED37C04BCD0F4088FD0A409C50D83F304AAEC06ACE21409D13ACBF1683494050E3F13E95A39DBF2AA428C03B8A3640F1C51240C934254016D25440EC6772405BDB0941AFA58740A94605C00D79F23F23F1CB3FCC8587C00B2825C0848104C0911B5E3EF559BF3F2B2B5BBFD1B520C068495BBFC3BB25BF008C3EC090ECAB40FF99CEBFEC391640EA343F3E91E0D7BFFD91E240DF0A4CC087C936C0C62BF23ED9E10440C2082E3F73AFC9BF4BC462C0FF430FC03DA400BF5DD133C091BCE03ED9B8EE3FDC216BBFB86632C05DFFF93F3B6C5CC08922CDBFA1D16A3F773BD3BF86CDF6BF10148FBF4F6275BF1C7BF6BFEDB8B33F1740D4409D2713409882053F0B1DEA3F8CECB03F1057B9C01D9AE73EC84E163EC1389240F65057BFC0AD643F255C1EC0E52BE34034DA01BFDC53AABF31D4DE3EAFCFF13F76F88C40CBDCCFBF29BE3F40B451C43F11AE4840C82C39C085FA463C32D75AC045C2D03F2C0884BE8846763F112F2ABF6C032D40A24B7F3FCECA2040DE191E3FF774FEBF31D81C40512AFC400586973F35D6313E5F848940A25CD63F7B7E44BFD00B74BF326C5340DA9E18C0E06F10C0DF64074062ABF33F30202CBD1B7E3DC0D6DD81BF4DB0AE3F75B39DC09785C93F8A53A5401E569A40F3D9273F99555DBF20E588403D0E96C071850A407A7630BF28DC26C01195243F1B13A33F8C1F0DBD0EF2A5BE67087E3F15899A4026F12D40D9B3C23F26CB144068C7873E64E536C00AF0B0C090CA2B3FED5BA13E4AE969BF8FC2EB3F7BB492BFCE4D0FC04B4A73BF6A81814069529440D256D8BF2A6112C0C4EE703F96B3C13EF3CC2E40EF9F213FF4493040CBA901BF29831640510272BF261C11BF8F504740A6B4D940241D5FC0C9F5B5BF99E4F33FEF00BA3E1D353D409D7B5AC0D2E687BE98696A3E7F6182C0597716C007AE8E3FD0184CC09E8FB0BE71084E40E2C044BF95327BC0FCB00EC005B21C3E01628A3F1ABD2ABF2D6D5340016932C0FE17BEBFA06DB73D73767B40E6E423C00341DBBF48087FC017AF78BFAB10C0C0A71B373FC95CAA3F1B3F884073909140BF9D2CC0822F854023962BC019E444C01D5FD540CAF4C7BF73CA9DBFBC26673F7FCBE83E1F63ED40C578024035F071409736ACC01B5B1EC0AD7714C035E205C01B90863FB8C64340760C26C0599D94C00BDC09C0E7B006C142091C40A1B23ABFDC4E75C068C562C0AD73D63F99BA53402C74A53FB9BF9F3F81A36A3F644E61C04A7997BE5FD002C0491A103F0D9C84405A66E03F23C815C05B5414BE5E6133C03003FFBF92FEBEC037A5CFBE955225C0BF13C0BFA4E5CA3FFE0EE0BF1C0A88BEABBA2C40E0A951BF315B38BF171A0B406BE39C3C78FC173ED60F2E402DB46D3FF9B7B3BF5EF1893F74E7F63FE427EF40601ED63F905C7A3F7DCDDFC0C421C9BF243F6D403ABCBCBE59C53240971752C0C2734040B27DC53FEFBF2BBFD19D3F40AE5F9840D6C0BFC0F78A603F1A771140A790B9BF9E9C5CC0CEEEA9BF10732341076A81C0A2049ABF910D7B3F5FCD1E404AFE23C0D062B8BE6413DCBF82BCC03F55B5E73E6ADBB93E3F5DBABFE79A453E87965840786944BE411C9440EC0713C0F584FC3ED358F23F6CABCD3E8B847DC0CFCE4A40ABA89CBF6D3938407197EDBF924892BE14B1FDBF4998D33C5393063EC3D3FF3FF95E39BF22ED33BFDF0AFA3F061EF1BF468D42C0EA42E03FD132E5BDAB937440D5A9EBBE924DAE40DC36CFBF7C3DF8BE4FE7AA3F3BE47040FCB87BC083194940C37538C0EB18AC3F7FF960C00D68013D6DCBD5BFFB2F7D407603A04070A3CABE9812EF3F519ABCC059D3433FA3AF06BF0B9E333E5A12ACC0A30B49C05A71D840F44AA7BFB31C8640E8B54D3F188716C0E861C440C0AD60C004F9E7BF488F38C00DD42A40633C144000B274BF91D55E402F00063F530B4A3F20426640277BD9C09844E0C021F156BE36C5A2C026B64E3F60F62B40199052C0E1FA1CBF1FB6093E5E2586C0764981BF521FEFBF0F22D5BFFE6DE4BFBA0389BFECCD7F40A18ED33F5B45ACC036940940816134408BEEACBF26DF15C0CFE93EC0BD55823E6EF91B40E1F086BED6096AC0509FDBBF52024C3F71F786BFA9FF9AC0F0AC34405DF05D40327F84407BF08340B3FEC7BFA1DA04C0D5F99740C8FC4C3FFD674D3FD86865408378D33F47C73540067045C0F9868E3FB4B48BC073B50940AF3654C02C16A53E7BACA1BF08B19B3F9C0609BF4DEC7E3FC91BE2BFA2AE1CC02EBF98C01FBD824058E848C0D8CC88402B1B4840C252A0C03F9E873D24DD03C1748B844087610040A39978C05F2E08400429CB406495BB3EC92737BF96B622409A2226C04196A6BFABEC54C0B120B4BF3374FFBE68CA3940A841503EC45EBE3F7AE23F40711790C07EAB0EC0087C1E40C4968440F2D3ADBE5C863AC092A63B404BA0194087635CC0EB53954005AFB73D029138C039ED6E3F9849783E78DA9D3AEE4791C00DC5A4BF54E651408CA039C0131C89C073052740EEB88240315C51C0FA5C713E00816EBEA155A240D2C0884056C40740780DC840D620A2BFAD44B6BF204FD03EA70DAF401EBF41C0C28826405A309EBF0EBC9ABE281F833F5558B840DDB5A63FE9732C3FCBFE833F5B62593F15706C3E82218C40B18C88BFCBA99240D6102CC0496681C0499999C07D6C0DC0E0790A3FDE3EFF3F96C51240BB32B1BFD16ECA3EBE7166C08D0BE23EE2DCA33D0233B9402038193FFF49F53EE83D2940F3FCEF4053651040100AF2BFA3EEA7C0798F94BF963EFBBF1304453EFCB6C53FF31F1240EB4B3FBF144396C0381270C0CAF1553F9BBF4A40480287C002C90741833015C0EECCE83EBD2A1640616EC13EB8858EBFB941613F32DD9CBF2740F93D90E9C0BF22C2CFBFDCE224C0E0AE89C0910A8BBF8A54823F0C9449C0276DD03F2B94CE3FE85720C09F89DDC0A5EE79408A53B03FDEC226BF0EB1604061116BBF0555CC3F717894405B4A5BC0C18B46C07B26CC40B2B6DA3E686904C0598F9CBF93C57C401CFDA43FBB7D96BF0E631D3F168952BF05C081BF1D1B9EBF24A8B240C8FBD0BF0BC86640A2364B40752565C064B2763EFC5413BF28EE7CC0256361C06FB8EE3FD9A9CC4059E8C5BF82B7AEBFB286A9C06BA22FC0B3C968BFA2EE05C0B71B1440D10F5440459B833FDCF57DC08CC30CBF1993FDBF494E763DC2FF1B40"> : tensor<20x20xcomplex<f32>>
    return %0, %1 : tensor<1x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x01B195BF232B40C0C7F711BEAEA71B3FF15D51C00760A4406C0362C0BCBDEE3FEF27CFC0134587C0787353C0504E57BF0BF8BDBF2337EBBFB70E76C0749115C0E43145C0246C2F40D68D42C0251445C0E5D29EBF6F78DFBF82DB38C08F3A24BF36F6B8C08CF813C0325214C042DBE33F4CAC6A3FCB7045BF5812F6C0C9C22E4062A0CFBFC19DDC3FB1EBD33F267290400B44E7BE6CAC88408E27FFBF8B6880C00A7A1BC04141093FC7F711BEAEA71B3FD04460BF978F95BF8818FABF575C763FEF27CFC0134587C0787353C0504E57BFF3E787C0C5997140B70E76C0749115C0E43145C0246C2F404F0DF03E28CE5140E5D29EBF6F78DFBF0A07DDC03A6C2EC084811DBFF4E8164040AC3CC0E3FB22C065BCD8BE4F8CC63E5107BABF941427C062A0CFBFC19DDC3F3E1F30C0290823C01B0812C0ACB9C8BFA96F3CC00C202CC07A8DADBF31EB72BF280A77C0F32F87BFD04460BF978F95BF8818FABF575C763FEF27CFC0134587C0787353C0504E57BF77B6E8BFAA55503E1355E0C0886AC3C0E43145C0246C2F404C3C0F405BF21EBFE5D29EBF6F78DFBF82DB38C08F3A24BF83CE05C011670D40325214C042DBE33F758601BFDD7178C035A7FDBF46844EBF62A0CFBFC19DDC3F3FF6C23CB58A37C07BD5F8BE2446643E8E27FFBF8B6880C01FFB6CC0D1557D3E4FBAC3C07C5B1340D04460BF978F95BFC9D038C0F74AF6BFEF27CFC0134587C0787353C0504E57BFC20F13400BFD5D40B70E76C0749115C0E43145C0246C2F404C3C0F405BF21EBFE5D29EBF6F78DFBF82DB38C08F3A24BFE6A9F4BFC01A7CC065F425C056BF183E7BF00C3F6E5D95403AB9DFBEC46DCF3FB3AA2FC0BE400840B1EBD33F267290405B679ABFECAB70BE8E27FFBF8B6880C0AD39D2BFE2002ABBBBA279C065CC16C0D04460BF978F95BF8818FABF575C763FEF27CFC0134587C0787353C0504E57BF43DF16C063BB4240B70E76C0749115C09D5C6AC04B6EBC3F4C3C0F405BF21EBFE5D29EBF6F78DFBF82DB38C08F3A24BF92D7863E98DC10C0325214C042DBE33F409E47404D59663F47843B3D66C3A14062A0CFBFC19DDC3FC2A13CC01731E23EC58B4E3FE2AB11C08E27FFBF8B6880C0F82CDBBF01321E3DC7F711BEAEA71B3FD04460BF978F95BF8818FABF575C763FEF27CFC0134587C0787353C0504E57BF6959E5C0CD9C44C0B70E76C0749115C0E43145C0246C2F404C3C0F405BF21EBF6A1138C06FE168C082DB38C08F3A24BF053EB540C2CA9E3FBE8E1DC1124A62C0409E47404D59663F64ED37C04BCD0F4062A0CFBFC19DDC3F304AAEC06ACE21409D13ACBF168349408E27FFBF8B6880C02AA428C03B8A3640C7F711BEAEA71B3FD04460BF978F95BF8818FABF575C763FEF27CFC0134587C0787353C0504E57BF0B2825C0848104C0B70E76C0749115C0E43145C0246C2F4068495BBFC3BB25BF008C3EC090ECAB4082DB38C08F3A24BFEA343F3E91E0D7BF325214C042DBE33F87C936C0C62BF23EB801893F59EF6B4062A0CFBFC19DDC3FFF430FC03DA400BF5DD133C091BCE03E8E27FFBF8B6880C0B86632C05DFFF93F3B6C5CC08922CDBFD04460BF978F95BF8818FABF575C763FEF27CFC0134587C0787353C0504E57BFC20F13400BFD5D40B70E76C0749115C01057B9C01D9AE73EC84E163EC1389240E5D29EBF6F78DFBF82DB38C08F3A24BF34DA01BFDC53AABF325214C042DBE33F409E47404D59663FB801893F59EF6B4062A0CFBFC19DDC3F85FA463C32D75AC0C58B4E3FE2AB11C08E27FFBF8B6880C00649F73FE1A34C40C7F711BEAEA71B3FF774FEBF31D81C408818FABF575C763FEF27CFC0134587C0787353C0504E57BFD00B74BF326C5340B70E76C0749115C0E43145C0246C2F4030202CBD1B7E3DC0E5D29EBF6F78DFBF75B39DC09785C93F8A53A5401E569A40325214C042DBE33F409E47404D59663FB801893F59EF6B4028DC26C01195243F1B13A33F8C1F0DBD0EF2A5BE67087E3F8E27FFBF8B6880C0D9B3C23F26CB1440C7F711BEAEA71B3F0AF0B0C090CA2B3F8818FABF575C763FEF27CFC0134587C0787353C0504E57BFC20F13400BFD5D40B70E76C0749115C0E43145C0246C2F404C3C0F405BF21EBFE5D29EBF6F78DFBF82DB38C08F3A24BF261C11BF8F504740325214C042DBE33FC9F5B5BF99E4F33FEF00BA3E1D353D409D7B5AC0D2E687BE98696A3E7F6182C0597716C007AE8E3FD0184CC09E8FB0BE0649F73FE1A34C4095327BC0FCB00EC0D04460BF978F95BF8818FABF575C763FEF27CFC0134587C0787353C0504E57BFE6E423C00341DBBF48087FC017AF78BFAB10C0C0A71B373FC95CAA3F1B3F8840E5D29EBF6F78DFBF82DB38C08F3A24BF19E444C01D5FD540325214C042DBE33FBC26673F7FCBE83EB801893F59EF6B4062A0CFBFC19DDC3F1B5B1EC0AD7714C035E205C01B90863F8E27FFBF8B6880C0599D94C00BDC09C0E7B006C142091C40D04460BF978F95BF68C562C0AD73D63FEF27CFC0134587C0787353C0504E57BF644E61C04A7997BEB70E76C0749115C0E43145C0246C2F4023C815C05B5414BE5E6133C03003FFBF92FEBEC037A5CFBE955225C0BF13C0BF325214C042DBE33F1C0A88BEABBA2C40E0A951BF315B38BF62A0CFBFC19DDC3F78FC173ED60F2E40C58B4E3FE2AB11C08E27FFBF8B6880C00649F73FE1A34C40C7F711BEAEA71B3FC421C9BF243F6D408818FABF575C763FEF27CFC0134587C0787353C0504E57BFC20F13400BFD5D40D6C0BFC0F78A603FE43145C0246C2F409E9C5CC0CEEEA9BFE5D29EBF6F78DFBF82DB38C08F3A24BF5FCD1E404AFE23C0325214C042DBE33F82BCC03F55B5E73E6ADBB93E3F5DBABF62A0CFBFC19DDC3F786944BE411C9440EC0713C0F584FC3E8E27FFBF8B6880C08B847DC0CFCE4A40ABA89CBF6D3938407197EDBF924892BE14B1FDBF4998D33CEF27CFC0134587C0787353C0504E57BFDF0AFA3F061EF1BFB70E76C0749115C0E43145C0246C2F40D5A9EBBE924DAE40DC36CFBF7C3DF8BE82DB38C08F3A24BFFCB87BC083194940C37538C0EB18AC3F7FF960C00D68013D6DCBD5BFFB2F7D4062A0CFBFC19DDC3FB1EBD33F2672904059D3433FA3AF06BF8E27FFBF8B6880C0A30B49C05A71D840F44AA7BFB31C8640D04460BF978F95BF8818FABF575C763FEF27CFC0134587C0787353C0504E57BF00B274BF91D55E40B70E76C0749115C0E43145C0246C2F409844E0C021F156BE36C5A2C026B64E3F82DB38C08F3A24BFE1FA1CBF1FB6093E5E2586C0764981BF521FEFBF0F22D5BFFE6DE4BFBA0389BF62A0CFBFC19DDC3F5B45ACC036940940C58B4E3FE2AB11C026DF15C0CFE93EC0BD55823E6EF91B40E1F086BED6096AC0509FDBBF52024C3F8818FABF575C763FEF27CFC0134587C0787353C0504E57BFB3FEC7BFA1DA04C0B70E76C0749115C0E43145C0246C2F408378D33F47C73540067045C0F9868E3FB4B48BC073B50940AF3654C02C16A53E325214C042DBE33F9C0609BF4DEC7E3FC91BE2BFA2AE1CC02EBF98C01FBD824058E848C0D8CC8840C58B4E3FE2AB11C08E27FFBF8B6880C00649F73FE1A34C40A39978C05F2E0840D04460BF978F95BF8818FABF575C763FEF27CFC0134587C0ABEC54C0B120B4BF3374FFBE68CA3940B70E76C0749115C0E43145C0246C2F407EAB0EC0087C1E40E5D29EBF6F78DFBF5C863AC092A63B404BA0194087635CC0325214C042DBE33F029138C039ED6E3F9849783E78DA9D3AEE4791C00DC5A4BFB1EBD33F26729040131C89C0730527408E27FFBF8B6880C0FA5C713E00816EBEC7F711BEAEA71B3FD04460BF978F95BF8818FABF575C763FEF27CFC0134587C0787353C0504E57BF5A309EBF0EBC9ABEB70E76C0749115C0E43145C0246C2F40CBFE833F5B62593FE5D29EBF6F78DFBF82DB38C08F3A24BFD6102CC0496681C0499999C07D6C0DC0E0790A3FDE3EFF3FB801893F59EF6B4062A0CFBFC19DDC3F8D0BE23EE2DCA33DC58B4E3FE2AB11C08E27FFBF8B6880C00649F73FE1A34C40100AF2BFA3EEA7C0798F94BF963EFBBF8818FABF575C763FEF27CFC0134587C0144396C0381270C0CAF1553F9BBF4A40480287C002C90741E43145C0246C2F404C3C0F405BF21EBFE5D29EBF6F78DFBF82DB38C08F3A24BF90E9C0BF22C2CFBFDCE224C0E0AE89C0910A8BBF8A54823F0C9449C0276DD03F62A0CFBFC19DDC3F9F89DDC0A5EE7940C58B4E3FE2AB11C08E27FFBF8B6880C00555CC3F717894405B4A5BC0C18B46C0D04460BF978F95BF686904C0598F9CBFEF27CFC0134587C0787353C0504E57BF168952BF05C081BFB70E76C0749115C0E43145C0246C2F404C3C0F405BF21EBFE5D29EBF6F78DFBF28EE7CC0256361C06FB8EE3FD9A9CC40325214C042DBE33FB286A9C06BA22FC0B3C968BFA2EE05C062A0CFBFC19DDC3F459B833FDCF57DC08CC30CBF1993FDBF8E27FFBF8B6880C0"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
}
