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
    %6 = stablehlo.compare  GT, %3, %4,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %7 = stablehlo.imag %2 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %8 = stablehlo.imag %0#1 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %9 = stablehlo.compare  GT, %7, %8,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %10 = stablehlo.select %5, %9, %6 : tensor<20x20xi1>, tensor<20x20xi1>
    %11 = stablehlo.select %10, %2, %0#1 : tensor<20x20xi1>, tensor<20x20xcomplex<f32>>
    %12 = stablehlo.custom_call @check.eq(%11, %1) : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> tensor<i1>
    return %12 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) {
    %0 = stablehlo.constant dense<[[(6.59948683,-0.0205218326), (1.68934417,-4.55010319), (-4.95829391,0.0695202798), (-1.93205297,-0.383137375), (-5.39295959,-2.69013643), (1.31183279,-1.26421154), (3.55225873,2.16485858), (0.780973494,1.66597438), (-5.57968092,-2.7404151), (0.494648486,0.482130557), (0.184199437,3.21158409), (-1.04272175,5.07460165), (-0.704585552,-1.19216883), (1.08007777,1.55572975), (-2.706774,0.580709457), (-0.666216969,-2.13675976), (-2.5024786,2.33015609), (-0.042087663,-0.502257288), (2.4458456,3.83211851), (1.46137238,1.59804702)]]> : tensor<1x20xcomplex<f32>>
    %1 = stablehlo.constant dense<"0x394E8BBFD1ED68406A953B40D79F9740D2E78D3FBB0A873F2AB715C00247A240C9815040AF9B7DC093424740C17860BFB95431C041363940E00533C0678806C0A3E50EC09C4A8A40396F1C40F37F8340AE01644034BB9840880F3F407E85F93F729FC73F71C5FCBFD0113D4059946BC0112C9940174A003F706C864017107F3F376463C0F6C3033FC96BC73E0ECEA7BFA1C02C401D61073FFAF104C073479C3D374C0BC17245B3C0FB33C83F6794824089F139C027A80C3F9F89A03F9E80FABE31D268BF348E8CC065DD7D40FE93BAC0B15A40BFA66A1CC0024313C0726C03C01888593FA66AEBBF90B1D63FEEFD1C418F91D73F6D974A3FFA23423FE6CE823F84130C3F8C3829C0DC90A5BE1584134028DA96C0234A6140C9AA8D3AC8838B3F36978840BD01FCBEEE8759C0F9DC19BF8EE37CBE983E36BF1DCBBDBEB80E6BC04A4C25403A4C09C00F169CC082B3D6BFDC9B8340F858A3BF15C2A2BED5988E3FEBF06540A8DD56C0E6700CC0577F31C0DA6FB9BF83ACE9BF21058F40CE41A1C0188244C07B0587C0DE82BB40323F143E137C643FF69C9DC07CAA853F2F4E9E408612C73F7E51FC40130A2840C3F93BC0F7B28A4025A1D13F87CE3C401EA591C0EEB5B3C0D20192BE5FF669BE7BF9114060F8BC3D6A94ECBFC2D116BFA2100EC06A2D70C0D15151C0A3384A3FDD6D233F91BAA43FE95018403A98C1406F68A5BF5ADF9E3FF36EB14044434D40937CFA3FC82ABABF9D9687C00FEE8BBFC4F2BFC0BD40A54038ED7FC01747023F534447C015D7A5BF9DBB95C014CB98BF1A562040F1644740747706C052E3AEC0F4DFDBBF2313C5C0887033C07EA580C0644E68401B67BA3EFEDA7B40B8DE1AC0ACA58640EFB9654047073BBD82453840A1E399C023A58EBED62F8E3F02DF403FC168984038BB5B4028FB28407A3788BF2B10A840633ED0BEC3C2114045BB8440C3BCA040E7A420BF35D4EC400FCCDABF3AF0AA3D9E25FB3F5DFAC3BF93E881C0D192E9BFC5AA4940AB43C4BF198C523F4CC5AE3F5EEE14C037C215C00F20143D175A8A3FD08953BFB09813BF09DFD940AA72A5C091A1E93FA63AA84088991640629381C02EC3253F8F38A73EA490A540A97085407C945F3E54530C3E73E4FFC0AB72E83F36FA71406BD567BF6D007DC06193FDBF307F8CC04CE203C0AE2C6C3F26D8B33FCB50D2BF502725BF822828C0128CA04074178FC0F831A83F0030363F73971E402C39C43F5DDD84BD50C0C9BF8107554033CDCFC0CD6080BE5021E53F9317A6BFC59F7CC01B627E4015E7203F49D54540D6098AC0AE5679C0D9C430C0D56D39406DDC29BFF53E7F408A4168406BCBD0C079DDA740679C493FD4AC0D3F019C7EBFE84D38BFB77EBBC0FE451B3F26EFB23FECAAE73F7605F53F85B16BC0B458C44076E9CFBF616C7840714317C1BB602A4059905D40117D63C01F9FF93F7F106F3FBF599CBE4BAC94402C8E813FC832334099BEFE40E285B2401C9C44405010E040ED5F8DBFB40D93BFCBFD1740298BC44069B060BFD77668BF5F21F9BE4BDE1040BD671FBFA5FAB53E650AC83FA73B403E82A6553FE41D26C0601CCD3F0B0D2E407EE596BFD3CC47C0FBAE33C0B8047CBF06F8BA3F5758C5BF139D6C3F58E3613FFA728D40FD27874070AB0841CBC8993F6C927FC0C6EF88BEE5818740BA7CC13E7F2686BF0C5FE1405D9C0DBF01CA283FF720463F608DE6C02ACAAE3F4A5E39BE468EC340217CD6C09D6DA73F88D786C063021A3DAB64A6BFF4F8CC3E63B6B5BF9E61B83FCA5A6BC02206C540C23881C0BA6F4340D260D93FF4D8EA3FDDCFB2C09B61824036FD2BBE4CE2653FC0D2304049BC30BE49FC4B3ED06597C0AD003B3F0CA31DC01D3300BE3C0F7E3FA1AC9EC0291007C0B1F9D23D59DFCB3E4BB32DC01B3035C002DAD84038885CC0ED91C93FCAB7D0BFE2CFA4BF9DF8144097E9E23FEAA368C0C6D60A4093C16CC0384C923E97F683401EB16E404BAB6DC0C63E4BC0A6E992BFC8EAC9409E6D0640344F914012371EBFE690B9BFBC2CB5BD0CF68440073F14406F327F3FC6E15640636F76C0AEE0463E55766940C8DA7BC00E3915C045467ABE385F8ABF56A3E8BFEF0776402B7A283EA4DB4F40EF4987BF2F3B593F2AC6B8C003BA303EC3498C3FA356854033FA30C06B8B50BE58C9D33F20328DC04E22F13E07665040C79D003F3EA30A40B77273404BBD073EFE57A9BE1DCF9E40F10239C0D1B982C0A81982C0D95EE5BFD1C91B3F6FA4514077138740B57406C197A035C0266B0CC0AE2F67401C2CBE3FB601E540AE9A5FC025A8B940761A9B400BC590BF3A3F873F2B4C9DBDAF0842408E750BC057ECA33F2C8A6FC0E7751FC0B9C504C03C3ED4C0B21CCC40449C9DBF662522C0153492BF61AA3EC048F354BF4C89314019A3C13F9348C6BFE77FBBBF62C111409EF7BC3F2F0E6AC0E5652EBE522693C0F9A298C004684B4076FE3AC0AB5604C0B56322C0CAF17F407DD79D3F8534CF3FE31FD0BF0B3D5240D05A4140A343473E32918340AA542AC065D9A2BF51EA1FC024B19B40DF23F1BFC4F6F43E32DAE5BE0870B5C009048D3F8DB446BF537B66C008AD2E4085E0C040FAC80740572CAB405F9A4ABF40371740B193C3408C365C401BB24CC0AEE1B93FA65F9DC0C345DBBFF7A835C0F804BBBE84A74340D1934140A2D0DC3E90AD15C09D7D7C3F1C479C3F45255340317312BCB34A91407D3AA2BE629194C077C573C0F6ECA1BF1B6878BF0C7AD940B32698BE5A8D903F8433893F22EC19C060D18140A57D5740EE185540469DEABF905FA9C0455221C06860B7BFFF9010BF13000340D02565400750DEBF7AAE7940CEBD674002AC0FC16A0212BF3FBF253FD0CB90C0E40E98BF0BAC0BBF25C94FC0C8ACD5BF9CD0AD3FCEE327BF4BEC8E3FB13134C0CC21C03FFB0B9F40BE5607C05EFC96BF36A84F3F552EA3BFFFD3073FAB7A283FD60E9E3F5093F43FEACC6DBF00CA2DC03B4BAC409FDBB6404649A4C0AAFBD940636C513F753782BE00D423C0DD642F40A579F13FF664F2BF3CFA5AC024E9C13CD69787C03B5EDEBF3B209C408C11F03F70F669C0001FB5BFCF8701C1F1F91ABF9D759E404B276FBFF6C4D040F2059140674F47C037B0F43F03CB33C0E8C678C0B02E0940444386C0DEAB7040A4A91FC0D1148FC053F67BBF900454C0DB0AE4BF01D9A7BE1F76F1BFB09954BF0D4DDA3EF2DEDCC029880D403EF3C8405F73BF40F85157C0FBEC34C08C9C92BFB91FFDBF4A3C8C407751C1C0E71E7F3F516FFABF1ADEAA40E6A13540AF346EC0A8061F4007636840581F1B4054C40240140F5040B20160403A969ABEF713D53F64B49F3F1CE85E3FD407974007C55D408746AE40956C253FC47DF03F89028A3DAABF1BBF3E47C2BF5CCD464008401440925655C0585FFB3E362CBD3F6EA94EC04009B940355AC23F74C10CC035639E3BD9C04F3F149F6E3D49C260BF7E7328C0D396A73E21FF3D40E6D51CBF8A43BBBF73B01DC08985203F9B147240583DE93F37479D3C39167A3F13F5F0BD9629D03E772A0AC03347D340BD81963C588430C0B78C68C06D352A3FD34DB7BFD7AB603FDCAFEBBFB2B12840C456CD408694653FC2DFD23FA641B3BFDCE89A4071AAA140C41FB2BFF2F022C0EE94B53FDF474140A9AA62407E562B3F57A83F409A751940425AC2BE5A0731BFDC7D1240004234C092F10EC018AC3EBF796BABBF7B640640532C4F3EEC352C3F51480C3F94519640F56321C0A2B09140B4F758C0CEA144BCD971C43FA27D80BFBBFB98C07B1EC13ED17E24BE2CD84DC09DCA15C06112A94028860CC0F8654640A0139B3E1C59F93E67EB2B40557F2C40DB5923408DCFB83E6C9C8EBFD681AB40699487C002A5B2BF1B78D43F7CD5A63F0955A63F71409740299FE7BFBB9532BFD8669C3EB8B2E3BFB60F72C0821447C044C985BF829C093E5BB5A6BF05AD42BCF06374C068C43F40DFC9983F7701CA400EB8B8BC23793CC06A103FC0283A8B40D294F5BF34CC37403DA80EC0FACCACBF0DC103C0DD689240ABEB9E40C58519BF1039353E889B06BF660BF13DE129C63FFFD104403E6776C075459CC029CA7040A8628DBFA3827740334E95BDA4B605402A6F4CBF843517BFADAFEBBE1400E13E2ACB95406CC6D9BE5069AC4055149E3F43F228404FF0C73F241B69C023B8ED3F65662640CD41DC40F561A3BECB43FA3E271B783E5901333E22A60EBF161A4740A83186400E676BC09B8E20C075D3943D39EBD0C080669CBFB592D73F8D66724059B290BF01E8D0C0625FB03F407230C0E53112C1C44C684032E419400B7E36C0BF8E7ABF8763AC40F2C6B13E17E13BC0ED55D63FDBB2394034F58AC073C5DD40F756763F9C8DDDBFC6F0953F1FF88F405B472ABF128E813F001AD2C0C4E808C01392F1BFB160FDBFBB654FC06F0DC3C0AD6E05C050E997C034F5A6C0EC13A4BD8E31FF3E50588340772693BECA5A29C079368D3FEBA31A40E0644740D2762BC0"> : tensor<20x20xcomplex<f32>>
    return %0, %1 : tensor<1x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0xFF2ED340671DA8BC6A953B40D79F9740D2E78D3FBB0A873F834DF7BF952AC4BEC9815040AF9B7DC093424740C17860BF355863400B8D0A40E1ED473FA63ED53FA3E50EC09C4A8A40396F1C40F37F8340AE01644034BB9840880F3F407E85F93F729FC73F71C5FCBFD0113D4059946BC0112C9940174A003F706C864017107F3F9C2820C047211540C96BC73E0ECEA7BFA1C02C401D61073F400EBB3FCE8CCC3FFF2ED340671DA8BC6E3CD83F729A91C089F139C027A80C3F9F89A03F9E80FABE31D268BF348E8CC065DD7D40FE93BAC0355863400B8D0A40E1ED473FA63ED53F1888593FA66AEBBF90B1D63FEEFD1C418F91D73F6D974A3FFA23423FE6CE823F84130C3F8C3829C0FD3F8A3F2722C73FC93B2DC060A9143FC9AA8D3AC8838B3F36978840BD01FCBE1D642CBDEF9300BFBC881C406E417540400EBB3FCE8CCC3FFF2ED340671DA8BC6E3CD83F729A91C0DC9B8340F858A3BF15C2A2BED5988E3FEBF06540A8DD56C023EAA73FAFD1A1BF355863400B8D0A4021058F40CE41A1C0188244C07B0587C0DE82BB40323F143E137C643FF69C9DC07CAA853F2F4E9E408612C73F7E51FC40130A2840C3F93BC0F7B28A4025A1D13F87CE3C401EA591C09C2820C0472115401D642CBDEF9300BFBC881C406E417540400EBB3FCE8CCC3FFF2ED340671DA8BC6E3CD83F729A91C091BAA43FE95018403A98C1406F68A5BF5ADF9E3FF36EB14044434D40937CFA3F355863400B8D0A40E1ED473FA63ED53FBD40A54038ED7FC01747023F534447C0C79E3C3E988A4D40E87785BF2363A240F1644740747706C0FD3F8A3F2722C73FC93B2DC060A9143F328D2ABFACC008C01B67BA3EFEDA7B401D642CBDEF9300BFEFB9654047073BBD82453840A1E399C0FF2ED340671DA8BC6E3CD83F729A91C038BB5B4028FB28407A3788BF2B10A840633ED0BEC3C2114045BB8440C3BCA040355863400B8D0A40E1ED473FA63ED53F9E25FB3F5DFAC3BF9142FD3ED1D9F63EC5AA4940AB43C4BF198C523F4CC5AE3FB85F34BFFD9898BFFD3F8A3F2722C73FD08953BFB09813BF09DFD940AA72A5C091A1E93FA63AA84088991640629381C0BC881C406E417540A490A540A9708540FF2ED340671DA8BC6E3CD83F729A91C036FA71406BD567BF834DF7BF952AC4BE307F8CC04CE203C023EAA73FAFD1A1BF355863400B8D0A40E1ED473FA63ED53F74178FC0F831A83F0030363F73971E402C39C43F5DDD84BDE87785BF2363A240B85F34BFFD9898BF5021E53F9317A6BFC93B2DC060A9143F15E7203F49D545409C2820C0472115401D642CBDEF9300BFBC881C406E4175408A4168406BCBD0C0FF2ED340671DA8BC6E3CD83F729A91C0E84D38BFB77EBBC0FE451B3F26EFB23FECAAE73F7605F53F23EAA73FAFD1A1BF355863400B8D0A40E1ED473FA63ED53F59905D40117D63C01F9FF93F7F106F3FC79E3C3E988A4D402C8E813FC832334099BEFE40E285B2401C9C44405010E040ED5F8DBFB40D93BFCBFD1740298BC44069B060BFD77668BF1D642CBDEF9300BFBC881C406E417540650AC83FA73B403EFF2ED340671DA8BC6E3CD83F729A91C07EE596BFD3CC47C0834DF7BF952AC4BE06F8BA3F5758C5BF23EAA73FAFD1A1BFFA728D40FD27874070AB0841CBC8993F6C927FC0C6EF88BEE5818740BA7CC13EC79E3C3E988A4D405D9C0DBF01CA283FF720463F608DE6C02ACAAE3F4A5E39BE468EC340217CD6C09D6DA73F88D786C063021A3DAB64A6BFF4F8CC3E63B6B5BFBC881C406E4175402206C540C23881C0FF2ED340671DA8BCF4D8EA3FDDCFB2C09B61824036FD2BBE4CE2653FC0D2304049BC30BE49FC4B3E23EAA73FAFD1A1BF355863400B8D0A403C0F7E3FA1AC9EC0291007C0B1F9D23D9142FD3ED1D9F63EC79E3C3E988A4D40E87785BF2363A240B85F34BFFD9898BF9DF8144097E9E23FC93B2DC060A9143F328D2ABFACC008C097F683401EB16E401D642CBDEF9300BFBC881C406E4175409E6D0640344F9140FF2ED340671DA8BC6E3CD83F729A91C0073F14406F327F3FC6E15640636F76C0AEE0463E5576694023EAA73FAFD1A1BF355863400B8D0A40E1ED473FA63ED53F2B7A283EA4DB4F409142FD3ED1D9F63EC79E3C3E988A4D40C3498C3FA3568540B85F34BFFD9898BF58C9D33F20328DC04E22F13E07665040C79D003F3EA30A40B77273404BBD073E1D642CBDEF9300BFBC881C406E417540400EBB3FCE8CCC3FFF2ED340671DA8BC77138740B57406C197A035C0266B0CC0AE2F67401C2CBE3FB601E540AE9A5FC025A8B940761A9B40355863400B8D0A40E1ED473FA63ED53F8E750BC057ECA33F9142FD3ED1D9F63EC79E3C3E988A4D40B21CCC40449C9DBFB85F34BFFD9898BFFD3F8A3F2722C73F4C89314019A3C13F328D2ABFACC008C062C111409EF7BC3F1D642CBDEF9300BFBC881C406E41754004684B4076FE3AC0FF2ED340671DA8BCCAF17F407DD79D3F8534CF3FE31FD0BF0B3D5240D05A4140A343473E3291834023EAA73FAFD1A1BF355863400B8D0A40E1ED473FA63ED53F32DAE5BE0870B5C009048D3F8DB446BFC79E3C3E988A4D4085E0C040FAC80740572CAB405F9A4ABF40371740B193C3408C365C401BB24CC0AEE1B93FA65F9DC0C345DBBFF7A835C01D642CBDEF9300BFD1934140A2D0DC3E400EBB3FCE8CCC3FFF2ED340671DA8BC6E3CD83F729A91C07D3AA2BE629194C0834DF7BF952AC4BE1B6878BF0C7AD94023EAA73FAFD1A1BF355863400B8D0A4060D18140A57D5740EE185540469DEABF9142FD3ED1D9F63EC79E3C3E988A4D4013000340D0256540B85F34BFFD9898BFCEBD674002AC0FC16A0212BF3FBF253F328D2ABFACC008C00BAC0BBF25C94FC01D642CBDEF9300BFBC881C406E417540400EBB3FCE8CCC3FFF2ED340671DA8BC6E3CD83F729A91C0552EA3BFFFD3073FAB7A283FD60E9E3F5093F43FEACC6DBF23EAA73FAFD1A1BF9FDBB6404649A4C0AAFBD940636C513F753782BE00D423C0DD642F40A579F13FC79E3C3E988A4D4024E9C13CD69787C0B85F34BFFD9898BF8C11F03F70F669C0001FB5BFCF8701C1F1F91ABF9D759E404B276FBFF6C4D040F2059140674F47C0BC881C406E417540400EBB3FCE8CCC3FFF2ED340671DA8BC6E3CD83F729A91C053F67BBF900454C0DB0AE4BF01D9A7BE1F76F1BFB09954BF23EAA73FAFD1A1BF355863400B8D0A405F73BF40F85157C0FBEC34C08C9C92BF9142FD3ED1D9F63EC79E3C3E988A4D40E87785BF2363A240E6A13540AF346EC0A8061F4007636840581F1B4054C40240140F5040B20160403A969ABEF713D53F64B49F3F1CE85E3FD407974007C55D408746AE40956C253FFF2ED340671DA8BC6E3CD83F729A91C05CCD464008401440834DF7BF952AC4BE362CBD3F6EA94EC04009B940355AC23F355863400B8D0A40D9C04F3F149F6E3D49C260BF7E7328C09142FD3ED1D9F63EC79E3C3E988A4D40E87785BF2363A2409B147240583DE93FFD3F8A3F2722C73F13F5F0BD9629D03E328D2ABFACC008C0BD81963C588430C01D642CBDEF9300BFBC881C406E417540400EBB3FCE8CCC3FFF2ED340671DA8BC6E3CD83F729A91C0DCE89A4071AAA140C41FB2BFF2F022C0EE94B53FDF474140A9AA62407E562B3F355863400B8D0A40E1ED473FA63ED53FDC7D1240004234C09142FD3ED1D9F63EC79E3C3E988A4D40532C4F3EEC352C3F51480C3F94519640FD3F8A3F2722C73FC93B2DC060A9143FD971C43FA27D80BF9C2820C0472115401D642CBDEF9300BFBC881C406E417540400EBB3FCE8CCC3FFF2ED340671DA8BC67EB2B40557F2C40DB5923408DCFB83E6C9C8EBFD681AB40699487C002A5B2BF1B78D43F7CD5A63F355863400B8D0A40E1ED473FA63ED53FD8669C3EB8B2E3BF9142FD3ED1D9F63EC79E3C3E988A4D40E87785BF2363A240B85F34BFFD9898BFDFC9983F7701CA400EB8B8BC23793CC0328D2ABFACC008C0D294F5BF34CC37401D642CBDEF9300BFBC881C406E417540ABEB9E40C58519BFFF2ED340671DA8BC6E3CD83F729A91C0FFD104403E6776C0834DF7BF952AC4BEA8628DBFA382774023EAA73FAFD1A1BF355863400B8D0A40E1ED473FA63ED53F2ACB95406CC6D9BE5069AC4055149E3F43F228404FF0C73FE87785BF2363A24065662640CD41DC40FD3F8A3F2722C73F271B783E5901333E22A60EBF161A4740A83186400E676BC01D642CBDEF9300BFBC881C406E417540B592D73F8D667240FF2ED340671DA8BC6E3CD83F729A91C058AA9EC0A6608E3D32E419400B7E36C0BF8E7ABF8763AC4023EAA73FAFD1A1BF355863400B8D0A40E1ED473FA63ED53FF756763F9C8DDDBFC6F0953F1FF88F40C79E3C3E988A4D40E87785BF2363A240B85F34BFFD9898BFFD3F8A3F2722C73FAD6E05C050E997C0328D2ABFACC008C08E31FF3E505883401D642CBDEF9300BFBC881C406E417540E0644740D2762BC0"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
}
