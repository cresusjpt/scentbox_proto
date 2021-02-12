import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class IntervalledDatePicker extends CommonPickerModel {
  int interval = 30;
  int partInHour;

  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  IntervalledDatePicker({DateTime currentTime, LocaleType locale, int interval})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute ~/ interval);
    this.setRightIndex(this.currentTime.second);
    this.interval = interval;
    this.partInHour = 60 ~/ this.interval;
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < partInHour) {
      return this.digits(index * interval, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "";
  }

  @override
  List<int> layoutProportions() {
    return [2, 2, 0];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex() * interval,
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex() * interval,
            this.currentRightIndex());
  }
}
