import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/models/point.dart';

class PointsCubit extends Cubit<List<Point>> {
  PointsCubit() : super([]);

  final List<Point> _points = [
    Point(name: "1", x: 0, y: 0, color: Colors.red),
    Point(name: "2", x: 150, y: 150, color: Colors.blue),
    Point(name: "3", x: 300, y: 300, color: Colors.green),
  ];

  void updatePoint(int index, Point point) {
    _points[index] = point;
    emit([..._points]);
  }

  void addPoint(Point point) {
    _points.add(point);
    emit([..._points]);
  }

  void getPoints() => emit(_points);
}
