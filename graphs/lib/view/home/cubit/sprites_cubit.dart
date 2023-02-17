import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/constants/sizes.dart';
import 'package:graphs/models/line.dart';
import 'package:graphs/models/loop.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/models/position.dart';
import 'package:graphs/models/sprite.dart';

class SpritesCubit extends Cubit<List<Sprite>> {
  SpritesCubit() : super([]);

  Position background = Position();

  final List<Sprite> _sprites = [
    Point(name: "", x: 600, y: 100, color: Colors.blue),
    Point(name: "", x: 300, y: 400, color: Colors.blue),
    Point(name: "", x: 600, y: 700, color: Colors.blue),
    Point(name: "", x: 900, y: 400, color: Colors.blue),
  ];

  void updatePoint(int dx, int dy, int id) {
    var point = _sprites.firstWhere((s) => s.id == id) as Point;

    var x = point.x + dx;
    var y = point.y + dy;

    if (x + point.size > AREA_SIZE_X) return;
    if (y + point.size > AREA_SIZE_Y) return;
    if (x < 0) return;
    if (y < 0) return;

    point.x = x;
    point.y = y;

    emit([..._sprites]);
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

    emit([..._sprites]);
  }

  void addPoint(Point point) {
    _sprites.add(point);
    emit([..._sprites]);
  }

  void editPoint(Point point, String name, int x, int y, Color color) {
    // Every creation of the new Point will increment the id, so we need to
    // update point's values one by one instead of creating a new Point
    point.name = name;
    point.x = x;
    point.y = y;
    point.color = color;

    emit([..._sprites]);
  }

  void deletePoint(int id) {
    int index = _sprites.indexOf(_sprites.firstWhere((e) => e.id == id));
    _focusedID = UNFOCUSED;

    // Here we remove selected point:
    _sprites.removeAt(index);

    // Then we remove all lines that are connected to this point, so
    // we create a list of ids of that lines:
    List<int> ids = [];
    for (int i = 0; i < _sprites.length; i++) {
      var sprite = _sprites[i];
      if (sprite is Line) {
        if (sprite.p1.id == id || sprite.p2.id == id) {
          ids.add(sprite.id);
        }
      } else if (sprite is Loop) {
        if (sprite.point.id == id) {
          ids.add(sprite.id);
        }
      } else if (sprite is Point) {
        sprite.neighbors_ids.removeWhere((neighbourId) => neighbourId == id);
      }
    }
    // Now we remove lines by their ids:
    for (var id in ids) {
      _sprites.removeWhere((e) => e.id == id);
    }

    emit([..._sprites]);
  }

  void clearAll() {
    _focusedID = UNFOCUSED;
    _sprites.clear();
    emit([..._sprites]);
  }

  void getSprites() => emit(_sprites);

  int _focusedID = UNFOCUSED;

  int getFocusedID() => _focusedID;

  void focusSprite({int id = UNFOCUSED}) {
    _focusedID = id;
    emit([..._sprites]);
  }

  void addLine(int id) {
    if (_focusedID == UNFOCUSED) {
      if (kDebugMode) {
        print("No point selected");
      }
    } else if (id == _focusedID) {
      var p1 = _sprites.firstWhere((e) => e.id == _focusedID) as Point;
      if (kDebugMode) {
        print("Same point: $_focusedID");
      }
      p1.neighbors_ids.add(p1.id);
      _sprites.insert(0, Loop(point: p1));
    } else {
      var p1 = _sprites.firstWhere((e) => e.id == _focusedID) as Point;
      var p2 = _sprites.firstWhere((e) => e.id == id) as Point;

      p1.neighbors_ids.add(p2.id);
      p2.neighbors_ids.add(p1.id);

      var line = Line(p1: p1, p2: p2);
      _sprites.insert(0, line);
    }

    _focusedID = id;
    emit([..._sprites]);
  }

  void rotateLoop(Point point) {
    for (var sprite in _sprites) {
      if (sprite is Loop) {
        if (sprite.point.id == point.id) {
          sprite.click();
        }
      }
    }

    emit([..._sprites]);
  }

  void removeLine(Line line) {
    var p1 = line.p1;
    var p2 = line.p2;
    _sprites.remove(line);
    p1.neighbors_ids.remove(p2.id);
    p2.neighbors_ids.remove(p1.id);

    emit([..._sprites]);
  }

  bool _bulletsVisibility = true;

  bool areBulletsVisible() => _bulletsVisibility;

  void toggleBulletsVisibility() {
    _bulletsVisibility = !_bulletsVisibility;
    emit([..._sprites]);
  }

  void updateBullet(Line line, dx, dy) {
    line.p3.move(dx: dx, dy: dy);
    emit([..._sprites]);
  }

  void resetBullet(Line line) {
    line.p3.reset();
    _focusedID = UNFOCUSED;
    emit([..._sprites]);
  }

  void editLine(Line line, double weight) {
    line.weight = weight;

    emit([..._sprites]);
  }
}
