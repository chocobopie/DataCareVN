import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/block.dart';
import 'package:login_sample/services/api_service.dart';

class BlockListViewModel with ChangeNotifier{

  Future<List<Block>> getAllBlocks() async {
    List<Block> blockList = await ApiService().getAllBlocks();

    notifyListeners();

    return blockList;
  }

}