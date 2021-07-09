import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:test/test.dart';
import 'package:unbounded/logic/grid.dart';

void main() {
  group('A. Square Grid', () {
    final grid = GameBoard(width: 10, height: 10, columnsCount: 5);

    test('1. Compute properties correctly', () {
      expect(grid.spacing, equals(2));

      expect(grid.rowsCount, equals(5));
      expect(grid.columnsCount, equals(5));

      expect(grid.centralize, equals(true));
      expect(grid.offset, equals(Offset.zero));
      expect(grid.forceSquare, equals(false));
    });

    test('2. Calculate values correctly', () {
      expect(grid.canChange(0, 0), equals(true));
      expect(grid.canChange(0.5, 0.5), equals(false));

      expect(grid.centerX, equals(4));
      expect(grid.centerY, equals(4));
      expect(grid.center.x, equals(grid.spacing * 2));
      expect(grid.center.y, equals(grid.spacing * 2));
    });
  });

  group('B. Rectangular Grid', () {
    final grid = GameBoard(width: 10, height: 20, columnsCount: 5);

    test('1. Compute properties correctly', () {
      expect(grid.spacing, equals(2));

      expect(grid.rowsCount, equals(10));
      expect(grid.columnsCount, equals(5));

      expect(grid.centralize, equals(true));
      expect(grid.offset, equals(Offset.zero));
      expect(grid.forceSquare, equals(false));
    });

    test('2. Calculate values correctly', () {
      expect(grid.canChange(0, 0), equals(true));
      expect(grid.canChange(0.5, 0.5), equals(false));

      expect(grid.centerX, equals(4));
      expect(grid.centerY, equals(10));
      expect(grid.center.x, equals(grid.spacing * 2));
      expect(grid.center.y, equals(grid.spacing * 5));
    });
  });
}
