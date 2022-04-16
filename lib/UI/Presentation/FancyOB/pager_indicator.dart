import 'dart:async';
import 'dart:ui';
//import 'package:fancy_on_boarding/src/page_model.dart';
import 'package:dating_app/UI/Presentation/FancyOB/page_dragger.dart';
import 'package:dating_app/UI/Presentation/FancyOB/page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel viewModel;

  PagerIndicator({
    this.viewModel,
  });

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];
    for (var i = 0; i < viewModel.pages.length; ++i) {
      final page = viewModel.pages[i];

      var percentActive;
      if (i == viewModel.activeIndex) {
        percentActive = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activeIndex - 1 &&
          viewModel.slideDirection == SlideDirection.leftToRight) {
        percentActive = viewModel.slidePercent;
      } else if (i == viewModel.activeIndex + 1 &&
          viewModel.slideDirection == SlideDirection.rightToLeft) {
        percentActive = viewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      bool isHollow = i > viewModel.activeIndex ||
          (i == viewModel.activeIndex &&
              viewModel.slideDirection == SlideDirection.leftToRight);

      bubbles.add(
        PageBubble(
          viewModel: PageBubbleViewModel(
            page.iconAssetPath,
            page.color,
            isHollow,
            percentActive,
          ),
        ),
      );
    }

    final bubbleWidth = 55.0;
    final baseTranslation =
        ((viewModel.pages.length * bubbleWidth) / 2) - (bubbleWidth / 2);
    var translation = baseTranslation - (viewModel.activeIndex * bubbleWidth);
    if (viewModel.slideDirection == SlideDirection.leftToRight) {
      translation += bubbleWidth * viewModel.slidePercent;
    } else if (viewModel.slideDirection == SlideDirection.rightToLeft) {
      translation -= bubbleWidth * viewModel.slidePercent;
    }

    return Column(
      children: [
        Expanded(child: Container()),
        Transform(
          transform: Matrix4.translationValues(translation, 0.0, 0.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: bubbles,
            ),
          ),
          /*Container(
            height: 134,
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(right: 80.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: bubbles,
              ),
            ),
          ),*/
        ),
      ],
    );
    /* return Column(
      children: [
        Expanded(child: Container()),
        Transform(
          transform: Matrix4.translationValues(translation, 0.0, 0.0),
          child: Container(
            height: 134,
            width: double.infinity,
            child: FutureBuilder<bool>(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, right: 0, left: 0),
                    itemCount: bubbles.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final int count =
                          bubbles.length > 10 ? 10 : bubbles.length;

                      return returnPageBubble(
                          viewModel, viewModel.pages[index], index);
                      */ /*CategoryView(
                        category: Category.categoryList[index],
                        animation: animation,
                        animationController: animationController,
                        callback: () {
                          widget.callBack();
                        },
                      );*/ /*
                    },
                  );
                }
              },
            ),
          ),
          */ /*  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,
          ),*/ /*
        ),
      ],
    );*/
  }

  PageBubble returnPageBubble(
      PagerIndicatorViewModel viewModel, PageModel page, int i) {
    var percentActive;
    if (i == viewModel.activeIndex) {
      percentActive = 1.0 - viewModel.slidePercent;
    } else if (i == viewModel.activeIndex - 1 &&
        viewModel.slideDirection == SlideDirection.leftToRight) {
      percentActive = viewModel.slidePercent;
    } else if (i == viewModel.activeIndex + 1 &&
        viewModel.slideDirection == SlideDirection.rightToLeft) {
      percentActive = viewModel.slidePercent;
    } else {
      percentActive = 0.0;
    }

    bool isHollow = i > viewModel.activeIndex ||
        (i == viewModel.activeIndex &&
            viewModel.slideDirection == SlideDirection.leftToRight);

    return PageBubble(
      viewModel: PageBubbleViewModel(
        page.iconAssetPath,
        page.color,
        isHollow,
        percentActive,
      ),
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class PagerIndicatorViewModel {
  final List<PageModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;
  final StreamController<SlideUpdate> slideUpdateStream;

  PagerIndicatorViewModel(
    this.pages,
    this.activeIndex,
    this.slideDirection,
    this.slidePercent,
    this.slideUpdateStream,
  );
}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel viewModel;

  PageBubble({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.0,
      height: 65.0,
      child: Center(
        child: Container(
          width: lerpDouble(20.0, 45.0, viewModel.activePercent),
          height: lerpDouble(20.0, 45.0, viewModel.activePercent),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: viewModel.isHollow
                ? const Color(0x88FFFFFF)
                    .withAlpha((0x88 * viewModel.activePercent).round())
                : const Color(0x88FFFFFF),
            border: Border.all(
              color: viewModel.isHollow
                  ? const Color(0x88FFFFFF).withAlpha(
                      (0x88 * (1.0 - viewModel.activePercent)).round())
                  : Colors.transparent,
              width: 3.0,
            ),
          ),
          child: Opacity(
              opacity: viewModel.activePercent,
              child: _renderImageAsset(viewModel.iconAssetPath,
                  color: viewModel.color)),
        ),
      ),
    );
  }
}

class PageBubbleViewModel {
  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final double activePercent;

  PageBubbleViewModel(
    this.iconAssetPath,
    this.color,
    this.isHollow,
    this.activePercent,
  );
}

Widget _renderImageAsset(String assetPath,
    {double width = 24, double height = 24, Color color = Colors.white}) {
  if (assetPath != null && assetPath.trim().length > 0) {
    if (assetPath.toLowerCase().endsWith(".svg")) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          assetPath,
          width: width,
          height: height,
          color: color,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Image.asset(
        assetPath,
        color: color,
        width: width,
        height: height,
      );
    }
  } else {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
