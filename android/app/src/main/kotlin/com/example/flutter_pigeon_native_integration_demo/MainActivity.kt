package com.example.flutter_pigeon_native_integration_demo

import com.example.pegion_learning.NativeCalculatorImpl
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NativeCalculatorImpl().setUp(flutterEngine)
    }
}
