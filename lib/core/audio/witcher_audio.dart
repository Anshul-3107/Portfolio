import 'witcher_audio_stub.dart'
    if (dart.library.js_interop) 'witcher_audio_web.dart';

class WitcherAudio {
  static bool _enabled = true;
  static bool get isEnabled => _enabled;

  static void toggleAudio() {
    _enabled = !_enabled;
    platformSetWitcherAudioEnabled(_enabled);
  }

  static void play(String type) {
    if (!_enabled) return;
    platformPlayWitcherAudio(type);
  }

  static void hideLoader() {
    platformHideWitcherLoader();
  }

  static void downloadResume() {
    platformDownloadResume();
  }

  static bool toggleFullscreen() {
    return platformToggleFullscreen();
  }

  static bool isFullscreen() {
    return platformIsFullscreen();
  }

  // Convenience methods - Only page turns have audio when switching tabs
  static void tab() => play('page_flip');
  static void pageFlip() => play('page_flip');
  static void pageRiffle() => play('page_flip');
  
  // Non-tab interactions are silent as requested ("no need of the sound")
  static void click() {}
  static void hover() {}
  static void seal() {}
  static void sign() {}
  static void sword() => play('sword');

  // Ambient Soundtrack Controls (Kaer Morhen & Ard Skellig)
  static void startAmbient() => platformStartWitcherAmbient();
  static void pauseAmbient() => platformPauseWitcherAmbient();
  static void resumeAmbient() => platformResumeWitcherAmbient();
}
