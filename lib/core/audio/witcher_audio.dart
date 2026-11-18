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
    seal();
    platformDownloadResume();
  }

  static bool toggleFullscreen() {
    click();
    return platformToggleFullscreen();
  }

  static bool isFullscreen() {
    return platformIsFullscreen();
  }

  // Convenience methods
  static void tab() => play('tab');
  static void click() => play('click');
  static void hover() => play('hover');
  static void seal() => play('seal');
  static void sign() => play('sign');
}
