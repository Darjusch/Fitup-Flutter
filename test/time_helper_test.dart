import 'package:fitup/utils/time_helper.dart';
import 'package:test/test.dart';

void main() {
  TimeHelper timeHelper = TimeHelper();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 3));
  int duration = 5;
  group('Bet duration', () {
    test('duration is still longer than a day', () {
      bool result = timeHelper.betIsLongerThanADay(duration, startDate);
      expect(result, true);
    });
    test('days till the bet is finished', () {
      int days = timeHelper.betHasXDaysLeft(duration, startDate);
      expect(days, 2);
    });
    test('hours till the bet is finished', () {
      int hours = timeHelper.betHasXHoursLeft(duration, startDate);
      expect(hours, 48);
    });
  });

}
