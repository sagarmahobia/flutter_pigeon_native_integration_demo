import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var tickerTimer: Timer?
  private var elapsed: Int64 = 0

  override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    NativeCalculatorImpl().setUp(binaryMessenger: controller.binaryMessenger)
    startTicker(binaryMessenger: controller.binaryMessenger)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func startTicker(binaryMessenger: FlutterBinaryMessenger) {
    tickerTimer?.invalidate()
    elapsed = 0
    let timerEvents = TimerEvents(binaryMessenger: binaryMessenger)
    tickerTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      self.elapsed += 1
      timerEvents.onTimeElapsed(time: self.elapsed) { _ in /* ignore completion */ }
    }
    RunLoop.main.add(tickerTimer!, forMode: .common)
  }

  override func applicationWillTerminate(_ application: UIApplication) {
    tickerTimer?.invalidate()
    tickerTimer = nil
    super.applicationWillTerminate(application)
  }
}
