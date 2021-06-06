import 'dart:async';

void Function(void Function()) debounceIt(Duration duration,
    {bool immediate = false}) {
  Timer? _debounce;

  return (fn) {
    _debounce?.cancel();

    void callback() => ({fn(), _debounce?.cancel()});

    _debounce = Timer(duration, callback);
  };
}

void Function(void Function()) throttleIt(Duration duration) {
  Timer? _throttle;

  var allowExec = true;

  void resetThrottle(void Function() fn) {
    allowExec = false;

    void callback() => {allowExec = true, _throttle?.cancel()};

    _throttle = Timer(duration, callback);

    fn();
  }

  return (fn) {
    if (!allowExec) return;

    resetThrottle(fn);
  };
}
