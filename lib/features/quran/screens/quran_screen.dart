import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_library/quran_library.dart';
import '../../../core/constants/app_colors.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor;
    final secondary = AppColors.secondaryColor;
    final lightGreen = AppColors.lightGreen;
    final textColor = Colors.black;

    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: secondary,
        colorScheme: ColorScheme.light(
          primary: secondary,
          secondary: lightGreen,
          shadow: Colors.transparent,
        ),
        tabBarTheme: TabBarThemeData(
          indicator: BoxDecoration(
            border: Border(bottom: BorderSide(color: secondary, width: 4.w)),
          ),
          indicatorColor: secondary,
          labelColor: Colors.white,
          unselectedLabelColor: textColor.withOpacity(0.65),
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.sp),
          unselectedLabelStyle: TextStyle(fontSize: 14.sp),
        ),
        iconTheme: IconThemeData(color: secondary, size: 26.sp),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: textColor, fontSize: 16.sp),
          titleMedium: TextStyle(color: secondary, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        dividerColor: secondary.withOpacity(0.15),
        scaffoldBackgroundColor: Colors.white,
      ),
      child: QuranLibraryScreen(
        parentContext: context,
        withPageView: true,
        useDefaultAppBar: true,
        isShowAudioSlider: true,
        showAyahBookmarkedIcon: true,
        isDark: false,
        appLanguageCode: 'ar',
        backgroundColor: Colors.white,
        textColor: textColor,
        ayahSelectedBackgroundColor: lightGreen.withOpacity(0.4),
        ayahIconColor: secondary,

        bannerStyle: BannerStyle.defaults(isDark: false).copyWith(
          isImage: false,
          bannerSvgHeight: 35.h,
        ),

        basmalaStyle: BasmalaStyle(
          basmalaColor: secondary.withOpacity(0.95),
          basmalaFontSize: 25.sp,
          verticalPadding: 16.h,
        ),

        surahInfoStyle: SurahInfoStyle.defaults(isDark: false, context: context).copyWith(
          ayahCount: 'آيات',
          firstTabText: 'السور',
          secondTabText: 'عن السورة',
          bottomSheetWidth: 0.94.sw,
          bottomSheetHeight: 0.9.sh,
          primaryColor: lightGreen.withOpacity(0.3),
          indicatorColor: secondary,
          surahNameColor: secondary,
          surahNumberColor: secondary.withOpacity(0.7),
          titleColor: secondary,
          textColor: textColor,
          backgroundColor: Colors.white,
          closeIconColor: secondary,
        ),

        ayahStyle: AyahAudioStyle.defaults(isDark: false, context: context).copyWith(
          dialogWidth: 360.w,
          readersTabText: 'القراء',
          playIconColor: secondary,
          seekBarThumbColor: secondary,
          seekBarActiveTrackColor: secondary,
          seekBarInactiveTrackColor: Colors.grey.shade300,
          seekBarTimeContainerColor: secondary.withOpacity(0.2),
          tabIndicatorColor: secondary,
          tabLabelColor: secondary,
          tabUnselectedLabelColor: textColor.withOpacity(0.75),
          dialogSelectedReaderColor: secondary,
          dialogHeaderBackgroundGradient: LinearGradient(
            colors: [secondary.withOpacity(0.25), secondary.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          dialogReaderTextColor: textColor,
        ),

        surahStyle: SurahAudioStyle.defaults(isDark: false, context: context).copyWith(
          primaryColor: secondary,
          playIconColor: secondary,
          secondaryIconColor: secondary,
          iconColor: secondary,
          backIconColor: secondary,
          selectedItemColor: lightGreen.withOpacity(0.3),
          surahNameColor: secondary,
          textColor: textColor,
          secondaryTextColor: secondary.withOpacity(0.9),
          audioSliderBackgroundColor: Colors.white,
          seekBarActiveTrackColor: secondary,
          seekBarThumbColor: secondary,
          seekBarInactiveTrackColor: Colors.grey.shade300,
          timeContainerColor: secondary.withOpacity(0.18),
          downloadProgressColor: secondary,

          dialogHeaderBackgroundGradient: LinearGradient(
            colors: [secondary.withOpacity(0.25), secondary.withOpacity(0.09)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          dialogSelectedReaderColor: secondary,
          dialogHeaderTitleColor: textColor,
          dialogCloseIconColor: secondary,
          backgroundColor: Colors.white,
          borderRadius: 16.r,
        ),

        topBarStyle: QuranTopBarStyle.defaults(isDark: false, context: context).copyWith(
          showAudioButton: true,
          showFontsButton: false,
          iconColor: secondary,
          textColor: textColor,
          accentColor: secondary,
          backgroundColor: Colors.white,
        ),

        indexTabStyle: IndexTabStyle.defaults(isDark: false, context: context).copyWith(
          accentColor: secondary,
          labelColor: Colors.white,
          unselectedLabelColor: textColor.withOpacity(0.7),
          tabBarBgAlpha: 0.12,
          surahRowAltBgAlpha: 0.09,
        ),

        searchTabStyle: SearchTabStyle.defaults(isDark: false, context: context).copyWith(
          accentColor: secondary,
          surahChipBgColor: secondary,
          surahChipTextStyle: TextStyle(color: Colors.white, fontSize: 28.sp, fontFamily: 'surahName'),
        ),

        bookmarksTabStyle: BookmarksTabStyle.defaults(isDark: false, context: context).copyWith(
          textColor: textColor,
          greenGroupText: 'أخضر',
          yellowGroupText: 'أصفر',
          redGroupText: 'أحمر',
        ),

        ayahMenuStyle: AyahMenuStyle.defaults(isDark: false, context: context).copyWith(
          copyIconColor: secondary,
          tafsirIconColor: secondary,
          playIconColor: secondary,
          playAllIconColor: secondary,
          borderColor: secondary.withOpacity(0.25),
        ),

        tafsirStyle: TafsirStyle.defaults(isDark: false, context: context).copyWith(
          tafsirNameWidget: Icon(Icons.book, color: secondary, size: 30.sp),
          currentTafsirColor: secondary,
          selectedTafsirColor: secondary.withOpacity(0.18),
          selectedTafsirBorderColor: secondary,
          dialogHeaderBackgroundGradient: LinearGradient(
            colors: [secondary.withOpacity(0.25), secondary.withOpacity(0.09)],
          ),

          fontSizeThumbColor: secondary,
          fontSizeActiveTrackColor: secondary,
          fontSizeInactiveTrackColor: Colors.grey.shade300,
        ),

        topBottomQuranStyle: TopBottomQuranStyle.defaults(isDark: false, context: context).copyWith(
          hizbName: 'الحزب',
          juzName: 'الجزء',
          sajdaName: 'سجدة',
          surahNameColor: secondary,
          juzTextColor: secondary,
          pageNumberColor: primary,
        ),
      ),
    );
  }
}