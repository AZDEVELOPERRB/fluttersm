import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:flutter/material.dart';

class PsWidgetWithAppBarAndMultiProvider extends StatefulWidget {
  const PsWidgetWithAppBarAndMultiProvider(
      {Key key,
      this.child,
      @required this.appBarTitle,
      this.actions = const <Widget>[]})
      : super(key: key);

  final Widget child;
  final String appBarTitle;
  final List<Widget> actions;

  @override
  _PsWidgetWithAppBarAndMultiProviderState createState() =>
      _PsWidgetWithAppBarAndMultiProviderState();
}

class _PsWidgetWithAppBarAndMultiProviderState
    extends State<PsWidgetWithAppBarAndMultiProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          iconTheme: IconThemeData(color: RoyalBoardColors.mainColorWithWhite),
          title: Text(widget.appBarTitle,
              style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: RoyalBoardColors.mainColorWithWhite)),
          actions: widget.actions,
          flexibleSpace: Container(
            height: 200,
          ),
          elevation: 0,
        ),
        body: widget.child);
  }
}
