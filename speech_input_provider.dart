import 'package:speech_to_text/speech_to_text.dart' as stt;

enum SpeechInputState { idle, listening, error }

/// Abstraction over speech-to-text. All recognition happens on-device via
/// the platform's built-in speech engine where available - audio is not
/// uploaded anywhere by this class.
abstract class SpeechInputProvider {
  Future<bool> initialize();
  Future<void> startListening(void Function(String text) onResult);
  Future<void> stopListening();
  Stream<SpeechInputState> get stateStream;
}

class DeviceSpeechInputProvider implements SpeechInputProvider {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final _controller = Stream<SpeechInputState>.multi((c) {});

  @override
  Stream<SpeechInputState> get stateStream => _controller;

  @override
  Future<bool> initialize() => _speech.initialize();

  @override
  Future<void> startListening(void Function(String text) onResult) async {
    await _speech.listen(
      onResult: (result) => onResult(result.recognizedWords),
    );
  }

  @override
  Future<void> stopListening() async {
    await _speech.stop();
  }
}
