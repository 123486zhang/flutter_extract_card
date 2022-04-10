import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:graphic_conversion/locatization/localizations.dart';
import 'package:graphic_conversion/view_model/provider/provider_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:graphic_conversion/ui/widget/fixed_size_text.dart';
import 'package:graphic_conversion/utils/string_utils.dart';

class ImageHelper {
  static String imageRes(String name) {
    Locale locale = Localizations.localeOf(navigatorContext);
    String suffix = "/";
    switch (locale.languageCode) {
      case "en":
        suffix = "_en/";
        break;
    }
    return "assets/images" + suffix + name;
  }

  static Widget imageCreateWith(
      {String url,
      double width,
      double height,
      double radius = 0,
      String placeholder = 'ic_loading_normal.png',
      BoxFit fit = BoxFit.cover}) {
//    return FadeInImage.assetNetwork(
//      placeholder: ImageHelper.imageRes(placeholder),
//      image: url,
//      width: width,
//      height: height,
//      fadeInDuration: const Duration(milliseconds: 1),
//      fadeOutDuration:const Duration(milliseconds: 1),
//      fit: BoxFit.fill,
//    );

//  return FadeInImage(
//      fit: BoxFit.cover,
//      placeholder: AssetImage(ImageHelper.imageRes(placeholder)),
//      image: CacheImage(url)
//  );

//    return Image.asset(ImageHelper.imageRes("bg_splash.png"));

    var img = CachedNetworkImage(
        placeholder: (context, path) {
          return StringUtils.isNull(placeholder) ? Container() : Image.asset(
            ImageHelper.imageRes(placeholder),
            width: width,
            height: height,
          );
        },
        imageUrl: url ?? '',
        fit: fit,
        width: width,
        height: height,
        fadeInDuration: const Duration(milliseconds: 1),
        fadeOutDuration: const Duration(milliseconds: 1),
        cacheManager: CustomCacheManager(),
    );
    return ClipRRect(
        key: (url == null || url.isEmpty) ? UniqueKey() : ValueKey(url),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: img);
  }

  static void preDownloadImages(List<dynamic> urls) {
    for (int i = 0; i < urls.length; i++) {
      String url = urls[i];
      CustomCacheManager().getFileStream(url).listen((event) {
        if (event != null && event.originalUrl.length > 0) {
          return;
        }
        CustomCacheManager().downloadFile(url);
      });
    }
  }

  static Widget getVipLevelImage(String image, {double width, double height, bool isClipRadius = true}) {
    if (isClipRadius) {
      return Container(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(height/2)),
          child: Image.asset(
            ImageHelper.imageRes(image),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Image.asset(
        ImageHelper.imageRes(image),
        width: width,
        height: height,
      );
    }

    // if (image == "ic_circle_vip_gold.png") {
    //   return Stack(
    //     children: [
    //       Image.asset(
    //         ImageHelper.imageRes(image),
    //         width: width,
    //         height: height,
    //       ),
    //       ClipRRect(
    //         borderRadius: BorderRadius.all(Radius.circular(15)),
    //         child: Image.asset(
    //           ImageHelper.imageRes("gold_horizontal.gif"),
    //           width: width,
    //           height: height,
    //         ),
    //       )
    //     ],
    //   );
    // } else if (image == "ic_home_vip_gold.png") {
    //   return Stack(
    //     children: [
    //       Image.asset(
    //         ImageHelper.imageRes(image),
    //         width: width,
    //         height: height,
    //       ),
    //       Image.asset(
    //         ImageHelper.imageRes("gold_oblique.gif"),
    //         width: width,
    //         height: height,
    //       )
    //     ],
    //   );
    // } else {
    //   return Image.asset(
    //     ImageHelper.imageRes(image),
    //     width: width,
    //     height: height,
    //   );
    // }
  }
}

class TextHelper {
  static FixedSizeText TextCreateWith(
      {String text,
      double fontSize = 15,
      Color color = ColorHelper.color_333,
      isBlod = false,
      isClip = false,
      double height,
      int maxLines,
      int maxCount, FontWeight fontWeight = FontWeight.normal}) {
    var str =  JYLocalizations.localizedString(text);
    if (maxCount != null && maxCount > 0 && maxCount < text.length) {
      str = text.substring(0, maxCount);
    }
    return FixedSizeText(
      str,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        height: height,
        fontWeight: isBlod ? FontWeight.bold : fontWeight,
      ),
      overflow: isClip ? TextOverflow.ellipsis : null,
      maxLines: maxLines,
    );
  }
}

class ColorHelper {
  static const Color color_111 = Color(0xFF111111);
  static const Color color_222 = Color(0xFF222222);
  static const Color color_333 = Color(0xFF333333);
  static const Color color_666 = Color(0xFF666666);
  static const Color color_999 = Color(0xFF999999);
  static const Color color_f1 = Color(0xFFF1F1F1);
  static const Color color_f5 = Color(0xFFF5F5F5);
  static const Color color_main = Color(0xFF00C27C);
  static const Color color_d0red = Color(0xFFD04852);
  static const Color color_clickBlue = Color(0xFF2D7BFD);
  static const Color color_redWord = Color(0xFFff0026);
  static const Color color_F53F31 = Color(0xFFF53F31);
  static const Color color_aaa = Color(0xFFAAAAAA);
  static const Color color_ccc = Color(0xFFCCCCCC);
  static const Color color_ddd = Color(0xFFDDDDDD);
  static const Color color_eee = Color(0xFFEEEEEE);
  static const Color color_fff = Color(0xFFFFFFFF);
  static const Color color_FF4C39 = Color(0xFFFF4C39);
  static const Color color_2C2924 = Color(0xFF2C2924);
  static const Color color_FFCD78 = Color(0xFFFFCD78);
  static const Color color_bg = Color(0xFFFFFFFF);
  static const Color color_divideLine = Color(0xFFEEEEEE);
  static const Color color_navigator = Color(0xFF333333);
  static const List<Color> colors_mainGradient = <Color>[Color(0xFFB39FFC), Color(0xFF7B69CE)];
  static const List<Color> colors_HomeGradient = <Color>[Color(0x1a00c27c), Color(0x0000c27c)];
  static const List<Color> colors_HomeWhites = <Color>[Color(0xffffffff), Color(0xffffffff)];
  static const List<Color> colors_VipGradient = <Color>[Color(0xff40475b), Color(0xff2d3245)];
  static const List<Color> colors_VipTopGradient = <Color>[Color(0xFF394058), Color(0xff394058)];
  static const List<Color> colors_OpenVipGradient = <Color>[Color(0xffe9cf9e), Color(0xfff0e0c7)];
  static const List<Color> colors_VipBtnGradient = <Color>[Color(0xffffe9bc), Color(0xfff0cc8b)];
}

class CustomCacheManager extends CacheManager {
  static const key = "libCachedImageData";

  // 工厂模式
  factory CustomCacheManager() => _getInstance();

  static CustomCacheManager get instance => _getInstance();
  static CustomCacheManager _instance;

  CustomCacheManager._() : super(Config(key,));

  static CustomCacheManager _getInstance() {
    if (_instance == null) {
      _instance = new CustomCacheManager._();
    }
    return _instance;
  }

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }
}
