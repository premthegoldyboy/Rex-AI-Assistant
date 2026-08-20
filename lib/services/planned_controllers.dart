// These are the architecture "slots" for Rex's future capabilities.
// Each interface exists now so the rest of the app can be built against a
// stable contract. The implementations below are STUBS ONLY - wiring them
// to real Android APIs (Accessibility Service, Notification Listener,
// UsageStatsManager, telephony, etc.) is future native-Android work and is
// NOT done yet. Nothing here uploads data anywhere; stubs simply do nothing.

abstract class AppController {
  Future<bool> openApp(String packageName);
}

abstract class AccessibilityController {
  Future<bool> isServiceEnabled();
  Future<void> requestEnable();
}

abstract class NotificationController {
  Future<void> requestAccess();
}

abstract class CallController {
  Future<bool> canPlaceCalls();
  Future<void> placeCall(String number);
}

abstract class MessagingController {
  Future<bool> canSendMessages();
  Future<void> sendMessage(String number, String text);
}

abstract class UsageStatsController {
  Future<bool> hasPermission();
  Future<Map<String, Duration>> getTodayUsage();
}

abstract class FileController {
  Future<List<String>> searchLocalFiles(String query);
}

abstract class ResearchController {
  Future<String> search(String query);
}

abstract class MemoryController {
  Future<void> remember(String key, String value);
  Future<String?> recall(String key);
}

class StubAppController implements AppController {
  @override
  Future<bool> openApp(String packageName) async => false;
}

class StubAccessibilityController implements AccessibilityController {
  @override
  Future<bool> isServiceEnabled() async => false;
  @override
  Future<void> requestEnable() async {}
}

class StubNotificationController implements NotificationController {
  @override
  Future<void> requestAccess() async {}
}

class StubCallController implements CallController {
  @override
  Future<bool> canPlaceCalls() async => false;
  @override
  Future<void> placeCall(String number) async {}
}

class StubMessagingController implements MessagingController {
  @override
  Future<bool> canSendMessages() async => false;
  @override
  Future<void> sendMessage(String number, String text) async {}
}

class StubUsageStatsController implements UsageStatsController {
  @override
  Future<bool> hasPermission() async => false;
  @override
  Future<Map<String, Duration>> getTodayUsage() async => {};
}

class StubFileController implements FileController {
  @override
  Future<List<String>> searchLocalFiles(String query) async => [];
}

class StubResearchController implements ResearchController {
  @override
  Future<String> search(String query) async => 'Web research is not yet connected.';
}

class StubMemoryController implements MemoryController {
  final Map<String, String> _mem = {};
  @override
  Future<void> remember(String key, String value) async => _mem[key] = value;
  @override
  Future<String?> recall(String key) async => _mem[key];
}
