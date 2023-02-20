import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/constants/sizes.dart';
import 'package:graphs/models/edge.dart';
import 'package:graphs/models/line.dart';
import 'package:graphs/models/loop.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/models/position.dart';
import 'package:graphs/models/sprite.dart';

class SpritesCubit extends Cubit<List<Sprite>> {
  SpritesCubit() : super([]);

  Position background = Position();

  final List<Point> _points = [
    Point(name: "", x: 600, y: 100, color: Colors.blue),
    Point(name: "", x: 300, y: 400, color: Colors.blue),
    Point(name: "", x: 600, y: 700, color: Colors.blue),
    Point(name: "", x: 900, y: 400, color: Colors.blue),
  ];
  final List<Line> _lines = [];
  final List<Loop> _loops = [];

  void emitSprites() => emit([..._lines, ..._loops, ..._points]);

  void updatePoint(int dx, int dy, int id) {
    var point = _points.firstWhere((s) => s.id == id);

    var x = point.x + dx;
    var y = point.y + dy;

    if (x + point.size > AREA_SIZE_X) return;
    if (y + point.size > AREA_SIZE_Y) return;
    if (x < 0) return;
    if (y < 0) return;

    point.x = x;
    point.y = y;

    emitSprites();
  }

  void resetSprite() {
    focusSprite();
    var dx = -background.x;
    var dy = -background.y;
    updateSprite(dx, dy);
  }

  void updateSprite(int dx, int dy) {
    var x = background.x + dx;
    var y = background.y + dy;

    var pixelRatio = window.devicePixelRatio;
    var logicalScreenSize = window.physicalSize / pixelRatio;
    var logicalWidth = logicalScreenSize.width;
    var logicalHeight = logicalScreenSize.height;

    if (x > 10) return;
    if (y > 10) return;
    if (x + AREA_SIZE_X + 10 + FORM_MAX_WIDTH < logicalWidth) return;
    if (y + AREA_SIZE_Y + 10 + TOP_BAR_HEIGHT < logicalHeight) return;

    background.move(dx: dx, dy: dy);

    emitSprites();
  }

  void addPoint(Point point) {
    _points.add(point);
    emitSprites();
  }

  void editPoint(Point point, String name, int x, int y, Color color) {
    // Every creation of the new Point will increment the id, so we need to
    // update point's values one by one instead of creating a new Point
    point.name = name;
    point.x = x;
    point.y = y;
    point.color = color;

    emitSprites();
  }

  void deletePoint(int id) {
    int index = _points.indexOf(_points.firstWhere((e) => e.id == id));
    _focusedID = UNFOCUSED;

    // Here we remove selected point:
    _points.removeAt(index);

    // Then we remove all lines that are connected to this point, so
    // we create a list of ids of that lines:
    List<int> ids = [];

    for (var line in _lines) {
      if (line.p1.id == id || line.p2.id == id) {
        ids.add(line.id);
      }
    }

    for (var loop in _loops) {
      if (loop.point.id == id) {
        ids.add(loop.id);
      }
    }

    // Now we remove lines by their ids:
    for (var id in ids) {
      _lines.removeWhere((e) => e.id == id);
      _loops.removeWhere((e) => e.id == id);
    }

    emitSprites();
  }

  void clearAll() {
    _focusedID = UNFOCUSED;

    _points.clear();
    _loops.clear();
    _lines.clear();

    emitSprites();
  }

  void getSprites() => emitSprites();

  int _focusedID = UNFOCUSED;

  int getFocusedID() => _focusedID;

  void focusSprite({int id = UNFOCUSED}) {
    _focusedID = id;
    emitSprites();
  }

  void addLine(int id) {
    if (_focusedID == UNFOCUSED) {
      if (kDebugMode) {
        print("No point selected");
      }
    } else if (id == _focusedID) {
      var p1 = _points.firstWhere((e) => e.id == _focusedID);
      if (kDebugMode) {
        print("Same point: $_focusedID");
      }
      _loops.add(Loop(point: p1));
    } else {
      var p1 = _points.firstWhere((e) => e.id == _focusedID);
      var p2 = _points.firstWhere((e) => e.id == id);

      var line = Line(p1: p1, p2: p2);
      _lines.add(line);
    }

    _focusedID = id;
    emitSprites();
  }

  void rotateLoop(Point point) {
    for (var loop in _loops) {
      if (loop.point.id == point.id) {
        loop.click();
      }
    }

    emitSprites();
  }

  void removeEdge(Edge edge) {
    if (edge is Line) {
      _removeLine(edge);
    } else if (edge is Loop) {
      _removeLoop(edge);
    }
  }

  void _removeLine(Line line) {
    var p1 = line.p1;
    var p2 = line.p2;
    _lines.remove(line);

    emitSprites();
  }

  void _removeLoop(Loop loop) {
    var p = loop.point;
    _loops.remove(loop);

    emitSprites();
  }

  void updateBullet(Line line, dx, dy) {
    line.p3.move(dx: dx, dy: dy);
    emitSprites();
  }

  void resetBullet(Line line) {
    line.p3.reset();
    _focusedID = UNFOCUSED;
    emitSprites();
  }

  void editEdge(Edge edge, double weight) {
    edge.weight = weight;

    emitSprites();
  }
}
