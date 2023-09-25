import 'package:flutter/material.dart';

import '../../gsheets/models/posting_model.dart';

class StoryProvider extends ChangeNotifier {
  PostingModel? posting;

  setPosting({required PostingModel post}) async {
    if (posting != null) resetPost();
    posting = post;
    notifyListeners();
  }

  resetPost() {
    posting = null;
    notifyListeners();
  }
}
