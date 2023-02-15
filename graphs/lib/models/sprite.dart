class Sprite {
  static int _id = 0;
  late int id;
  late int x;
  late int y;

  Sprite({required this.x, required this.y}) {
    id = _id++;
  }
}
