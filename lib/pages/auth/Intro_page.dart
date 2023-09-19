import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:intro_views_flutter/src/animation_gesture/animated_page_dragger.dart';
import 'package:intro_views_flutter/src/animation_gesture/page_dragger.dart';
import 'package:intro_views_flutter/src/animation_gesture/page_reveal.dart';
import 'package:intro_views_flutter/src/helpers/constants.dart';
import 'package:intro_views_flutter/src/models/pager_indicator_view_model.dart';
import 'package:intro_views_flutter/src/models/slide_update_model.dart';
import 'package:intro_views_flutter/src/ui/page.dart' as into_ui_page;
import 'package:intro_views_flutter/src/ui/page_indicator_buttons.dart';
import 'package:intro_views_flutter/src/ui/pager_indicator.dart';
import 'package:thanks_diary/allConstants/all_constants.dart';
import 'package:thanks_diary/pages/auth/mail_signin.dart';

class introViewSample extends StatelessWidget {
  // PageViewModel型のリストを作成
  static final pages = [
    PageViewModel(
      pageColor: AppColors.main,
      iconImageAssetPath: 'images/whatNowStamp/WorkBoyIcon.png',
      body: Text(
        'このアプリは、普段伝えられないありがとうを沢山伝えるアプリです。',
        style: TextStyle(fontSize: 18, height: 1.5),
      ),
      title: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'ありがとう日記をダウンロードして頂いてありがとうございます！',
          style: TextStyle(fontSize: 26),
        ),
      ),
      mainImage: Image.asset(
        'images/whatNowStamp/WorkBoyIcon.png',
        height: 300.0,
        width: 400.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(color: Color.fromARGB(255, 47, 47, 47)),
      bodyTextStyle: TextStyle(color: Color.fromARGB(255, 53, 53, 53)),
    ),
    // PageViewModel(
    //   pageColor: Color.fromARGB(255, 232, 105, 77),
    //   iconImageAssetPath: 'images/whatNowStamp/WorkGirlIcon.png',
    //   body: Text(
    //     'このアプリは、「LINEでは話せない色んなこと」を「もっと恋人に伝える」ためのアプリです。\n\nLINEでは話せない、何気ない日常のことを\n沢山恋人に伝えましょう。',
    //     // '私たちはどうすれば、「大切な人を大切にし続けられるか」をずっと話し合って来ました。でも、結局、実際に皆さんに使って頂かないと分からない。という結論に至りました。そこで、私たちのアイディアを皆さんに見て頂きたいです。',
    //     style: TextStyle(fontSize: 16),
    //   ),
    //   title: Align(alignment: Alignment.topLeft, child: Text('このアプリの\n 紹介')),
    //   mainImage: Image.asset(
    //     'images/whatNowStamp/WorkGirlIcon.png',
    //     height: 300.0,
    //     width: 400.0,
    //     alignment: Alignment.center,
    //   ),
    //   titleTextStyle: TextStyle(color: Colors.white),
    //   bodyTextStyle: TextStyle(color: Colors.white),
    // ),
    // PageViewModel(
    //   pageColor: Color.fromARGB(255, 228, 102, 12),
    //   iconImageAssetPath: 'images/whatNowStamp/WorkBoy1.png',
    //   body: SingleChildScrollView(
    //     child: Text(
    //       'このアプリは、「LINEでは話せない色んなこと」を「もっと恋人に伝える」ためのアプリです。\nまた、もう一つの目標として、「返信が返ってこない」ことの寂しさを感じさせないことを目指しています。',
    //       style: TextStyle(fontSize: 16),
    //     ),
    //   ),
    //   title: Align(alignment: Alignment.topLeft, child: Text('このアプリの\n 紹介')),
    //   mainImage: Image.asset(
    //     'images/whatNowStamp/WorkBoy1.png',
    //     height: 400.0,
    //     width: 400.0,
    //     alignment: Alignment.center,
    //   ),
    //   titleTextStyle: TextStyle(color: Colors.white),
    //   bodyTextStyle: TextStyle(color: Colors.white),
    // ),
    // PageViewModel(
    //   pageColor: Color.fromARGB(255, 246, 100, 100),
    //   iconImageAssetPath: 'images/whatNowStamp/WorkGirl1.png',
    //   body: SingleChildScrollView(
    //     child: Text(
    //       'ここで皆さまにお詫びなのですが、こちらのアプリはまだまだ開発途中となっております。最低限お使い頂けるようになっていますが、様々なところで機能の不足を感じるかと思います。\nなので、皆さまには、アプリ自体の性能というよりも、私たちの目指す機能に魅力を感じるか、というところを試して頂きたいです。',
    //       style: TextStyle(fontSize: 16),
    //     ),
    //   ),
    //   title: Text('お詫びとお願い'),
    //   mainImage: Image.asset(
    //     'images/whatNowStamp/WorkGirl1.png',
    //     height: 400.0,
    //     width: 400.0,
    //     alignment: Alignment.center,
    //   ),
    //   titleTextStyle: TextStyle(color: Colors.white),
    //   bodyTextStyle: TextStyle(color: Colors.white),
    // ),
    // PageViewModel(
    //   pageColor: Color.fromARGB(255, 241, 119, 119),
    //   iconImageAssetPath: 'images/whatNowStamp/thanks_diary.png',
    //   body: Text(
    //     'このアプリを使ってみて、「この機能好きだった」、「ぜんぜん使えなかった」などあればぜひ教えてください。\n\n皆さんとお話できるのを楽しみにしております。',
    //     style: TextStyle(fontSize: 16),
    //   ),
    //   title: Text('最後に'),
    //   mainImage: Image.asset(
    //     'images/whatNowStamp/thanks_diary.png',
    //     height: 300.0,
    //     width: 400.0,
    //     alignment: Alignment.center,
    //   ),
    //   titleTextStyle: TextStyle(color: Colors.white),
    //   bodyTextStyle: TextStyle(color: Colors.white),
    // ),
  ];

  Widget build(BuildContext context) {
    return Container(
        child: IntroViewsFlutter(
      pages,
      showNextButton: true,
      onTapDoneButton: () {
        Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
          return MailSignInPage();
        })));
      },
    )); // PageViewModelのリストを渡す
  }
}

/// This is the IntroViewsFlutter widget of app which is a
/// stateful widget as its state is dynamic and updates asynchronously.
class IntroViewsFlutter extends StatefulWidget {
  const IntroViewsFlutter(
    this.pages, {
    Key? key,
    this.onTapDoneButton,
    this.showSkipButton = true,
    this.pageButtonTextStyles,
    this.onTapBackButton,
    this.showNextButton = false,
    this.showBackButton = false,
    this.pageButtonTextSize = 18.0,
    this.pageButtonFontFamily,
    this.onTapSkipButton,
    this.onTapNextButton,
    this.pageButtonsColor = const Color.fromARGB(135, 16, 16, 16),
    this.doneText = const Text('Start'),
    this.nextText = const Text('NEXT'),
    this.skipText = const Text('SKIP'),
    this.backText = const Text('BACK'),
    this.doneButtonPersist = false,
    this.columnMainAxisAlignment = MainAxisAlignment.spaceAround,
    this.fullTransition = FULL_TRANSITION_PX,
    this.background,
  })  : assert(
          pages.length > 0,
          "At least one 'PageViewModel' item of 'pages' argument is required.",
        ),
        super(key: key);

  /// List of [PageViewModel] to display.
  final List<PageViewModel> pages;

  /// Callback on Done button pressed.
  final VoidCallback? onTapDoneButton;

  /// Sets the text color for Skip and Done buttons.
  ///
  /// Gets overridden by [pageButtonTextStyles].
  final Color pageButtonsColor;

  /// Whether you want to show the Skip button or not.
  final bool showSkipButton;

  /// Whether you want to show the Next button or not.
  final bool showNextButton;

  /// Whether you want to show the Back button or not.
  final bool showBackButton;

  /// TextStyles for Done and Skip buttons.
  ///
  /// Overrides [pageButtonFontFamily], [pageButtonsColor]
  /// and [pageButtonTextSize].
  final TextStyle? pageButtonTextStyles;

  /// Executes when Skip button is pressed.
  final VoidCallback? onTapSkipButton;

  /// Executes when Next button is pressed.
  final VoidCallback? onTapNextButton;

  /// Executes when Back button is pressed.
  final VoidCallback? onTapBackButton;

  /// Sets the text size for Skip and Done buttons.
  ///
  /// Gets overridden by [pageButtonTextStyles].
  final double pageButtonTextSize;

  /// Sets the font family for Skip and Done buttons.
  ///
  /// Gets overridden by [pageButtonTextStyles].
  final String? pageButtonFontFamily;

  /// Overrides 'DONE' text with your own text.
  ///
  /// Typically a [Text] widget.
  final Widget doneText;

  /// Overrides 'BACK' text with your own text.
  ///
  /// Typically a [Text] widget.
  final Widget backText;

  /// Overrides 'NEXT' text with your own text.
  ///
  /// Typically a [Text] widget.
  final Widget nextText;

  /// Overrides 'SKIP' text with your own text.
  ///
  /// Typically a [Text] widget.
  final Widget skipText;

  /// Always show `Done` button.
  final bool doneButtonPersist;

  /// [MainAxisAlignment] for [PageViewModel] page column alignment.
  ///
  ///
  /// Defaults to [MainAxisAlignment.spaceAround].
  ///
  /// `Portrait` view wraps around [title], [body] and [mainImage].
  ///
  /// `Landscape` view wraps around [title] and [body].
  final MainAxisAlignment columnMainAxisAlignment;

  /// Adjusts how how much the user must drag for a full page transition.
  ///
  /// Defaults to 300.0.
  final double fullTransition;

  /// Sets the background color to Colors.transparent if you have your own
  /// background image below.
  final Color? background;

  @override
  _IntroViewsFlutterState createState() => _IntroViewsFlutterState();
}

/// State of [IntroViewsFlutter] widget.
///
/// It extends the [TickerProviderStateMixin] as it is used for
/// animation control (vsync).
class _IntroViewsFlutterState extends State<IntroViewsFlutter>
    with TickerProviderStateMixin {
  /// Stream controller is used to get all the updates when user
  /// slides across screen.
  late StreamController<SlideUpdate> slideUpdateStream;

  /// When user stops dragging then by using this page automatically drags.
  AnimatedPageDragger? animatedPageDragger;

  /// Active page index.
  int activePageIndex = 0;

  /// Next page index.
  int nextPageIndex = 0;

  /// Slide direction.
  SlideDirection slideDirection = SlideDirection.none;

  /// Slide percentage (0.0 to 1.0).
  double slidePercent = 0.0;

  StreamSubscription<SlideUpdate>? slideUpdateStreamListener;

  @override
  void initState() {
    super.initState();
    // Stream Controller initialization
    slideUpdateStream = StreamController<SlideUpdate>();
    // listening to updates of stream controller
    slideUpdateStreamListener =
        slideUpdateStream.stream.listen((SlideUpdate event) {
      // setState is used to change the values dynamically
      setState(() {
        // if the user is dragging then
        if (event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          // conditions on slide direction
          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = max(0, activePageIndex - 1);
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = min(widget.pages.length - 1, activePageIndex + 1);
          } else {
            nextPageIndex = activePageIndex;
          }
        }
        // if the user has done dragging
        else if (event.updateType == UpdateType.doneDragging) {
          // auto completion of event using Animated page dragger
          if (slidePercent > 0.5) {
            animatedPageDragger = AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              // we have to animate the open page reveal
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          } else {
            animatedPageDragger = AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.close,
              // we have to close the page reveal
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
            // also next page is active page
            nextPageIndex = activePageIndex;
          }
          // run the animation
          animatedPageDragger?.run();
        }
        // when animating
        else if (event.updateType == UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        }
        // done animating
        else if (event.updateType == UpdateType.doneAnimating) {
          activePageIndex = nextPageIndex;

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;

          //disposing the animation controller
          // animatedPageDragger?.dispose();
        }
      });
    });
  }

  @override
  void dispose() {
    slideUpdateStreamListener?.cancel();
    animatedPageDragger?.dispose();
    slideUpdateStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: widget.pageButtonTextSize,
      color: widget.pageButtonsColor,
      fontFamily: widget.pageButtonFontFamily,
    ).merge(widget.pageButtonTextStyles);

    final pages = widget.pages;

    return Scaffold(
      // stack is used to place components over one another
      resizeToAvoidBottomInset: false,
      backgroundColor: widget.background,
      body: Stack(
        children: <Widget>[
          into_ui_page.Page(
            pageViewModel: pages[activePageIndex],
            percentVisible: 1.0,
            columnMainAxisAlignment: widget.columnMainAxisAlignment,
          ),
          PageReveal(
            // next page reveal
            revealPercent: slidePercent,
            child: into_ui_page.Page(
                pageViewModel: pages[nextPageIndex],
                percentVisible: slidePercent,
                columnMainAxisAlignment: widget.columnMainAxisAlignment),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 70),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: PagerIndicator(
                // bottom page indicator
                viewModel: PagerIndicatorViewModel(
                  pages,
                  activePageIndex,
                  slideDirection,
                  slidePercent,
                ),
              ),
            ),
          ),
          PageIndicatorButtons(
            // skip and Done buttons
            textStyle: textStyle,
            activePageIndex: activePageIndex,
            totalPages: pages.length,
            onPressedDoneButton: widget.onTapDoneButton,
            // void callback to be executed after pressing done button
            slidePercent: slidePercent,
            slideDirection: slideDirection,
            onPressedSkipButton: () {
              // method executed on pressing skip button
              setState(() {
                activePageIndex = pages.length - 1;
                nextPageIndex = activePageIndex;
                // after skip pressed invoke function
                // this can be used for analytics/page transition
                if (widget.onTapSkipButton != null) {
                  widget.onTapSkipButton!();
                }
              });
            },
            showSkipButton: widget.showSkipButton,
            showNextButton: widget.showNextButton,
            showBackButton: widget.showBackButton,
            onPressedNextButton: () {
              // method executed on pressing next button
              setState(() {
                activePageIndex = min(pages.length - 1, activePageIndex + 1);
                nextPageIndex = min(pages.length - 1, nextPageIndex + 1);
                // after next pressed invoke function
                // this can be used for analytics/page transition
                if (widget.onTapNextButton != null) {
                  widget.onTapNextButton!();
                }
              });
            },
            onPressedBackButton: () {
              // method executed on pressing back button
              setState(() {
                activePageIndex = max(0, activePageIndex - 1);
                nextPageIndex = max(0, nextPageIndex - 1);
                // after next pressed invoke function
                // this can be used for analytics/page transition
                if (widget.onTapBackButton != null) {
                  widget.onTapBackButton!();
                }
              });
            },
            nextText: widget.nextText,
            doneText: widget.doneText,
            backText: widget.backText,
            skipText: widget.skipText,
            doneButtonPersist: widget.doneButtonPersist,
          ),
          PageDragger(
            // used for gesture control
            fullTransitionPX: widget.fullTransition,
            canDragLeftToRight: activePageIndex > 0,
            canDragRightToLeft: activePageIndex < pages.length - 1,
            slideUpdateStream: slideUpdateStream,
          ),
        ],
      ),
    );
  }
}
