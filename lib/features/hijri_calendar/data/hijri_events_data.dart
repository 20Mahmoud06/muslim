import '../model/hijri_event_model.dart';

/// بيانات الأحداث الإسلامية المهمة
class HijriEventsData {
  static final List<HijriEventModel> events = [
    // محرم
    HijriEventModel(
      title: 'Islamic New Year',
      arabicTitle: 'رأس السنة الهجرية',
      day: 1,
      month: 1,
      description: 'بداية العام الهجري الجديد',
      isImportant: true,
    ),
    HijriEventModel(
      title: 'Day of Ashura',
      arabicTitle: 'يوم عاشوراء',
      day: 10,
      month: 1,
      description: 'صيام يوم عاشوراء يكفر ذنوب سنة',
      isImportant: true,
    ),

    // ربيع الأول
    HijriEventModel(
      title: 'Mawlid al-Nabi',
      arabicTitle: 'المولد النبوي الشريف',
      day: 12,
      month: 3,
      description: 'ذكرى مولد النبي محمد صلى الله عليه وسلم',
      isImportant: true,
    ),

    // رجب
    HijriEventModel(
      title: 'Isra and Miraj',
      arabicTitle: 'ليلة الإسراء والمعراج',
      day: 27,
      month: 7,
      description: 'رحلة الإسراء والمعراج المباركة',
      isImportant: true,
    ),

    // شعبان
    HijriEventModel(
      title: 'Laylat al-Bara\'ah',
      arabicTitle: 'ليلة النصف من شعبان',
      day: 15,
      month: 8,
      description: 'ليلة مباركة يُستحب فيها الدعاء والعبادة',
      isImportant: true,
    ),

    // رمضان
    HijriEventModel(
      title: 'Beginning of Ramadan',
      arabicTitle: 'بداية شهر رمضان',
      day: 1,
      month: 9,
      description: 'بداية شهر الصيام المبارك',
      isImportant: true,
    ),
    HijriEventModel(
      title: 'Laylat al-Qadr',
      arabicTitle: 'ليلة القدر',
      day: 27,
      month: 9,
      description: 'ليلة خير من ألف شهر',
      isImportant: true,
    ),

    // شوال
    HijriEventModel(
      title: 'Eid al-Fitr',
      arabicTitle: 'عيد الفطر المبارك',
      day: 1,
      month: 10,
      description: 'عيد الفطر السعيد',
      isImportant: true,
    ),

    // ذو الحجة
    HijriEventModel(
      title: 'Day of Arafah',
      arabicTitle: 'يوم عرفة',
      day: 9,
      month: 12,
      description: 'صيام يوم عرفة يكفر ذنوب سنتين',
      isImportant: true,
    ),
    HijriEventModel(
      title: 'Eid al-Adha',
      arabicTitle: 'عيد الأضحى المبارك',
      day: 10,
      month: 12,
      description: 'عيد الأضحى المبارك',
      isImportant: true,
    ),
    HijriEventModel(
      title: 'Days of Tashriq',
      arabicTitle: 'أيام التشريق',
      day: 11,
      month: 12,
      description: 'أيام أكل وشرب وذكر لله',
      isImportant: false,
    ),
  ];
}