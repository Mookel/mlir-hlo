// RUN: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xf32>, tensor<20x20xf32>)
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.add %0#0, %0#1 : tensor<20x20xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xf32>, tensor<20x20xf32>) {
    %0 = stablehlo.constant dense<"0x35602240D43E24BF230A664032AA56C08D6558C0826199BF6B68C0407B864BC099DD9B4034C07EBFCFF0D5C034CCBABE984F123D67BB1240C7E72AC0E523C640FD6A76C0BCF240C040ECA3BF781C4AC0365C203E274AD0C081F6F4BE17D3BF3F3E70D43FA6B8CFC022E4CF3E4B2502C0110A91BFE402DABF3DAC4FC08AC7F6C0ECE1E33F1D86DEBF4BF09DBF28B16540BE21513F17007A3DEEFB90C04A47F0C055498C3FE0A64F4029D18A40F4A9763F5B17AA40279E593E1B604740AB789D40960BE5C09583B33E010ADBBF3FF7C2BF86A9A7407A02954062C84DC0E8B8C73F0E00823F7C6D7D40884BC1BF85D03B3E55446EBFAD45D1BF963FEC3E381FBABF5D71393FC2176BC038B38AC033BD2840031560C01A7FA2C0444623C06E2AD33F9AAF6A3E96B08340E65075BD4DE0AEBCA110554085D341BDD38AB4C0C80B82C08A2A073EF3C08E3FA4E0E53E1BBA8540925B6AC0B2478E3E2FC69B3E869163C0C9C3EA3FE1AAAF3F9D1242BFC0FA5C408E36863F848D81BEC90504C0BAB14B4066528640F7C687C0A02C9A4041176FC0D88868402CBBDBBF8E7280BFB9CC6AC0B8BA183FD1657EC010E5D2BF361E02BFD45A83C0E5FD3840309C04BFDDA90840853BD9BF796BF7C075218FBF81653FC0D54E1AC09F888840F0A28A4011AD9FC09000D7BF0B4776C00A6795C0BF6DC7BF900AFDBF94A725402F7603C05BBD98C0F69A80C005DA89C00F5689C0C15A9CBF8EF314BF2F253E40BB732E3FC34B393EFE492CC0B09DE4BFFDC435C0107F833E6DA9EE3FBAC263BFB67C2EC07528B340093D90409A2214BF52D6C8BFF583553FE079A53F872C96C031F598BF3A8EE0BF4EB386401598ECBF8CED47C00422DE3E09E5623EDF344FBF4A08CABF7DA77640D71C82403B0124C0574ECDC099899C4023FE2840D98440C0594F90C0F8E0644063DEB24025D8C3BF3D478EBFE96B6BBE74E59EC09BAF0AC074EE443F5D2802BE30D36A403461DDBFDDA43140477B8FBD7D278F3C520450BFF6D42B3FD4BBAC405406FCBE3CF78BC0B1D52FBF6B04B5BFA105B540A7166FBF01E4D3BF807806C04E8CA7C0C41EA340B8BA10400AECD6BF9FB88FC069F4674028BE57BF64BB863FB12F5EC0DC466F3F8CC32D40C6C924C02D9F87C01374074032F34B4069C282C0669BE53CB3CE73403471CDBF2772D2BFDD21694069E80F3F582AA9BF16E5E8BE48453F4018905CBE8142B040504905C01F761140C1AA884038D27DBF0CA020C003A729BF99C2B54025C163C0CDFC77C01356CD3F1C1851C0365C31C01E9923C09349F3407D7B2CC01DB567BFC93027BDB31B95401D470DC056AA4040ABC6C73FE82133C032D187C0A7664440C1F0CEBD101C6CC0ED3E60402B3C714088539E3E07203FC044768740FD54A13DB6F01A400FB5B53FBCA202BD6DB1323EB4B00FC02A0655C0A52127C025EDFABC50B85AC0C0F554C01322663F6084204069ADF53F1C42DABFD4AF7C3FBA91F8BFE491F73ED6B6C9BE6BB24D4000DB0440FAA0913F391287C0DC08D73E024D44C01817EBBFAD1680BF0660A4BF422F1E407C4292C0E73176C03757E7408BF7E33F5A18A34082A6A2C08CFFAFBFDB173D3F622B0FBE05DA86BD0BAF17C074E250406E882ABF3F0F8340AB1104BF17648DBFC2ACBF3D11D08F4015F1ECC01ACF77C07A5448C055B31840A982DB3F375CD0BF5DA3F83F397552C0A07526BF909678C0F1E14BBF639638BF2129F7BF46AE6940A9411D40F0DB923F9274DCBFED4F64BEB69F973F87DDA0BF4183F6BFCEA2DFBF318DB44015BDDEBD4DA8203F760DB9BEEA9466BF4F3E90BF54533CBFD23E98BF0990A0BFF8E595C03042EEBEB5CC263FA7E052C0357E8E403FF2C140BAB23A40484CBDC0D48CFF3EA760AA3EE5EE26C05635C93FC964CCBE2DBB2CC0E00D03C023E7843EB3582AC0C18F1F404D5BF8BFD0F8BF3FEC080EC0921CEBC0D48B4F3FE4F4A740D93E5ABF07D87F3F50848DC0DC29F7BFBC22944043FC0E3F3B47FABF99BECBBEAD8EB7BFCC9D2C3F00BB83C0F4B737C0D54F32BF3BB8B5C0F9EB47C0A67E8A3DC9092340CCF65BBFF68C23C0407380C05FD513C092791BC07A317BC0AF629CBF6210FF3F1DDA05C0806D45401C1484C0F4A5DFBFBBBF96BF629918C05258C5BFB6D689C0CA2ADEBF05C0D13EF726B53F67E0DBBF016C873F745A2DBFB94046BF8DE79CC02340214053251AC02C92893E92C617C0DCE91BC0BC4820C0D2240940"> : tensor<20x20xf32>
    %1 = stablehlo.constant dense<"0xDBCC0B40D98FA1BFF3DED3BFB1E21DBE36B4FEBF92FC8C3F472390404E34CBC0889AB0BF074284BE3318AE3FA297524069ED6BC0CDB14840FABF2EC04B5904BF1E1BE0BF41323440C66C67C05E0F93C0F7164F3F7B5CCCC0ADF000401DFA04405F975540AFB20D408DF696C0C27A9A3FFFCD883FEC1FABC03E7259C061F312406B8FBDBF197E4240AED49CBF7B3009C0F3219740225BA540B2F68A40E09293BF1317173F9F85203FA442CC3F94F68AC083396D3F2C14973F5D8A82BF4D11114064AB29C0231721C085AD7540B727943FCF49BB3F2BD07BBFAD01B4C08595603F07FB23BE101F8240F26A13C0C64B9ABF9F9F1EC03F347C3D4072EA3F915014C05D5CCD4099A0FD3F9C89B6BF0BCEFC3E3DE71940E6C4C7BE072A01C0A6F22340EDDD34C03B5F4AC043DD2B40324647C0932FB54050A349C0C7F567400C86FEBF34ABE2BE46C3C0BFC641813F4F04F6BFF4877F3E866029C020B99B3F8A6D70BF7E55D23F0148153F085A3040942CDCBDF66E0EC033A8A240C2036BC08904D6C0A7084940FB9A95405BCE6EC04F09DBBF4ED14E3E4AAA12C0AEA71B4094C420C0BAB26AC0BEA75C40D78084BF5DF58740C3F49340E8B7B8BFCAEF0C406FB186BFF5209BBE9ACB993E937B1A40EE159F3F8FBBEF3D82056CBE16999EC0A74A353E4E5ACFBF58F4A0BF03AB90BFD7B54CBF174ACC3F6A6438BE00A7C63FC40C32C0AD8781BF927A5540E0EE76406F1DB1C0B25252402F732EC00B18D4BF49DB12C0ACB9F53EB82227C02EDC8640FB3FD6C0CBAA1D3F61CFF43FF8C797BFC18E4B406A46EBBFD0A159C0A78F3FC06BF790C0139E3E40E06C354000566DC013CA3DC02E0CBEBF4E93D1BF340ADABE126AF2BF5E598CBFEFA9E6C051DFB5BF81BD15C0FBB98A3F0F51FF3FA3E91C3EBC67AE40FA2D20C0DD7B37BFC72878C066782CC0DF99A4C03D37073F5CAA18404EAD8DBE23F38F4074372F3FE5CAD03FA7E950402CBA0DC02620263F0DE985BF90C065BFA41895BE41A4274022F9E4BE60870CC01081E440801E39C0D841C03FDCE5FB3FC3D39C403EB386BF526AA9BF61C69FC06C3897C07ED7C83F3C8D93402422AE3FFA467FBFE5685E3F5BC6993F29F96740407B21408AB2404083C5034088B2F33F8E3400BD963FD1BCD23DDEBE3DD059C0E2A8AEBD92AB68C0D8A009405EB133BED5D9EC3FE6B16B40EA4862C084D507C0E36361BFD52D60BEB4B13B40E0CC44C0DA4E8DC01DFE28C0327470C029D450409263E83FA6FDA940811BA7BFFF51AD3F66C4C5C054C8DBBF2DDC203FB1A05C3F604D973F79E34EC00548E23FDB12B13F8AB6CDBF1EF85CC04278593F1BDBB5BFAE6DC140A21A404003F09AC08394A6C0BB5D513FD60B573FCBF847C03520DEBF715C82404C505BC092CD07C1C9818EC03AE53840550854C045EF9FBF8E05E8BF7CF38D40834907C0D86941BE70E3BA3F30216ABF2DC298C0434CB63FD88C203FB9B515C0D050CBBF8D707AC092E94DC09E79AFC0935097C028A8ED3EF5639C3E093EB0BF8FE74140EE349640F3E6E1C038C1A83FA4AB16C0322701BE690CC13F34879F40909FAD409191CEBFA3C20FC043596FBF15EE903FAA9237BF329FC4BF2665F93F3FAB533D9483C8BE06350B4057A8BF3F0A97BE403F019F3FF0DA4940180D3D3FF86DBE40A98B463ED4769EBFD22E2BC03DA5F7BF5AF70F3FCFC6EE3E25A73140868732BFB6E913404CA61BBF0F27D03F58962B40151ADC3F62D7CFBE7B4E3DBD807196BF65EA23BF86F922C070E2983EB51B9FC00C9999BD0D68B93FCF3D11C0E90977BFD3AA69C0101C8BBF8F2D1140026C2140DBE2943F40ACC8401F69BA3DD067CABD651C2DBFB0276F3F0FD72C3FB8537FC079D709BFEECA5B4060E212BF9432C7BFB84E9F3F351DB73E065807C05B76D03F4C74A53FC9C010C09B4B7340079093BF2A53913E965DB54022FC4FC0F4150CBEBC7982BFB3EB19C01F2F15C0ADC05F3F495A973E38F87D40AA79A73F8D105DC0DE9FF03E656C6FBFDCE96A40A16B81BF8438DE3FFE0926406A09513F31DCB740D45F59BF45F9034003D621BF4ED59640780D61C08D4DF5BF7ECBBE3E5B0C2D404324EDBF29095FC0B65B8E40ED4D9B40E77D8740CA485140A6D87FC0D8423B404B5AD5C04D0DB6BF106B64BE2C665FC0ACAA5AC0F0FEBC3F62F2D1BF3E586CC08EC866C035F6B2BED6D80AC05D2B51C0B47274BF2B320740171BE0BF44AD5F40C2A2913F3F81FA3F"> : tensor<20x20xf32>
    return %0, %1 : tensor<20x20xf32>, tensor<20x20xf32>
  }
  func.func private @expected() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0x8816974043AFF3BF5335F83F5D8860C0D4DFABC0004FC6BDD9452841C67B18C1EE6D5F409C70A0BFC26AAAC01C3E3B402BA469C09AB6AD40E0D3ACC0BC98B540463CB3C0B0074CBE73B19CC09A1DF8C0042E773F51534EC1BAA3C43FA8E36440BFE79F404EDF88C04BF889C0A89F53BF20C183BDA5A0E1C03E8FD4C0DA4DADC0044A993E1576A63F7C621DC05A01B93F2B46B140224FA74080A740BE01960AC1DED4D73F48C87740D2E1BD40AB4258C08BBEC740F147B23FEC1A06405201E640A4F01CC1B0A60AC084280840203EBBBEFA7BD640E9106B40EF720DC1D5011C405A015B3FE76A0041B61074C0B5D182BFB4305AC00B64C9BF13C112402D6071C0898AE440EB8ED8BF9F55B8C0F45648408C5B8CBF68FBAEC0263892C0EEC38640F33226C0C407743FFF072840F3A348C0F2DB0F419EAA4CC0DF1F01C04BADC1C0EF159FBE4C09C8BEEFB9BA3F0E72104013635AC0909717C0ACAAC23F74D68FC0A48C5E40E24EFA3FC2AAFF3F5B1956405EA796BF5B8F9A40C684B7C0585760C0BAD6EA404040DD3ECA158B3FF44DAEC0ED757540F04380C0CEDCB63FA6C8C5C00C8444C04CF806BFF4B22BC02C636F4078CF043FE243B93F7C91D73F4BA28A3FE10100C0BFCEEDC0B1D5A53F14B5DFBFF9D012C07328814030B11FBFBC029AC06F2D53C09C60A3C0CB91B9C055E416C0E401C3BE4D211A40BC8A00BFBDC3F1C0E1FCA0C0E0E578BFF0E9DDBE1F34D8C0CE152D4000207B3E5BBC79BF8D4607C0C8920DC0C8B88CC0BEE6AF3F0A08CEC069BF1E4004EE823FB2607AC0EB770C41DDD62A4076AA7EC068FD91C0D98D6CC082AD88405CD8EDBF4CE89CC0980897C085602E40B2155FC0D22E63C091E1BABF7AF95FBF454800C1CEF33FC0F8D3C13F56CBA440CE6211BF0A67C8C0AA78254190020D3ED0636EC0DE3106C148A2613F4048E43E863C80BF7B0DA33FA1B101BF1025EFBE7CC3BDBF10A1194021C748400832BA3F21518ABFAD60DD3FF9AF77BF2C268CBE5946E73F9461653E48F04C40ABC0D4407C86E8C0FFAD503FE2C20D3FB2EC2841923EFEBF2AA73EC0A102E3C05D621FC1A454D54098EADB409827A3BE7EA1AFC051C78F401C9DB73E6EAB9540C4D172BF41847C4088C4984008C22BBF969F88C094D10540782B304088AAEFC011846ABD1032323EF8A00B3F53E8E8BF64C7AF4000D687400B6F9BC027F224C04FEC0640F65EDEBEAE0D0741180BA5C0952709C0CAAED03F60F497C074D0403F1090933F20E02F4173A79BC0CE5321C0E16E92C0237E9FC02B2509C0E4E1D8BF768E0C417BAFBDC0EDDA5C3F55D9AB3F215C43409E1FB5C066087740805C0F3E74B94F40840F9FBFBEF2E2BF46D0A9C0A1C437C0F1008B40800D253F538BB6BFB6318B3FF0704E3FE88A06C1DC1202C0E1DF8940E01256C0179989BFBED981C09CC18D3F943597C07DC760BE308DFABF06BF87C0D5FB77C082AA7B40EAF92240646B81C0CCF119BFB55CBBC056F72EC00B15BCC076DDC1BF05902240F7B9B83FBB21B3C0AAC85C40B439D03F5C560EC12CAAA23EA7DB68C0CF1C1640C4FE43C002B9913F647B4A41D02F2B3E116E3640AA91C0C0B88B78BE20A6B03C9E84D6BF86F7F03F5E6014C002D23740D525C13F55F9B240D514AE4040E90C3E56D84F40B471A740740CBABF5F666BC0F2C78BC0E8DB93BEA01461BE8A6088BF882A1A40503803BF937EACBFB459C9BF1EC4B3BFBBB7673F1E07403FA8DDAB40BD4603407CF18C3F097339C060FE5CBF5653AEBFD64975BF85BCDCC05F3CE9BF34E7E240B83318C038C3ACBE416680C08566FEBFCF1C923F5AAEE43FC0FDD6BC3E88A04054FC92C0126E10BF00F6C9BCBB1617C01719A440C6900440DC3C1840A2CD1EC0B0DF98BD6A9A9CBF128FAEBFA3FCF63F9FE420C0FFFF88BFE84E41BFE52300C0D0E5913F7B8FAB3F8206D4BFCA5BE5408702AFC0427DEFC0909E55BE15FE3540D5BE4BC05ACCEF3FAB0E84C04A6302402601BE407C5139C0441FBEBFD9A5AABF86220F40EC72ACBEBE5918C0B06F8DBEA8CCF53D80FD883DEE437EC03A4D08409028F53FE9AC7640374DC2C0A3C6BDC0DEF7F7BF48968C3ECEE1B8C0409D96C0CE1FCE40BDC13040A734EA40B87D5BBFD0D5B7C0F5C5DF3F7ED310C1D0B23DC00EFA90C0C83DA7C0AB7240C0F412394064E956C03EA228C0960F89C0EADD8FBFF853E2C0E8AC3FBF004257C0706418400FEA83C0D086873FB6EEAEBFB9328340"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
}
