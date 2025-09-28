package com.example.flutter_pigeon_native_integration_demo

import android.os.Handler
import android.os.Looper
import com.example.pegion_learning.NativeCalculatorImpl
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import java.util.Timer
import kotlin.concurrent.timer

class MainActivity : FlutterActivity() {
    private var timer: Timer? = null
    private var elapsed = 0L
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NativeCalculatorImpl().setUp(flutterEngine)

        // Set up a repeating timer to send elapsed seconds to Flutter via Pigeon FlutterApi (TimerEvents)
        val timerEvents = TimerEvents(flutterEngine.dartExecutor.binaryMessenger)
        startTicker(timerEvents)
    }

    private fun startTicker(timerEvents: TimerEvents) {
        timer?.cancel()
        elapsed = 0
        timer = timer(period = 1000L) {
            val value = ++elapsed
            // Ensure the platform message is sent on main thread
            mainHandler.post {
                timerEvents.onTimeElapsed(value) { /* ignore possible result errors here */ }
            }
        }
    }

    override fun onDestroy() {
        timer?.cancel()
        timer = null
        super.onDestroy()
    }
}
