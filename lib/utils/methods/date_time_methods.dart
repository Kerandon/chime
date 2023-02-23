extension Format on int {
  String formatToHour() {
    var result = this ~/ 60;
    if(result == 0){
      return "";
    }else {
      return '${result}h';
    }
  }
  String formatToHourMin() {
    int m = this % 60;
    int h = this ~/ 60;

    if (h == 0) {
      return '${m}m';
    } else {
      if (m > 1) {
        return '${h}h ${m}m';
      } else if (m == 0) {
        return '${h}h';
      }
    }
    return "";
  }
}

extension FormatDouble on double {
  String formatToHour() {
    var result = this ~/ 60;
    if(result == 0){
      return "";
    }else {
      return '${result}h';
    }
  }

  String formatToHourMin() {
    double m = this % 60;
    int h = this ~/ 60;

    if (h == 0) {
      return '${m}m';
    } else {
      if (m > 1) {
        return '${h}h ${m}m';
      } else if (m == 0) {
        return '${h}h';
      }
    }
    return "";
  }

  String formatToHourMinSec() {

    double m = this % 60;
    int h = this ~/ 60;


    if (h == 0) {
      return '${m}m';
    } else {
      if (m > 1) {
        return '${h}h ${m}m';
      } else if (m == 0) {
        return '${h}h';
      }
    }
    return "";
  }
}

extension DateSuffix on int {
  String addDateSuffix() {
    if (this >= 11 && this <= 13) {
      return 'th';
    }

    switch (this % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}