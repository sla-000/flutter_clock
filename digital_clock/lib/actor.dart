class BodyPart<LookType> {
  double x;
  double y;
  double width;
  double height;
  double originX;
  double originY;
  double scaleX = 1;
  double scaleY = 1;
  double rotation;

  List<LookType> look;
}

class Actor<LookType> {
  double x;
  double y;

  List<BodyPart<LookType>> bodyParts;

  List<BodyPart<LookType>> getAllParts() {
    final List<BodyPart<LookType>> rez = <BodyPart<LookType>>[];

    return []; // todo
  }
}
