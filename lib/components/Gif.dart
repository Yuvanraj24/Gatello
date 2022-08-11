
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:google_fonts/google_fonts.dart';

Future<GiphyGif?> gif({
  required BuildContext context,
}) async {
  return await GiphyPicker.pickGif(
    context: context,
    apiKey: '3YCjGLvS2BL2e4L7BgsBE01UH7X4g4GY',
    fullScreenDialog: false,
    previewType: GiphyPreviewType.previewGif,
    decorator: GiphyDecorator(
      showAppBar: false,
      // searchElevation: 4,
      giphyTheme: AdaptiveTheme.getThemeMode() == ThemeMode.dark ? AdaptiveTheme.of(context).darkTheme : AdaptiveTheme.of(context).lightTheme,
    ),
  );
}
