import 'dart:js_interop';

@JS('playWitcherAudio')
external void _jsPlayWitcherAudio(JSString type);

@JS('setWitcherAudioEnabled')
external void _jsSetWitcherAudioEnabled(JSBoolean enabled);

@JS('hideWitcherLoader')
external void _jsHideWitcherLoader();

@JS('downloadWitcherResume')
external void _jsDownloadWitcherResume();

@JS('toggleWitcherFullscreen')
external JSBoolean _jsToggleFullscreen();

@JS('isWitcherFullscreen')
external JSBoolean _jsIsFullscreen();

void platformPlayWitcherAudio(String type) {
  try {
    _jsPlayWitcherAudio(type.toJS);
  } catch (_) {}
}

void platformSetWitcherAudioEnabled(bool enabled) {
  try {
    _jsSetWitcherAudioEnabled(enabled.toJS);
  } catch (_) {}
}

void platformHideWitcherLoader() {
  try {
    _jsHideWitcherLoader();
  } catch (_) {}
}

void platformDownloadResume() {
  try {
    _jsDownloadWitcherResume();
  } catch (_) {}
}

bool platformToggleFullscreen() {
  try {
    return _jsToggleFullscreen().toDart;
  } catch (_) {
    return false;
  }
}

bool platformIsFullscreen() {
  try {
    return _jsIsFullscreen().toDart;
  } catch (_) {
    return false;
  }
}
