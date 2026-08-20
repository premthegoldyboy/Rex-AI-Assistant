import 'package:flutter/material.dart';
import '../services/voice_output_provider.dart';
import '../services/speech_input_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VoiceOutputProvider _voice = FlutterTtsVoiceOutputProvider();
  final SpeechInputProvider _speech = DeviceSpeechInputProvider();

  VoiceOutputState _voiceState = VoiceOutputState.idle;
  String _lastHeard = '';
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _voice.stateStream.listen((state) {
      if (mounted) setState(() => _voiceState = state);
    });
    _speech.initialize();
  }

  @override
  void dispose() {
    _voice.dispose();
    _textController.dispose();
    super.dispose();
  }

  bool get _isSpeaking => _voiceState == VoiceOutputState.speaking;

  Future<void> _listen() async {
    await _speech.startListening((text) {
      setState(() => _lastHeard = text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                'Rex',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isSpeaking ? 'Speaking...' : 'Ready',
                style: TextStyle(
                  color: _isSpeaking ? Colors.greenAccent : Colors.white54,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              // Pulsing orb - only animates while _isSpeaking is actually true,
              // which is only set by the real TTS start/complete callbacks.
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isSpeaking ? 160 : 120,
                height: _isSpeaking ? 160 : 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isSpeaking
                      ? Colors.greenAccent.withOpacity(0.25)
                      : Colors.blueAccent.withOpacity(0.15),
                  border: Border.all(
                    color: _isSpeaking ? Colors.greenAccent : Colors.blueAccent,
                    width: 2,
                  ),
                ),
              ),
              const Spacer(),
              if (_lastHeard.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Heard: $_lastHeard',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type something for Rex to say...',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      final text = _textController.text;
                      if (text.trim().isNotEmpty) {
                        _voice.speak(text);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                backgroundColor: Colors.blueAccent,
                onPressed: _listen,
                child: const Icon(Icons.mic),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
