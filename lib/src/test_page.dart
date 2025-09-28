import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pigeon_native_integration_demo/pigeon/native_calculator.g.dart';
class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> implements TimerEvents {
  final _firstController = TextEditingController(text: '6');
  final _secondController = TextEditingController(text: '3');
  final _nativeCalculator = NativeCalculator();

  int _elapsedSeconds = 0;
  bool _timerListening = false; // purely for UI state, events always flow

  String? _result;
  String? _error;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Register this instance to receive TimerEvents from native side.
    TimerEvents.setUp(this);
    _timerListening = true; // native side starts immediately after engine config
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    // To stop receiving, unregister by setting up with null (optional cleanup)
    TimerEvents.setUp(null);
    super.dispose();
  }

  // FlutterApi callback from native (Pigeon generated) ------------------
  @override
  void onTimeElapsed(int time) {
    if (!mounted) return;
    setState(() {
      _elapsedSeconds = time;
    });
  }

  Future<void> _calculate(
    Future<int> Function(int a, int b) operation,
    String label,
  ) async {
    final int? first = int.tryParse(_firstController.text);
    final int? second = int.tryParse(_secondController.text);

    if (first == null || second == null) {
      setState(() {
        _error = 'Please enter valid integers to test $label.';
        _result = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final value = await operation(first, second);
      if (!mounted) return;
      setState(() {
        _result = '$label($first, $second) = $value';
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '${e.code}: ${e.message ?? 'Unknown platform error'}';
        _result = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Unexpected error: $e';
        _result = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter two integers then tap an operation to call the native calculator.',
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Elapsed (Android Timer via Pigeon): $_elapsedSeconds s',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Icon(
                      _timerListening ? Icons.timer : Icons.timer_off,
                      color: _timerListening ? Colors.green : Colors.red,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _firstController,
              decoration: const InputDecoration(
                labelText: 'First number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _secondController,
              decoration: const InputDecoration(
                labelText: 'Second number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _OperationButton(
                  label: 'Add',
                  onPressed: _isLoading
                      ? null
                      : () => _calculate(_nativeCalculator.add, 'add'),
                ),
                _OperationButton(
                  label: 'Subtract',
                  onPressed: _isLoading
                      ? null
                      : () => _calculate(_nativeCalculator.subtract, 'subtract'),
                ),
                _OperationButton(
                  label: 'Multiply',
                  onPressed: _isLoading
                      ? null
                      : () => _calculate(_nativeCalculator.multiply, 'multiply'),
                ),
                _OperationButton(
                  label: 'Divide',
                  onPressed: _isLoading
                      ? null
                      : () => _calculate(_nativeCalculator.divide, 'divide'),
                ),
                _OperationButton(
                  label: 'Add Late',
                  onPressed: _isLoading
                      ? null
                      : () =>
                          _calculate(_nativeCalculator.addLate, 'addLate'),
                ),
                _OperationButton(
                  label: 'Subtract Late',
                  onPressed: _isLoading
                      ? null
                      : () => _calculate(
                            _nativeCalculator.subtractLate,
                            'subtractLate',
                          ),
                ),
                _OperationButton(
                  label: 'Multiply Late',
                  onPressed: _isLoading
                      ? null
                      : () => _calculate(
                            _nativeCalculator.multiplyLate,
                            'multiplyLate',
                          ),
                ),
                _OperationButton(
                  label: 'Divide Late',
                  onPressed: _isLoading
                      ? null
                      : () =>
                          _calculate(_nativeCalculator.divideLate, 'divideLate'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const LinearProgressIndicator(),
            if (_result != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _result!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OperationButton extends StatelessWidget {
  const _OperationButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
