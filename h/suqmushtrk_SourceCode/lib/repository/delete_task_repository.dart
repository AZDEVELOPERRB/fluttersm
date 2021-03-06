import 'dart:async';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_resource.dart';
import 'package:RoyalBoard_Common_sooq/api/common/RoyalBoard_status.dart';
import 'package:RoyalBoard_Common_sooq/db/basket_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/favourite_product_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/history_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/transaction_detail_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/transaction_header_dao.dart';
import 'package:RoyalBoard_Common_sooq/db/user_login_dao.dart';
import 'package:RoyalBoard_Common_sooq/repository/Common/ps_repository.dart';

import 'package:RoyalBoard_Common_sooq/viewobject/user_login.dart';

class DeleteTaskRepository extends PsRepository {
  Future<dynamic> deleteTask(
      StreamController<PsResource<List<UserLogin>>> allListStream) async {
    final FavouriteProductDao _favProductDao = FavouriteProductDao.instance;
    final UserLoginDao _userLoginDao = UserLoginDao.instance;
    final TransactionHeaderDao _transactionHeaderDao =
        TransactionHeaderDao.instance;
    final TransactionDetailDao _transactionDetailDao =
        TransactionDetailDao.instance;
    final BasketDao _basketDao = BasketDao.instance;
    final HistoryDao _historyDao = HistoryDao.instance;
    await _favProductDao.deleteAll();
    await _userLoginDao.deleteAll();
    await _transactionHeaderDao.deleteAll();
    await _transactionDetailDao.deleteAll();
    await _basketDao.deleteAll();
    await _historyDao.deleteAll();

    allListStream.sink
        .add(await _userLoginDao.getAll(status: PsStatus.SUCCESS));
  }
}
