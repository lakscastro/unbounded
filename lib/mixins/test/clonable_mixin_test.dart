import 'package:test/test.dart';
import 'package:unbounded/mixins/clonable_mixin.dart';

/// Just an holder object, nothing special
class MockObject with ClonableMixin<MockObject> {
  final int value;

  const MockObject(this.value);

  @override
  MockObject copyWith({int? value}) {
    return MockObject(value ?? this.value);
  }
}

/// Just an holder object, nothing special
class MockClass with ClonableMixin<MockClass> {
  final List<MockObject> values;

  const MockClass(this.values);

  /// Return sum of all values object
  int get valuesSum {
    return values
        .map((object) => object.value)
        .reduce((value, element) => value + element);
  }

  /// Incremeent all values by 1
  void increment() {
    for (var i = 0; i < values.length; i++) {
      values[i] = values[i].copyWith(value: values[i].value + 1);
    }
  }

  /// The [copyWith] implementation **to copy values, not instances**
  @override
  MockClass copyWith({List<MockObject>? values}) {
    final currentValuesWithNewInstances =
        this.values.map((e) => MockObject(e.value)).toList();

    return MockClass(values ?? currentValuesWithNewInstances);
  }
}

void main() {
  group('Create a clonable object with [ClonableMixin]', () {
    test('Test mock implementation', () {
      final a = MockClass([MockObject(0), MockObject(0), MockObject(0)]);

      a.increment();

      expect(a.valuesSum, 3);
    });

    test('Should show detached instance\'s behavior', () {
      final a =
          MockClass([MockObject(0), MockObject(0), MockObject(0)]); // a(0) = 0

      a.increment(); // a(1) = 3

      final b = a.copy(); // b(1) = 3

      expect(a.valuesSum, 3);
      expect(b.valuesSum, 3);

      a.increment(); // a(2) = 6

      expect(a.valuesSum, 6);
      expect(b.valuesSum, 3);

      b.increment(); // b(2) = 6
      b.increment(); // b(3) = 9

      expect(a.valuesSum, 6);
      expect(b.valuesSum, 9);
    });

    test('Should show attached behavior', () {
      final a =
          MockClass([MockObject(0), MockObject(0), MockObject(0)]); // a(0) = 0

      a.increment(); // a(1) = 3

      /// `a.copyWith(values: a.values)` is a wrong implementation,
      /// this will share the same list instance
      final b = a.copyWith(values: a.values); // b(1) = 3

      expect(a.valuesSum, 3);
      expect(b.valuesSum, 3);

      a.increment(); // a(2) = 6, b(2) = 6

      expect(a.valuesSum, 6);
      expect(b.valuesSum, 6);

      b.increment(); // b(3) = 9, a(3) = 9
      b.increment(); // b(4) = 12, a(4) = 12

      expect(a.valuesSum, 12);
      expect(b.valuesSum, 12);
    });
  });
}
