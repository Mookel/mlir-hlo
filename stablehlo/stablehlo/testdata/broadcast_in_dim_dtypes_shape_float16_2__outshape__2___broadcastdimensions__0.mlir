// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<2xf16>
    %1 = call @expected() : () -> tensor<2xf16>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<2xf16>, tensor<2xf16>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<2xf16> {
    %0 = stablehlo.constant dense<[-7.992180e+00, -1.680660e+00]> : tensor<2xf16>
    return %0 : tensor<2xf16>
  }
  func.func private @expected() -> tensor<2xf16> {
    %0 = stablehlo.constant dense<[-7.992180e+00, -1.680660e+00]> : tensor<2xf16>
    return %0 : tensor<2xf16>
  }
}