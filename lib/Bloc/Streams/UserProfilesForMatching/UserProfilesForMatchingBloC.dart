import 'dart:async';

import 'package:dating_app/Bloc/Streams/UserProfilesForMatching/UserProfilesForMatchingEvent.dart';
import 'package:dating_app/Chopper/data/post_api_service.dart';
import 'package:dating_app/Models/Chopper/UsersProfileResp.dart';
import 'package:dating_app/Models/Chopper/UsersResp.dart';

import 'package:dating_app/scr/profiles.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UserProfilesForMatchingBloC {
  final _userProfilesForMatchingStreamController =
      StreamController<List<Profile>>.broadcast();
  StreamSink<List<Profile>> get userProfilesForMatching_sink =>
      _userProfilesForMatchingStreamController.sink;

  // expose data from stream
  Stream<List<Profile>> get stream_counter =>
      _userProfilesForMatchingStreamController.stream;

  final _userProfilesForMatchingEventController =
      StreamController<UserProfilesForMatchingEvent>();
  // expose sink for input events
  Sink<UserProfilesForMatchingEvent> get switch_changed_event_sink =>
      _userProfilesForMatchingEventController.sink;

  UserProfilesForMatchingBloC() {
    _userProfilesForMatchingEventController.stream
        .listen(_userProfilesForMatching);
  }

  _userProfilesForMatching(UserProfilesForMatchingEvent event) {
    if (event is UserProfilesFetchedEvent) {
      BuildContext context = event.buildContext;
      print('event is UserProfilesFetchedEvent');

      print('AT getProfileList');
      List<Profile> profileList = [];
      Provider.of<PostApiService>(context).getUserProfiles().then(
          (onValue) {
        if (onValue != null) {
          List<UsersResp> usersRespList = onValue.body.asList();
          print('usersRespList ${usersRespList.length}');
          for (var usersResp in usersRespList) {
            Profile profile = new Profile();
            profile.name = usersResp.username;
            profile.age = usersResp.age;
            profile.bio = ((usersResp.quote!=null?usersResp.quote:""));
            profile.location = 'Nairobi';
            List<UsersProfileResp> usersProfileRespList =
                usersResp.usersProfile.asList();
            List<String> photos = [];
            for (var usersProfileResp in usersProfileRespList) {
              photos.add(usersProfileResp.picture);
            }
            profile.photos = photos;
            profileList.add(profile);
            userProfilesForMatching_sink.add(profileList);
          }
        } else {
          print('value null');
          userProfilesForMatching_sink.add(profileList);
        }
      }, onError: (error) {
        print(error);
        userProfilesForMatching_sink.add(profileList);
      });
    }
  }

  dispose() {
    _userProfilesForMatchingStreamController.close();
    _userProfilesForMatchingEventController.close();
  }
}
