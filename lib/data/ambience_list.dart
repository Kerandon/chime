import 'package:flutter/material.dart';

import '../enums/ambience.dart';
import '../models/ambience_model.dart';

List<AmbienceData> ambienceData = [
  AmbienceData(ambience: Ambience.none, icon: const Icon(Icons.volume_mute_outlined, size: 20,)),
  AmbienceData(ambience: Ambience.fireplace, icon: const Icon(Icons.fireplace_outlined)),
  AmbienceData(ambience: Ambience.forest, icon: const Icon(Icons.forest_outlined)),
  AmbienceData(ambience: Ambience.rain, icon: const Icon(Icons.water_drop_outlined)),
  AmbienceData(ambience: Ambience.meditationMusic1, icon: const Icon(Icons.piano_outlined)),
  AmbienceData(ambience: Ambience.meditationMusic2, icon: const Icon(Icons.piano_outlined)),
  AmbienceData(ambience: Ambience.meditationMusic3, icon: const Icon(Icons.piano_outlined)),
  AmbienceData(ambience: Ambience.meditationMusic4, icon: const Icon(Icons.piano_outlined)),
];