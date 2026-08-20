# Rex - AI Assistant (rebuilt as standalone Flutter project)

## Status
- Core app shell, routing, and text-to-speech are real and wired up (flutter_tts, on-device engine on Android, browser SpeechSynthesis on web). The "Speaking..." label only appears while the TTS engine is actually producing audio.
- Speech-to-text (mic button) is wired using the device's built-in recognizer.
- The other planned capabilities (calls, messaging, accessibility control, usage stats, file search, web research, memory) exist as documented interfaces in `lib/services/planned_controllers.dart` but are stubs - not yet implemented. This was done honestly rather than faking them.
- Android/iOS platform folders are generated automatically by the GitHub Actions workflow the first time it runs (see `.github/workflows/build-apk.yml`), so they don't need to be hand-copied.

## Building the APK
Push to `main`, then check the "Actions" tab on GitHub. When the workflow finishes, download `rex-release-apk` from the run's Artifacts section.
