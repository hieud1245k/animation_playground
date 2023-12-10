import 'dart:math' as math;

import 'package:animation_playground/classes/vector.dart';
import 'package:animation_playground/main.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

class CardItem extends StatefulWidget {
  final PlayingCard card;
  final Color color;
  final GlobalKey<CardItemState> state;
  final void Function()? onTap;

  CardItem({
    required this.state,
    required this.color,
    required this.card,
    this.onTap,
  }) : super(key: state);
  CardItemState createState() => CardItemState();
}

class CardItemState extends State<CardItem> with TickerProviderStateMixin {
  bool isAnimatingBeginning = false; //shows if card is distributing
  bool isScalling = false; //shows if card changing it's scale
  bool isAngleAnimating = false; //shows if card's angle is animating/changing

  // Animation used to change card location
  late AnimationController controller;

  // Animation used to center the card, after finger touches card
  late AnimationController controllerCentering;
  late Tween<double> animationCenteringTween;
  late Animation<double> animationCentering;

  // Animation used to distribute card
  late AnimationController controllerDistribution;
  late Animation<double> animationDistribution;

  // Aniamtion used to scale card
  late AnimationController controllerScalling;
  late Tween<double> animationScallingTween;
  late Animation<double> animationScalling;

  // Animation used to change card angle
  late AnimationController controllerAngle;
  late Animation<double> animationAngle;

  late FlipCardController flipCardController;

  //varibles used to center the card, after finger touches card
  double dx = 0;
  double dy = 0;

  double x = 0; //card position in X axis
  double y = 0; //card position in Y axis

  // Current position of finger while dragging
  double currentPanPositionX = 0;
  double currentPanPositionY = 0;

  // Position of finger when it starts dragging
  double firstPanPositionX = 0;
  double firstPanPositionY = 0;

  // Position of card and final position
  Vector finalPosition = Vector(0, 0);
  Vector initialPosition = Vector(0, 0);
  Vector initialScale = Vector(75, 125);
  Vector finalScale = Vector(75, 125);

  // Rotation/Angle of card
  double initialAngle = 0;
  double finalAngle = 0;

  bool canOpen = false;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    controllerCentering = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animationCentering = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.easeOutQuad))
        .animate(controllerCentering)
      ..addListener(() {
        setState(() {
          dx = initialScale.x / 2 * animationCentering.value;
          dy = (initialScale.y + 25) * animationCentering.value;
          x = currentPanPositionX - dx;
          y = currentPanPositionY - dy;
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dx = initialScale.x / 2;
            dy = initialScale.y + 25;
          });
        }
      });

    controllerDistribution = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animationDistribution = Tween<double>(begin: 0, end: 1)
        .chain(new CurveTween(curve: Curves.easeOutQuad))
        .animate(controllerDistribution)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            x = finalPosition.x;
            y = finalPosition.y;
            initialPosition = finalPosition;
            isAnimatingBeginning = false;
          });
        }
      });

    controllerAngle = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animationAngle = Tween<double>(begin: 0, end: 1)
        .chain(new CurveTween(curve: Curves.easeOutQuad))
        .animate(controllerDistribution)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            initialAngle = finalAngle;
            isAngleAnimating = false;
          });
        }
      });

    controllerScalling = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animationScallingTween = Tween<double>(begin: 0, end: 1);
    animationScalling = animationScallingTween
        .chain(new CurveTween(curve: Curves.easeOutQuad))
        .animate(controllerDistribution)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            initialScale = finalScale;
          });
        }
      });

    x = 0;
    y = (screenHeight * 0.75) - initialScale.x;
    initialPosition = Vector(x, y);
    initialScale = Vector(75, 125);
    flipCardController = FlipCardController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controllerAngle.dispose();
    controllerCentering.dispose();
    controllerDistribution.dispose();
    controllerScalling.dispose();
    flipCardController.controller?.dispose();
    super.dispose();
  }

  //Change positino of the card
  void moveTo(Vector newPosition) {
    controllerDistribution.reset();
    setState(() {
      isAnimatingBeginning = true;
      finalPosition = newPosition;
    });
    controllerDistribution.forward();
  }

  //Change angle of card
  void setAngle(double _newAngle) {
    controllerAngle.reset();
    setState(() {
      isAngleAnimating = true;

      finalAngle = _newAngle;
    });
    controllerAngle.forward();
  }

  // Change size of the card
  void scaleTo(Vector newScale) {
    controllerScalling.reset();
    setState(() {
      isScalling = true;
      finalScale = newScale;
    });
    controllerScalling.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: isAnimatingBeginning
          ? initialPosition.x +
              (finalPosition.x - initialPosition.x) *
                  animationDistribution.value
          : x,
      top: isAnimatingBeginning
          ? initialPosition.y +
              (finalPosition.y - initialPosition.y) *
                  animationDistribution.value
          : y,
      child: Transform.rotate(
        angle: isAngleAnimating
            ? initialAngle * (math.pi / 180) +
                (finalAngle - initialAngle) *
                    animationAngle.value *
                    (math.pi / 180)
            : initialAngle * (math.pi / 180),
        child: SizedBox(
          width: isScalling
              ? initialScale.x +
                  (finalScale.x - initialScale.x) * animationScalling.value
              : initialScale.x,
          height: isScalling
              ? initialScale.y +
                  (finalScale.y - initialScale.y) * animationScalling.value
              : initialScale.y,
          child: GestureDetector(
            onTap: () {
              if (canOpen && !isOpen) widget.onTap?.call();
            },
            child: FlipCard(
              controller: flipCardController,
              flipOnTouch: false,
              side: CardSide.BACK,
              front: _buildCardView(),
              back: _buildCardView(
                showBack: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardView({bool showBack = false}) {
    return PlayingCardView(
      showBack: showBack,
      card: widget.card,
      shape: Border.all(
        color: Colors.grey,
      ),
    );
  }

  void openCard() {
    if (flipCardController.state?.isFront != true) {
      flipCardController.toggleCard();
    }
  }

  void reset() {
    if (flipCardController.state?.isFront == true) {
      flipCardController.toggleCard();
    }
    initialScale = Vector(75, 125);
    moveTo(Vector(0, (screenHeight * 0.75) - initialScale.x));
    scaleTo(initialScale);
  }

  bool get isOpen => flipCardController.state?.isFront == true;
}
