class FitnessModal {
  late int id;
  late String workoutName, duration, date, type;

  FitnessModal(
      {required this.id,required this.workoutName, required this.duration, required this.date, required this.type});

  factory FitnessModal.fromMap(Map m1) {
    return FitnessModal(
        id: m1['id'],
        workoutName: m1['workoutName'],
        duration: m1["duration"],
        date: m1["date"],
        type: m1["type"]);
  }
}

Map toMap(FitnessModal fitness){
  return {
    'id': fitness.id,
    'workoutName' : fitness.workoutName,
    'duration' : fitness.duration,
    'date' : fitness.date,
    'type' : fitness.type,
  };
}