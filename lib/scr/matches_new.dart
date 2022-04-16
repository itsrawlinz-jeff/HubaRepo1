import 'package:flutter/widgets.dart';
import 'package:dating_app/scr/profiles.dart';

class MatchEngine extends ChangeNotifier {
  final List<DateMatch> matches;
  int _currentMatchIndex;
  int _nextMatchIndex;

  MatchEngine({
    List<DateMatch> matches,
  }) : matches = matches {
    _currentMatchIndex = 0;
    _nextMatchIndex = 1;
  }

  /*DateMatch get currentMatch =>
      ((_matches.length > 0 ? _matches[_currentMatchIndex] : null));
  //DateMatch get nextMatch => ((_matches.length>0?_matches[_nextMatchIndex]:null));
  DateMatch get nextMatch =>
      ((_matches.length > 1 ? _matches[_nextMatchIndex] : null));

  void cycleMatch() {
    print('_nextMatchIndex ' + currentMatch.decision.toString());
    //if (currentMatch.decision != Decision.undecided) {
    if (currentMatch.decision == Decision.undecided) {
      currentMatch.resetMatch();
      */ /*_currentMatchIndex = _nextMatchIndex;*/ /*
      _nextMatchIndex =
          _nextMatchIndex < _matches.length - 1 ? _nextMatchIndex + 1 : 0;
      _currentMatchIndex = _nextMatchIndex;
      print('_nextMatchIndex==${_nextMatchIndex.toString()}');
      notifyListeners();
    }
  }*/

  DateMatch get currentMatch => ((matches.length > _currentMatchIndex
      ? matches[_currentMatchIndex]
      : null));
  DateMatch get nextMatch => ((matches.length > _currentMatchIndex + 1
      ? matches[_nextMatchIndex]
      : null));

  void cycleMatch() {
    if (currentMatch.decision != Decision.undecided) {
      currentMatch.resetMatch();
      _currentMatchIndex = _nextMatchIndex;
      _nextMatchIndex =
          _nextMatchIndex < matches.length - 1 ? _nextMatchIndex + 1 : 0;
      print('_nextMatchIndex==${_nextMatchIndex.toString()}');
      if (_nextMatchIndex > 0) {
        notifyListeners();
      }
    }
  }
}

class DateMatch extends ChangeNotifier {
  final Profile profile;
  Decision decision = Decision.undecided;

  DateMatch({this.profile});
  void like() {
    if (decision == Decision.undecided) {
      decision = Decision.like;
      notifyListeners();
    }
  }

  void nope() {
    if (decision == Decision.undecided) {
      decision = Decision.nope;
      notifyListeners();
    }
  }

  void superLike() {
    if (decision == Decision.undecided) {
      decision = Decision.superLike;
      notifyListeners();
    }
  }

  void resetMatch() {
    if (decision != Decision.undecided) {
      decision = Decision.undecided;
      notifyListeners();
    }
  }
}

enum Decision {
  undecided,
  nope,
  like,
  superLike,
}
