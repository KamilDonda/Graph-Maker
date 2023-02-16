class Position {
  late int _x = 0;
  late int _y = 0;

  void move({int dx = 0, int dy = 0}) {
    _x += dx;
    _y += dy;
  }

  void reset() {
    _x = 0;
    _y = 0;
  }

  int get x => _x;
  int get y => _y;
}
