import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/models/line.dart';
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

  void updatePoint(double dx, double dy, int index) {
    var point = _sprites[index] as Point;
    var sprite = _sprites[0];

    var x = point.x + dx;
    var y = point.y + dy;

    if (-sprite.x + x + point.size > 1920) return;
    if (-sprite.y + y + point.size > 1080) return;
    if (-sprite.x + x < 0) return;
    if (-sprite.y + y < 0) return;

    point.x = x;
    point.y = y;

    emit([..._sprites]);
  }

  void updateSprite(double dx, double dy) {
    var x = _sprites[0].x + dx;
    var y = _sprites[0].y + dy;

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

  void editPoint(Point point, int index) {
    _sprites[index] = point;
    emit([..._sprites]);
  }

  void deletePoint(int index) {
    _focusedIndex = 0;
    _sprites.removeAt(index);
    emit([..._sprites]);
  }

  void clearAll() {
    _focusedIndex = 0;
    if (_sprites.length > 1) _sprites.removeRange(1, _sprites.length);
    emit([..._sprites]);
  }

  void getPoints() => emit(_sprites);

  int _focusedIndex = 0;

  int getFocusedIndex() => _focusedIndex;

  void focusIndex(int index) {
    _focusedIndex = index;
    emit([..._sprites]);
  }

  int _startIndex = 0;

  void startPoint(int index) {
    if (_startIndex == 0) {
      _startIndex = index;
    } else {
      endPoint(index);
    }
  }

  void endPoint(int index) {
    var p1 = _sprites[_startIndex] as Point;
    var p2 = _sprites[index] as Point;

    var x1 = p1.x + p1.size / 2;
    var y1 = p1.y + p1.size / 2;

    var x2 = p2.x + p2.size / 2;
    var y2 = p2.y + p2.size / 2;

    if (x2 < x1) {
      var xt = x1;
      x1 = x2;
      x2 = xt;

      var yt = y1;
      y1 = y2;
      y2 = yt;
    }

    var line = Line(x1: x1, y1: y1, x2: x2, y2: y2);
    _sprites.add(line);
    _startIndex = 0;

    emit([..._sprites]);
  }
}
