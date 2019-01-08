import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/pages/filter/filter_manager.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';

class FilterCellPrice extends StatelessWidget {
  const FilterCellPrice({this.item, this.manager});

  final FilterItemPrice item;
  final FilterManager manager;

  @override
  Widget build(BuildContext context) {
    String selectedName = manager.searchQuery.filter?.price?.name;
    double min = manager.result?.priceGraph?.min;
    double max = manager.result?.priceGraph?.max;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
          child: Text("Price", style: MTextStyle.h2),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
          child: Row(
            children: ["\$", "\$\$", "\$\$\$"].map((name) {
              return _FilterPriceButton(
                  selected: name == selectedName,
                  text: name,
                  onPressed: () => onPressedButton(name));
            }).toList(growable: false),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
          child: Text("Price Per Person", style: MTextStyle.h5),
        ),
        Padding(
          padding:
          const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("\$$min", style: const TextStyle(fontWeight: FontWeight.w600)),
              Text("\$$max", style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 16),
          child: _FilterPriceSlider(
            price: manager.searchQuery?.filter?.price,
            priceGraph: manager.result?.priceGraph,
            onChangeEnd: (min, max) {
              var price = SearchFilterPrice(null, min, max);
              manager.selectPrice(price);
            },
          ),
        ),
      ],
    );
  }

  void onPressedButton(String name) {
    var ranges = manager.result?.priceGraph?.ranges;
    if (ranges == null || ranges[name] == null) return;

    var range = ranges[name];
    var price = SearchFilterPrice(name, range.min, range.max);
    if (manager.isSelectedPrice(price)) {
      manager.selectPrice(null);
    } else {
      manager.selectPrice(price);
    }
  }
}

class _FilterPriceButton extends StatelessWidget {
  const _FilterPriceButton({Key key, this.selected, this.onPressed, this.text})
      : super(key: key);

  final String text;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    var gesture = GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 32,
        margin: EdgeInsets.only(left: 9, right: 9),
        decoration: BoxDecoration(
          color: selected ? MunchColors.primary500 : MunchColors.peach100,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: selected ? MunchColors.white : MunchColors.black75,
            ),
          ),
        ),
      ),
    );

    return Expanded(child: gesture);
  }
}

class _FilterPriceSlider extends StatelessWidget {
  final FilterPriceGraph priceGraph;
  final SearchFilterPrice price;
  final RangeSliderCallback onChangeEnd;

  const _FilterPriceSlider({
    Key key,
    this.priceGraph,
    this.onChangeEnd,
    this.price,
  }) : super(key: key);

  int get _divisions {
    var diff = (priceGraph?.max ?? 200) - (priceGraph?.min ?? 0) ;
    return (diff / 5).floor();
  }

  @override
  Widget build(BuildContext context) {
    var min = price?.min ?? 0;
    var max = price?.max ?? priceGraph?.max ?? 200;

    var gMin = priceGraph?.min ?? 0;
    var gMax = priceGraph?.max ?? 200;

    var slider = RangeSlider(
      valueIndicatorMaxDecimals: 1,
      divisions: _divisions,
      showValueIndicator: true,
      lowerValue: min,
      upperValue: max,
      min: gMin < min ? gMin : min,
      max: gMax < max ? max : gMax,
      onChangeEnd: onChangeEnd,
      onChanged: (min, max) {
      },
      onChangeStart: (min, max) {
      },
    );

    return SliderTheme(
      child: slider,
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: MunchColors.primary300,
        inactiveTrackColor: MunchColors.black15,
        thumbColor: MunchColors.primary700,
        valueIndicatorColor: MunchColors.black75,
        thumbShape: _ThumbShape(),
        showValueIndicator: ShowValueIndicator.always,
      ),
    );
  }
}

class _ThumbShape extends RoundSliderThumbShape {

  static const double _thumbRadius = 8.0;
  static const double _disabledThumbRadius = 6.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(isEnabled ? _thumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset thumbCenter, {
        Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete,
        TextPainter labelPainter,
        RenderBox parentBox,
        SliderThemeData sliderTheme,
        TextDirection textDirection,
        double value,
      }) {
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: _thumbRadius,
    );
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    canvas.drawCircle(
      thumbCenter,
      radiusTween.evaluate(enableAnimation),
      Paint()..color = colorTween.evaluate(enableAnimation),
    );
  }
}

//fileprivate class PriceRangeSlider: RangeSeekSlider {
//    override func setupStyle() {
//        colorBetweenHandles = .primary300
//        handleColor = .primary700
//        tintColor = UIColor(hex: "CCCCCC")
//        minLabelColor = UIColor.ba85
//        maxLabelColor = UIColor.ba85
//        minLabelFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
//        maxLabelFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
//
//        numberFormatter.numberStyle = .currency
//
//        handleDiameter = 18
//        selectedHandleDiameterMultiplier = 1.3
//        lineHeight = 3.0
//
//        minDistance = 5
//
//        enableStep = false
//        step = 5.0
//    }
//}
