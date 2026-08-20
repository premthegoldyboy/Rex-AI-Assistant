import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

/// Lifecycle state of speech output.
/// The UI must only show "speaking" when this is [VoiceOutputState.speaking],
/// driven by real TTS engine callbacks - never set manually by the UI.
enum VoiceOutputState { idle, speaking, error }

/// Abstraction so the rest of the app never talks to a TTS engine directly.
/// This lets Android, iOS and Web share one interface, and lets a future
/// fully-offline/on-device engine be swapped in later without touching UI code.
abstract class VoiceOutputProvider {
  Stream<VoiceOutputState> get stateStream;

  Future<void> speak(String text);
  Future<void> stop();
  Future<void> dispose();
}

/// Default implementation using `flutter_tts`.
/// On Android this uses the on-device Android TextToSpeech engine (local,
/// no network, no data leaves the phone). On web it uses the browser's
/// SpeechSynthesis API automatically under the hood.
class FlutterTtsVoiceOutputProvider implements VoiceOutputProvider {
  FlutterTtsVoiceOutputProvider() {
    _tts.setStartHandler(() => _emit(VoiceOutputState.speaking));
    _tts.setCompletionHandler(() => _emit(VoiceOutputState.idle));
    _tts.setCancelHandler(() => _emit(VoiceOutputState.idle));
    _tts.setErrorHandler((msg) => _emit(VoiceOutputState.error));
    _tts.setSpeechRate(0.5);
    _tts.setVolume(1.0);
    _tts.setPitch(1.0);
  }

  final FlutterTts _tts = FlutterTts();
  final _controller = _BroadcastState(VoiceOutputState.idle);

  @override
  Stream<VoiceOutputState> get stateStream => _controller.stream;

  void _emit(VoiceOutputState state) => _controller.add(state);

  @override
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    await _tts.stop();
    await _tts.speak(text);
    // Real state changes come from setStartHandler/setCompletionHandler above -
    // this method does NOT set "speaking" itself, so the UI can never fake it.
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}

class _BroadcastState {
  _BroadcastState(VoiceOutputState initial) {
    _stream = _ctrl.stream.asBroadcastStream();
    add(initial);
  }
  final _ctrl = StreamController<VoiceOutputState>();
  late final Stream<VoiceOutputState> _stream;
  Stream<VoiceOutputState> get stream => _stream;
  void add(VoiceOutputState s) => _ctrl.add(s);
  Future<void> close() => _ctrl.close();
}
