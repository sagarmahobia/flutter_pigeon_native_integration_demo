package com.example.pegion_learning

import com.example.flutter_pigeon_native_integration_demo.FlutterError
import com.example.flutter_pigeon_native_integration_demo.NativeCalculator
import io.flutter.embedding.engine.FlutterEngine

class NativeCalculatorImpl : NativeCalculator {
    override fun add(a: Long, b: Long): Long {
        return a + b
    }

    override fun subtract(a: Long, b: Long): Long {
        return a - b
    }

    override fun divide(a: Long, b: Long): Long {
        if (b == 0L) {
            throw FlutterError(
                code = "division-by-zero",
                message = "Cannot divide by zero",
                details = null
            )
        }
        return a / b
    }

    override fun multiply(a: Long, b: Long): Long {
        return a * b
    }

    override fun addLate(
        a: Long,
        b: Long,
        callback: (Result<Long>) -> Unit
    ) {
        completeSafely(callback) { add(a, b) }
    }

    override fun subtractLate(
        a: Long,
        b: Long,
        callback: (Result<Long>) -> Unit
    ) {
        completeSafely(callback) { subtract(a, b) }
    }

    override fun divideLate(
        a: Long,
        b: Long,
        callback: (Result<Long>) -> Unit
    ) {
        completeSafely(callback) { divide(a, b) }
    }

    override fun multiplyLate(
        a: Long,
        b: Long,
        callback: (Result<Long>) -> Unit
    ) {
        completeSafely(callback) { multiply(a, b) }
    }

    fun setUp(engine: FlutterEngine) {
        NativeCalculator.setUp(engine.dartExecutor.binaryMessenger, this)
    }

    private inline fun <T> completeSafely(
        callback: (Result<T>) -> Unit,
        block: () -> T
    ) {
        try {
            callback(Result.success(block()))
        } catch (exception: Throwable) {
            callback(Result.failure(exception))
        }
    }
}