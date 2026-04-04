import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';

class ThemeController {
  static final ValueNotifier<String?> currentTheme =
      ValueNotifier(configData["theme"]);

  static void setTheme(String themeName) {
    if (LightHouseThemes.themes.containsKey(themeName)) {
      currentTheme.value = themeName;
    }
  }
}

class LightHouseThemes {
  static const LightHouseColorScheme _default = LightHouseColorScheme(
    container: Constants.pastelWhite,
    accent1: Constants.pastelRed,
    accent2: Constants.pastelYellow,
    accent3: Constants.pastelGreen,
    accent4: Constants.pastelBlue,
    muted: Constants.pastelGray,
    locked: Constants.pastelGray,
    delete: Constants.pastelRedDark,
    confirm: Constants.pastelGreen,
    hintText: Color.fromARGB(100, 0, 0, 0),
    lockedText: Color.fromARGB(100, 0, 0, 0),
    text: Constants.pastelBrown,
    red: Constants.pastelRed,
    blue: Constants.pastelBlue,
    titleText: Constants.pastelWhite,
    backgroundPrimary: Constants.pastelRed,
    backgroundSecondary: Constants.pastelYellow,
    containerText: Constants.pastelBrown,
    good: Constants.pastelRed,
    neutral: Constants.pastelYellow,
    bad: Constants.pastelGreen,
  );

  static final Map<String, LightHouseColorScheme> themes = {
    "light": _default,
    "tony": _default.copyWith(
      customBackgroundImagePath: "assets/images/background-tony.jpg",
      backgroundPrimary: Constants.coolGray,
      backgroundSecondary: Constants.coolGray,
    ),
    "aryav": _default.copyWith(
      customBackgroundImagePath: "assets/images/background-aryav.jpg",
      backgroundPrimary: Constants.coolGray,
      backgroundSecondary: Constants.coolGray,
    ),
    "sepia": LightHouseColorScheme(
      container: Color.fromARGB(255, 249, 220, 187),
      accent1: Color(0xffe3885b),
      accent2: Color(0xffedb253),
      accent3: Color(0xffacc26b),
      accent4: Color(0xff76b3a4),
      muted: Color.fromARGB(255, 193, 178, 135),
      locked: Color(0xffc7b88b),
      delete: Color(0xffb85c3b),
      confirm: Color(0xffacc26b),
      hintText: Color.fromARGB(170, 0, 0, 0),
      text: Color(0xff302622),
      lockedText: Color.fromARGB(170, 0, 0, 0),
      red: Color(0xffe3885b),
      blue: Color(0xff76b3a4),
      titleText: Color.fromARGB(255, 249, 220, 187),
      backgroundPrimary: Color(0xffe3885b),
      backgroundSecondary: Color(0xffedb253),
      containerText: Color(0xff302622),
      good: Color(0xffacc26b),
      neutral: Color(0xffedb253),
      bad: Color(0xffe3885b),
    ),
    "magma": LightHouseColorScheme(
      container: Color.fromARGB(255, 54, 53, 51),
      accent1: Color.fromRGBO(224, 105, 68, 1),
      accent2: Color.fromARGB(255, 234, 161, 59),
      accent3: Color.fromARGB(255, 248, 224, 66),
      accent4: Color.fromARGB(255, 252, 246, 206),
      muted: Color.fromARGB(255, 205, 201, 178),
      locked: Color.fromARGB(255, 161, 159, 143),
      delete: Color(0xffec4e20),
      confirm: Color.fromARGB(255, 215, 237, 23),
      hintText: Color.fromARGB(120, 17, 17, 16),
      text: Color.fromARGB(255, 17, 17, 16),
      lockedText: Color.fromARGB(120, 255, 255, 255),
      red: Color.fromRGBO(224, 105, 68, 1),
      blue: Color.fromARGB(255, 125, 198, 177),
      titleText: Color(0xffffffff),
      backgroundPrimary: Color(0xff000000),
      backgroundSecondary: Color.fromARGB(255, 34, 34, 32),
      containerText: Color(0xffffffff),
      good: Color.fromARGB(255, 215, 237, 23),
      neutral: Color.fromARGB(255, 248, 224, 66),
      bad: Color.fromRGBO(224, 105, 68, 1),
    ),
    "abyssal": LightHouseColorScheme(
      container: Color(0xff2D2C2C),
      accent1: Color.fromARGB(255, 89, 181, 190),
      accent2: Color(0xff5DDBA6),
      accent3: Color.fromARGB(255, 72, 179, 152),
      accent4: Color.fromARGB(255, 66, 131, 177),
      muted: Color.fromARGB(255, 123, 150, 139),
      locked: Color.fromARGB(255, 83, 95, 90),
      lockedText: Color.fromARGB(124, 255, 255, 255),
      delete: Color.fromARGB(255, 179, 72, 102),
      confirm: Color.fromARGB(255, 72, 179, 113),
      hintText: Color.fromARGB(111, 0, 0, 0),
      text: Color(0xff151313),
      red: Color.fromARGB(255, 203, 62, 102),
      blue: Color.fromARGB(255, 56, 82, 175),
      titleText: Color(0xffFFFFFF),
      backgroundPrimary: Color(0xff0F0E0E),
      backgroundSecondary: Color(0xff151313),
      containerText: Color.fromARGB(255, 227, 238, 236),
      good: Color.fromARGB(255, 50, 232, 150),
      neutral: Color.fromARGB(255, 229, 198, 58),
      bad: Color.fromARGB(255, 207, 39, 76),
    ),
    "marble": LightHouseColorScheme(
      container: Color(0xffddd5d0),
      accent1: Color.fromARGB(255, 173, 157, 154),
      accent2: Color.fromARGB(255, 152, 152, 138),
      accent3: Color.fromARGB(255, 129, 143, 127),
      accent4: Color.fromARGB(255, 131, 152, 151),
      muted: Color.fromARGB(255, 188, 173, 170),
      locked: Color(0xffcfc0bd),
      lockedText: Color.fromARGB(90, 0, 0, 0),
      delete: Color.fromARGB(255, 168, 120, 111),
      confirm: Color.fromARGB(255, 139, 165, 106),
      hintText: Color.fromARGB(90, 0, 0, 0),
      text: Color.fromARGB(255, 77, 76, 68),
      red: Color.fromARGB(255, 168, 120, 111),
      blue: Color.fromARGB(255, 111, 168, 162),
      titleText: Color.fromARGB(255, 231, 227, 224),
      backgroundPrimary: Color.fromARGB(255, 173, 157, 154),
      backgroundSecondary: Color.fromARGB(255, 152, 152, 138),
      containerText: Color.fromARGB(255, 77, 76, 68),
      good: Color.fromARGB(255, 139, 165, 106),
      neutral: Color.fromARGB(255, 177, 165, 108),
      bad: Color.fromARGB(255, 168, 120, 111),
    ),
    "pink": LightHouseColorScheme(
      container: Color.fromARGB(255, 255, 207, 233),
      accent1: Color(0xffff009d),
      accent2: Color(0xffd9276e),
      accent3: Color.fromARGB(255, 251, 60, 88),
      accent4: Color.fromARGB(255, 195, 54, 26),
      muted: Color(0xffff85c4),
      locked: Color.fromARGB(255, 203, 162, 181),
      lockedText: Color.fromARGB(120, 0, 0, 0),
      delete: Color.fromARGB(255, 195, 54, 26),
      confirm: Color.fromARGB(255, 160, 223, 42),
      hintText: Color(0x5f1f1216),
      text: Color(0xff1f1216),
      red: Color.fromARGB(255, 251, 60, 88),
      blue: Color.fromARGB(255, 150, 74, 255),
      titleText: Color(0xffffffff),
      backgroundPrimary: Color(0xffff009d),
      backgroundSecondary: Color(0xffd9276e),
      containerText: Color(0xff1f1216),
      good: Color.fromARGB(255, 157, 226, 28),
      neutral: Color.fromARGB(255, 234, 194, 49),
      bad: Color.fromARGB(255, 251, 60, 88),
    ),
  };
}

extension LightHouseDecorations on BuildContext {
  LightHouseColorScheme get colors =>
      Theme.of(this).extension<LightHouseColorScheme>()!;

  BoxDecoration get backgroundDecoration {
    if (colors.customBackgroundImagePath == null) {
      return BoxDecoration(
        color: colors.backgroundPrimary,
        image: DecorationImage(
          image: const AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            colors.backgroundSecondary,
            BlendMode.srcIn,
          ),
        ),
      );
    }
    return BoxDecoration(
      color: colors.backgroundPrimary,
      image: DecorationImage(
        image: AssetImage(colors.customBackgroundImagePath!),
        fit: BoxFit.cover,
      ),
    );
  }
}

class LightHouseColorScheme extends ThemeExtension<LightHouseColorScheme> {
  final Color container;
  final Color accent1;
  final Color accent2;
  final Color accent3;
  final Color accent4;
  final Color muted;
  final Color locked;
  final Color lockedText;
  final Color delete;
  final Color confirm;
  final Color hintText;
  final Color text;
  final Color red;
  final Color blue;
  final Color titleText;
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color containerText;
  final Color good;
  final Color neutral;
  final Color bad;
  final String? customBackgroundImagePath;

  const LightHouseColorScheme({
    required this.container,
    required this.accent1,
    required this.accent2,
    required this.accent3,
    required this.accent4,
    required this.muted,
    required this.locked,
    required this.lockedText,
    required this.delete,
    required this.confirm,
    required this.hintText,
    required this.text,
    required this.red,
    required this.blue,
    required this.titleText,
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.containerText,
    required this.good,
    required this.neutral,
    required this.bad,
    this.customBackgroundImagePath,
  });

  @override
  LightHouseColorScheme copyWith({
    Color? container,
    Color? accent1,
    Color? accent2,
    Color? accent3,
    Color? accent4,
    Color? muted,
    Color? locked,
    Color? lockedText,
    Color? delete,
    Color? confirm,
    Color? hintText,
    Color? text,
    Color? red,
    Color? blue,
    Color? titleText,
    Color? backgroundPrimary,
    Color? backgroundSecondary,
    Color? containerText,
    Color? good,
    Color? neutral,
    Color? bad,
    String? customBackgroundImagePath,
  }) {
    return LightHouseColorScheme(
      container: container ?? this.container,
      accent1: accent1 ?? this.accent1,
      accent2: accent2 ?? this.accent2,
      accent3: accent3 ?? this.accent3,
      accent4: accent4 ?? this.accent4,
      muted: muted ?? this.muted,
      locked: locked ?? this.locked,
      lockedText: lockedText ?? this.lockedText,
      delete: delete ?? this.delete,
      confirm: confirm ?? this.confirm,
      hintText: hintText ?? this.hintText,
      text: text ?? this.text,
      red: red ?? this.red,
      blue: blue ?? this.blue,
      titleText: titleText ?? this.titleText,
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      containerText: containerText ?? this.containerText,
      good: good ?? this.good,
      neutral: neutral ?? this.neutral,
      bad: bad ?? this.bad,
      customBackgroundImagePath:
          customBackgroundImagePath ?? this.customBackgroundImagePath,
    );
  }

  @override
  LightHouseColorScheme lerp(
      ThemeExtension<LightHouseColorScheme>? other, double t) {
    if (other is! LightHouseColorScheme) return this;
    return LightHouseColorScheme(
      container: Color.lerp(container, other.container, t)!,
      accent1: Color.lerp(accent1, other.accent1, t)!,
      accent2: Color.lerp(accent2, other.accent2, t)!,
      accent3: Color.lerp(accent3, other.accent3, t)!,
      accent4: Color.lerp(accent4, other.accent4, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      locked: Color.lerp(locked, other.locked, t)!,
      lockedText: Color.lerp(lockedText, other.lockedText, t)!,
      delete: Color.lerp(delete, other.delete, t)!,
      confirm: Color.lerp(confirm, other.confirm, t)!,
      hintText: Color.lerp(hintText, other.hintText, t)!,
      text: Color.lerp(text, other.text, t)!,
      red: Color.lerp(red, other.red, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      titleText: Color.lerp(titleText, other.titleText, t)!,
      backgroundPrimary:
          Color.lerp(backgroundPrimary, other.backgroundPrimary, t)!,
      backgroundSecondary:
          Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      containerText: Color.lerp(containerText, other.containerText, t)!,
      good: Color.lerp(good, other.good, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      bad: Color.lerp(bad, other.bad, t)!,
      customBackgroundImagePath: customBackgroundImagePath,
    );
  }
}
