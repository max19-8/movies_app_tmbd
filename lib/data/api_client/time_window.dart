enum TimeWindow { day, week }

extension MediaTypeAsString on TimeWindow {
  String asString() {
    switch (this) {
      case TimeWindow.day:
        return 'day';
      case TimeWindow.week:
        return 'week';
    }
  }
}