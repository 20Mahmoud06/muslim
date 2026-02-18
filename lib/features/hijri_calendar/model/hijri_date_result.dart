/// كلاس بسيط يحمل التاريخ الهجري بدون تحقق من الباكدج
/// يحل مشكلة إن الباكدج مش بيقبل أيام زي 30 شعبان
class HijriDateResult {
  final int hYear;
  final int hMonth;
  final int hDay;

  const HijriDateResult({
    required this.hYear,
    required this.hMonth,
    required this.hDay,
  });

  @override
  String toString() => '$hYear/$hMonth/$hDay';
}