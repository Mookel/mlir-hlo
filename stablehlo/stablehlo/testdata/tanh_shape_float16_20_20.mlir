// RUN: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = stablehlo.tanh %0 : tensor<20x20xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x9C41913D3BA376C505C79938B94158C40FC4F03D2344A3BD77C0B8BFADC1383C1643FA387BBC51C1B3C0C5B859BA30C47D411BBD8DC1F24726C161C43B45352A9C3AD3C294BA79C018ACA1C31447583E7FB9B0BA58C8A42C14C05B3F90348AC2AC41C83CAEB1724176BE1F4155BACFC5EA3A72C3C4C39540A5C4C93C8CBA1CBFF034DE3D17326DC37B3F59C2993FB53AA53C5DBF2F443544032338C401BA86BDA9C38E38BD432944C3BF3C41C4C0A343D64366BE0BC3CF40ACBCFEB7EAC0B8C516C53BBF8DC180B9B33D853C97469245F33E173F3BC0613D41C25FBA2E3A0D3A70C32CC1AB436BC56BC24EBDD2C263C4664176BC83A461B92C4455BBEB38D836EC3FBDB851C8263FEFC3373456B206BBEC3703BD654027404CBF17406D438EBFA1404CC38044D63DDDC0CEC43946704135C47FBA553FE841223A67C51D413446CFBC75C055C1F8C3D2C1BE3EF946D2B6FB3CD8BACEC265B9B7BE374227C024BD98426BC248309BC106B887BE61BF823DDCAD11BCA54507C114C0D8C233C0A3C48CBC8EBE53C1FF3A214591C4D04499BC833C9CC038BA8AC6273C35C0ED40E2BF9F3C41BE6C300AC1D23FBFB2C642C83C1E2C66C411BEBB41D5BC2BBEC3B75F3FB1BD183956C80A37453F45B07844CAC4C4412ABE574149442943D5BCC441253B96C0EEC572BAF7BA5EC1F03A0DC2353E3DB1B9489B439040703FA63110BC9CC08CBC9B3DB1438D359DC19247ACC258446BBEDB409C3707C1EA34C540D44271BF84C51EB934C1F1C386B8018CEAB601C098416BC4C9A8FD3955C4C84007429DC26941E4BD8C4019406C3C43C14CC24DC34640574355B955396F3D3D4869C55345C944CC4523BBAAB8383D503B4BC084BE29BB5CC324446DC096C2B93EB33C19A97EC18E45903A08384F3F54C46B3C963FEAC16A42C9C5D342783D2044223F66BA19C585431DBC7ABB183C8046B4AC40430BC5604229B8BD3DE4BAC0B4D7C473C052C47F38D43FF243A7BCA7B0F9C1F23CC6BD334553359445343D87BA19420F459DC246BC324747C140C03942F8C2F935B3C235BE66C57340293A6CC1BFB985C14FAFF33EDEBEA62E37C6EF402738A836954335449A422A41184077C14CBE3B46"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
  func.func private @expected() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0xF13B113B3BA300BC00BC2738F33BFFBBFFBB383BFF3B19BBD1BBABBBF2BB453AFD3B6C3876BAECBBDBBB46B848B9FFBBEF3BD8BAF0BB003CE8BBFFBB003C342A6D39FCBB69B9D2BB17ACFEBB003C5B3BC5B878B900BCA22CBCBB9B3B7134FABBF23BA83A9FB1EE3B64BBE83B46B900BC9639FEBBFEBBD73B00BCA93A65B98EBBC934313B0432FEBBA13BF9BBA63B7B39923A9BBBFF3BFF3B0323FFBB15B90DBBFEBB1E38FE3BFF3BADBBEA3BDDBBFE3BFE3B5FBBFCBBDF3B97BA63B7E2BB00BC00BC95BBF0BBC5B8203B7D3A003C003C853B8D3BC5BBFC3AF8BB4CB930391D39FEBBE9BBFE3B00BCF9BBF2BAFCBBFFBBEE3B72BA83A4B1B8FF3BCBB961387436B33B41B800BC903BFFBB1F3441B2A5B95537CBBACE3BC13B98BBBD3BFE3BA4BBD83BFDBBFF3B2E3BE1BB00BC003CEE3BFFBB5EB99A3BF53B293900BCE83B003CADBAD1BBECBBFFBBF4BB783B003C6FB6C63A8DB9FBBBB4B876BBF83BC1BBDDBAFA3BF9BB4230F1BB6EB769BB9CBB0B3BD8AD26BA003CE5BBBCBBFCBBC3BB00BC82BA6BBBECBBA139003C00BC003C8ABA7C3AD8BB36B900BC383AC4BBE23BB2BB8E3A54BB6530E6BBB03BA6B2FB3BA83A1D2CFFBB44BBF33BB0BA4DBB35B79C3B1FBB803800BC9E36973B3FB0FF3B00BCF33B4CBBEC3BFF3BFD3BB0BAF33BB439D7BB00BC56B99DB9EDBB9939F6BB503B31B1003CFE3BD63B9F3B973125BAD8BB82BA163BFE3B5735F1BB003CFBBBFF3B61BBE03B1537E5BBC434DE3BFC3B9FBB00BC84B8EABBFFBB19B8018C83B6B7BBF13BFFBBC8A81339FFBBDE3BF63BFBBBEE3B33BBD53BBD3B6B3AEBBBF8BBFDBBC83BFD3BA9B8A938023B003C00BC003C003C003CB3B933B8E73AC939C9BB68BBB6B9FDBBFF3BD0BBFABB773B9B3A18A9EFBB003C67397137993BFFBB6B3AA63BF5BBF93B00BCFC3B063BFF3B8F3B50B900BCFE3B30BADDB92C3A003CB2ACFD3B00BCF93BA5B7243B93B99DB400BCD1BBFFBB1338B03BFF3B94BA9FB0F6BBC13A28BB003C2335003CE53A62B9F73B003CFBBB50BA003CEBBBC6BBF83BFCBBB635FBBB50BB00BCD13B2D39EEBBEDB8F0BB47AF853B80BBA02E00BCE33BA2374C36FE3BFF3BFA3BE93BBD3BEFBB57BB003C"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
}
