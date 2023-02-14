import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/models/line.dart';
import 'package:graphs/models/loop.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/models/sprite.dart';

class PointsCubit extends Cubit<List<Sprite>> {
  PointsCubit() : super([]);

  final List<Sprite> _sprites = [
    Sprite(x: 0, y: 0),
    Point(name: "", x: 600, y: 100, color: Colors.blue),
    Point(name: "", x: 300, y: 300, color: Colors.blue),
    Point(name: "", x: 600, y: 300, color: Colors.blue),
    Point(name: "", x: 600, y: 500, color: Colors.blue),
  ];

  Sprite _background() => _sprites[0];

  void updatePoint(double dx, double dy, int id) {
    var point = _sprites.firstWhere((s) => s.id == id) as Point;

    var x = point.x + dx;
    var y = point.y + dy;

    if (-_background().x + x + point.size > 1920) return;
    if (-_background().y + y + point.size > 1080) return;
    if (-_background().x + x < 0) return;
    if (-_background().y + y < 0) return;

    point.x = x;
    point.y = y;

    emit([..._sprites]);
  }

  void updateSprite(double dx, double dy) {
    // We move background and all sprites, which position is relative
    // to background
    var x = _background().x + dx;
    var y = _background().y + dy;

    if (x > 200) return;
    if (y > 150) return;
    if (x < -300) return;
    if (y < -250) return;

    for (var i = 0; i < _sprites.length; i++) {
      _sprites[i].x += dx;
      _sprites[i].y += dy;
    }

    emit([..._sprites]);
  }

  void addPoint(Point point) {
    _sprites.add(point);
    emit([..._sprites]);
  }

  void editPoint(int id, String name, double x, double y, Color color) {
    int index = _sprites.indexOf(_sprites.firstWhere((e) => e.id == id));
    // Every creation of the new Point will increment the id, so we need to
    // update point's values one by one instead of creating a new Point
    (_sprites[index] as Point).name = name;
    (_sprites[index] as Point).x = x;
    (_sprites[index] as Point).y = y;
    (_sprites[index] as Point).color = color;

    emit([..._sprites]);
  }

  void deletePoint(int id) {
    int index = _sprites.indexOf(_sprites.firstWhere((e) => e.id == id));
    _focusedID = 0;

    // Here we remove selected point:
    _sprites.removeAt(index);

    // Then we remove all lines that are connected to this point, so
    // we create a list of ids of that lines:
    List<int> ids = [];
    // First index is background, so we start from 1
    for (int i = 1; i < _sprites.length; i++) {
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
    _focusedID = 0;
    if (_sprites.length > 1) _sprites.removeRange(1, _sprites.length);
    emit([..._sprites]);
  }

  void getPoints() => emit(_sprites);

  int _focusedID = 0;

  int getFocusedID() => _focusedID;

  void focusSprite({int id = 0}) {
    _focusedID = id;
    emit([..._sprites]);
  }

  void addLine(int id) {
    var p1 = _sprites.firstWhere((e) => e.id == _focusedID) as Point;

    if (_focusedID == 0) {
      print("No point selected");
    } else if (id == _focusedID) {
      print("Same point: $_focusedID");
      p1.neighbors_ids.add(p1.id);
      _sprites.insert(1, Loop(point: p1));
    } else {
      var p2 = _sprites.firstWhere((e) => e.id == id) as Point;

      p1.neighbors_ids.add(p2.id);
      p2.neighbors_ids.add(p1.id);

      var line = Line(p1: p1, p2: p2);
      _sprites.insert(1, line);
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
}
