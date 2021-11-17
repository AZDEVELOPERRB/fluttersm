import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

typedef RatingChangeCallback = void Function(double rating);

class SmoothStarRating extends StatefulWidget {
  const SmoothStarRating({
    Key key,
    this.starCount = 5,
    this.isReadOnly = false,
    this.spacing = 0.0,
    this.rating = 0.0,
    this.defaultIconData = Icons.star_border,
    this.onRated,
    this.color,
    this.borderColor,
    this.iscounterd,
    this.size = 25,
    this.filledIconData = Icons.star,
    this.halfFilledIconData = Icons.star_half,
    this.allowHalfRating = true,
  })  : assert(rating != null),
        super(key: key);

  final int starCount;
  final double rating;
  final RatingChangeCallback onRated;
  final Color color;
  final Color borderColor;
  final double size;
  final bool allowHalfRating;
  final IconData filledIconData;
  final IconData halfFilledIconData;
  final IconData
      defaultIconData; //this is needed only when having fullRatedIconData && halfRatedIconData
  final double spacing;
  final bool iscounterd;
  final bool isReadOnly;

  @override
  _SmoothStarRatingState createState() => _SmoothStarRatingState();
}

class _SmoothStarRatingState extends State<SmoothStarRating> {
  final double halfStarThreshold =
      0.53; //half star value starts from this number

  //tracks for user tapping on this widget
  bool isWidgetTapped = false;
  double currentRating;
  Timer debounceTimer;
  @override
  void initState() {
    currentRating = widget.rating;
    super.initState();
  }

  @override
  void dispose() {
    debounceTimer?.cancel();
    debounceTimer = null;
    super.dispose();
  }
  int counter=0;

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Wrap(
              alignment: WrapAlignment.start,
              spacing: widget.spacing,
              children: List<Widget>.generate(
                  widget.starCount, (int index) => buildStar(context, index))),
         SizedBox(height: 15,),
         widget.iscounterd!=null&&widget.iscounterd?counteredstars(context) :Container()
        ],
      ),
    );
  }
Widget counteredstars(BuildContext context){
  var size=MediaQuery.of(context).size;

  return Container(
      height: 35,
      width: size.width/2-20,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color:Colors.blue)
      ),
      child: NumberPicker.integer(initialValue: counter, minValue: 0,highlightSelectedValue : true,scrollDirection:Axis.horizontal, maxValue: 5,onChanged: (val){

        setState(() {
          counter=val;
          currentRating=val.toDouble();
        });
        if (widget.onRated != null) {
          widget.onRated(normalizeRating(currentRating));
        }

      }),
    );
}
  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= currentRating) {
      icon = Icon(
        widget.defaultIconData,
        color: widget.borderColor ?? Theme.of(context).primaryColor,
        size: widget.size,
      );
    } else if (index >
            currentRating -
                (widget.allowHalfRating ? halfStarThreshold : 1.0) &&
        index < currentRating) {
      icon = Icon(
        widget.halfFilledIconData,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: widget.size,
      );
    } else {
      icon = Icon(
        widget.filledIconData,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: widget.size,
      );
    }
    final Widget star = widget.isReadOnly
        ? icon
        : kIsWeb
            ? MouseRegion(
                onExit: (PointerExitEvent event) {
                  if (widget.onRated != null && !isWidgetTapped) {
                    //reset to zero only if rating is not set by user
                    setState(() {
                      currentRating = 0;
                    });
                  }
                },
                onEnter: (PointerEnterEvent event) {
                  isWidgetTapped = false; //reset
                },
                onHover: (PointerHoverEvent event) {
                  final RenderBox box = context.findRenderObject();
                  final Offset _pos = box.globalToLocal(event.position);
                  final double i = _pos.dx / widget.size;
                  double newRating =
                      widget.allowHalfRating ? i : i.round().toDouble();
                  if (newRating > widget.starCount) {
                    newRating = widget.starCount.toDouble();
                  }
                  if (newRating < 0) {
                    newRating = 0.0;
                  }
                  setState(() {
                    currentRating = newRating;
                  });
                },
                child: GestureDetector(
                  // onTapDown: (TapDownDetails detail) {
                  //   isWidgetTapped = true;
                  //
                  //   final RenderBox box = context.findRenderObject();
                  //   final Offset _pos =
                  //       box.globalToLocal(detail.globalPosition);
                  //   final double i = (_pos.dx - widget.spacing) / widget.size;
                  //   double newRating =
                  //       widget.allowHalfRating ? i : i.round().toDouble();
                  //   if (newRating > widget.starCount) {
                  //     newRating = widget.starCount.toDouble();
                  //   }
                  //   if (newRating < 0) {
                  //     newRating = 0.0;
                  //   }
                  //   setState(() {
                  //     currentRating = newRating;
                  //   });
                  //   if (widget.onRated != null) {
                  //     widget.onRated(normalizeRating(currentRating));
                  //   }
                  // },
                  // onHorizontalDragUpdate: (DragUpdateDetails dragDetails) {
                  //   isWidgetTapped = true;
                  //
                  //   final RenderBox box = context.findRenderObject();
                  //   final Offset _pos =
                  //       box.globalToLocal(dragDetails.globalPosition);
                  //   final double i = _pos.dx / widget.size;
                  //   double newRating =
                  //       widget.allowHalfRating ? i : i.round().toDouble();
                  //   if (newRating > widget.starCount) {
                  //     newRating = widget.starCount.toDouble();
                  //   }
                  //   if (newRating < 0) {
                  //     newRating = 0.0;
                  //   }
                  //   setState(() {
                  //     currentRating = newRating;
                  //   });
                  //   debounceTimer?.cancel();
                  //   debounceTimer =
                  //       Timer(const Duration(milliseconds: 100), () {
                  //     if (widget.onRated != null) {
                  //       currentRating = normalizeRating(newRating);
                  //       widget.onRated(currentRating);
                  //     }
                  //   });
                  // },
                  child: icon,
                ),
              )
            : GestureDetector(
                // onTapDown: (TapDownDetails detail) {
                //   final RenderBox box = context.findRenderObject();
                //   final Offset _pos = box.globalToLocal(detail.globalPosition);
                //   final double i = (_pos.dx - widget.spacing) / widget.size;
                //   double newRating =
                //       widget.allowHalfRating ? i : i.round().toDouble();
                //   if (newRating > widget.starCount) {
                //     newRating = widget.starCount.toDouble();
                //   }
                //   if (newRating < 0) {
                //     newRating = 0.0;
                //   }
                //   newRating = normalizeRating(newRating);
                //   setState(() {
                //     currentRating = newRating;
                //   });
                // },
                // onTapUp: (TapUpDetails e) {
                //   if (widget.onRated != null) {
                //     widget.onRated(currentRating);
                //   }
                // },
                //
                // onHorizontalDragUpdate: (DragUpdateDetails dragDetails) {
                //
                //
                //
                //   final RenderBox box = context.findRenderObject();
                //   final Offset _pos =
                //       box.globalToLocal(dragDetails.globalPosition);
                //   final double i = _pos.dx / widget.size;
                //   double newRating =
                //       widget.allowHalfRating ? i : i.round().toDouble();
                //
                //   if (newRating > widget.starCount) {
                //     newRating = widget.starCount.toDouble();
                //   }
                //   if (newRating < 0) {
                //     newRating = 0.0;
                //   }
                //   setState(() {
                //     currentRating = newRating;
                //   });
                //   debounceTimer?.cancel();
                //   debounceTimer = Timer(const Duration(milliseconds: 100), () {
                //     if (widget.onRated != null) {
                //       currentRating = normalizeRating(newRating);
                //       widget.onRated(currentRating);
                //     }
                //   });
                // },
                child: icon,
              );

    return star;
  }

  double normalizeRating(double newRating) {
    final double k = newRating - newRating.floor();
    if (k != 0) {
      //half stars
      if (k >= halfStarThreshold) {
        newRating = newRating.floor() + 1.0;
      } else {
        newRating = newRating.floor() + 0.5;
      }
    }
    return newRating;
  }
}
