class Sprite {
  static int _id = 0;
  late int id;
  late double x;
  late double y;

  Sprite({required this.x, required this.y}) {
    id = _id++;
  }
}
