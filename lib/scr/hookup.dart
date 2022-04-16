import 'package:flutter/material.dart';
import 'package:dating_app/scr/card_stack.dart';
import 'package:dating_app/scr/draggable_card.dart';
import 'package:dating_app/scr/matches.dart';
import 'package:dating_app/scr/profile_card.dart';
import 'package:dating_app/scr/profiles.dart';
import 'package:dating_app/utils/images.dart';
import 'round_icon_button.dart';
import 'package:fluttery/layout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final MatchEngine matchEngine = new MatchEngine(
  matches: demoProfile.map((Profile profile) {
    return new DateMatch(profile: profile);
  }).toList(),
);

class HookUp extends StatefulWidget {
  @override
  _HookUpState createState() => _HookUpState();
}

class _HookUpState extends State<HookUp>
    with AutomaticKeepAliveClientMixin<HookUp> {
  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0.0,
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new RoundIconButton.small(
              icon: Icons.settings_backup_restore,
              iconColor: Colors.orange,
              onPressed: () {},
            ),
            new RoundIconButton.large(
              icon: Icons.clear,
              iconColor: Colors.red,
              onPressed: () {
                matchEngine.currentMatch.nope();
              },
            ),
            new RoundIconButton.small(
              icon: Icons.star,
              iconColor: Colors.blue,
              onPressed: () {
                matchEngine.currentMatch.superLike();
              },
            ),
            new RoundIconButton.large(
              icon: Icons.favorite,
              iconColor: Colors.green,
              onPressed: () {
                matchEngine.currentMatch.like();
              },
            ),
            new RoundIconButton.widget(
              imageAsset: lightening,
              iconColor: Colors.purple,
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: new CardStack(matchEngine: matchEngine),
      //new SizedBox(height: 200,child: Text('NGAIII'),),
      //  new CardStack(matchEngine: matchEngine),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
