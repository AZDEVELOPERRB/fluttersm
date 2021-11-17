import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/ui/common/ps_expansion_tile.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/shop_info.dart';

class AddressTileView extends StatelessWidget {
  const AddressTileView({
    Key key,
    @required this.shopInfo,
  }) : super(key: key);

  final ShopInfo shopInfo;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'shop_info__source_address'),
        style: Theme.of(context).textTheme.subtitle1);
    if (shopInfo != null && shopInfo.description != null) {
      return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space12,
            right: PsDimens.space12,
            bottom: PsDimens.space12),
        decoration: BoxDecoration(
          color: RoyalBoardColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: PsExpansionTile(
          initiallyExpanded: true,
          title: _expansionTileTitleWidget,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space16, right: PsDimens.space16),
              child: Column(
                children: <Widget>[
                  _AddressWidget(title: shopInfo.address1),
                  _AddressWidget(title: shopInfo.address2),
                  _AddressWidget(title: shopInfo.address3),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return const Card();
    }
  }
}

class _AddressWidget extends StatelessWidget {
  const _AddressWidget({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space12),
      child: title != ''
          ? Text(
              title,
              style: Theme.of(context).textTheme.bodyText1,
            )
          : Text(
              '-',
              style: Theme.of(context).textTheme.bodyText1,
            ),
    );
  }
}
