import 'package:pigeon/pigeon.dart';

// Pigeon configuration for generating platform channel bindings.
// Run generation with:
//   dart run pigeon --input pegions/NativeCalculator.dart
 
@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeon/native_calculator.g.dart',
  dartTestOut: 'test/pigeon/native_calculator_test.g.dart',
  dartPackageName: 'flutter_pigeon_native_integration_demo',
  kotlinOut: 'android/app/src/main/kotlin/com/example/flutter_pigeon_native_integration_demo/NativeCalculator.g.kt',
  kotlinOptions: KotlinOptions(package: 'com.example.flutter_pigeon_native_integration_demo'),
  swiftOut: 'ios/Runner/NativeCalculator.g.swift',
))
@HostApi()
abstract class NativeCalculator {
  int add(int a, int b);

  int subtract(int a, int b);

  int divide(int a, int b);

  int multiply(int a, int b);

  @async
  int addLate(int a, int b);

  @async
  int subtractLate(int a, int b);

  @async
  int divideLate(int a, int b);

  @async
  int multiplyLate(int a, int b);
}
