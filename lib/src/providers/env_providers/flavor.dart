import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final flavorProvider = Provider<Flavor>((ref) => Flavor.develop);

enum Flavor {
  develop,
  staging,
  production,
}

extension FlavorExt on Flavor {
  String get key => describeEnum(this);
}
