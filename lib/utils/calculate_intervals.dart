bool checkIfDivisibleByTotal({required int total, required int number}) =>
    total % number == 0;

Set<int> calculateIntervals({required int totalTime, required bool openSession}) {


  Set<int> possibleTimes = {1,2,3,4,5,10,15,20,25,30,60};

  Set<int> times = {};

  if(!openSession) {
    times = possibleTimes.takeWhile((value) => value < totalTime).toSet();
  }else{
    times = possibleTimes.toSet();
  }
  // Set<int> intervalTimes = {};
  // if (totalTime > 0) {
  //   intervalTimes.add(1);
  //
  //   const List<int> timesToCheck = [
  //     2,
  //     3,
  //     4,
  //     5,
  //     10,
  //     15,
  //     20,
  //     30,
  //     45,
  //     60,
  //     90,
  //     120,
  //     180
  //   ];
  //
  //   for (var t in timesToCheck) {
  //     if (checkIfDivisibleByTotal(total: totalTime, number: t)) {
  //       intervalTimes.add(t);
  //     }
  //   }
  //   intervalTimes.add(totalTime);
  // }
  return times.toSet();
}
