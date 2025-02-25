import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

String generateUniqueId() {
  return uuid.v4();
}
