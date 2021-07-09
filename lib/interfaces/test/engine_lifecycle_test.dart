import 'package:test/test.dart';
import 'package:unbounded/interfaces/engine_lifecycle.dart';
import 'package:unbounded/mixins/clonable_mixin.dart';

/// Mock class just to hold a class instance
abstract class Anything {}

/// Mock class just to hold a class instance
class Something extends Anything {
  final String data = 'Wow,  its me! I\'m a a unit test. I prevent bugs!';
}

/// Mock class just to hold a class instance
class Otherthing extends Anything {
  final String data =
      'Okay, I\'m just the guy above but with a diff name... He is original, I\'m just a copy .__.';
}

/// Mock class just to hold a class instance,
/// this represent currently a engine state
abstract class MockState with ClonableMixin<MockState> {}

/// Mock class just to hold a class instance,
/// this represent currently a engine state
class SomeMockState extends MockState {
  @override
  MockState copyWith() {
    return SomeMockState();
  }
}

/// Mock class just to hold a class instance,
/// this represent currently a model
class OtherMockState extends MockState {
  @override
  OtherMockState copyWith() {
    return OtherMockState();
  }
}

/// Mock Engine, this update and restart the state
class MockEngine extends EngineLifecycle<MockEngine>
    with ClonableMixin<MockEngine> {
  bool _gameOver;

  final List<MockState> state;

  late MockEngine _initialState = this.clone();

  MockEngine(this.state, this._gameOver) {
    _initialState = this.clone();
  }

  void toggleMyState() {
    for (var i = 0; i < state.length; i++) {
      state[i] =
          state[i] is OtherMockState ? SomeMockState() : OtherMockState();
    }
  }

  bool myStateIs<T>() => state.every((element) => element is T);

  @override
  bool get gameOver => _gameOver;

  @override
  MockEngine get initialState => _initialState;

  @override
  MockEngine copyWith({List<MockState>? state, bool? gameOver}) {
    /// Create a new list with new references
    final detachedState = this.state.map((e) => e.clone()).toList();

    /// [gameOver] is a boolean, this is a primitive immutable value,
    /// so, is not necessary to detach instance, because all boolean
    /// are new instances.
    return MockEngine(state ?? detachedState, gameOver ?? this.gameOver);
  }
}

void main() {
  group('Test Engine Lifecycle', () {
    test('Should restart()', () {
      final engine = MockEngine([SomeMockState()], false);

      engine.toggleMyState();

      expect(engine.myStateIs<OtherMockState>(), equals(true));

      final restartedEngine = engine.restart();

      expect(identical(engine, restartedEngine), equals(false));
      expect(restartedEngine.myStateIs<SomeMockState>(), equals(true));
    });
  });
}
