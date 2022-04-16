import 'package:dating_app/Models/Chopper/UsernameValidator.dart';
import 'package:dating_app/Models/Chopper/FeedsResp.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dating_app/Models/Chopper/UsersResp.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/authentication/PasswordResetRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/feeds/FeedsReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/from/notificationsmsg/SocketNotificationRespJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/messages/MessageReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/notificationsmsg/SocketNotificationPatchReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/Api/to/validation/UserNameValidationReqJModel.dart';
import 'package:dating_app/Models/JsonSerializable/UserSignUpRespModel.dart';
import 'package:dating_app/utils/common_functions.dart';
import 'package:dating_app/utils/dating_app_static_params.dart';
import 'built_value_converter.dart';
import 'package:chopper/chopper.dart';

part 'post_api_service.chopper.dart';

String baseUrlStr = '';


@ChopperApi(baseUrl: '')
abstract class PostApiService extends ChopperService {
  @Get()
  Future<Response<BuiltList<UsernameValidator>>> getPosts();

  @Get(path: '/{id}')
  Future<Response<UsernameValidator>> getPost(@Path('id') int id);

  @Post(path: 'signupprocess/')
  Future<Response<UsernameValidator>> postPost(
    @Body() UsernameValidator body,
  );

  //FEEDS
  @Post(path: 'feeds/')
  Future<Response> getfeedsprocess_by_FeedsReqJModel(
    @Body() FeedsReqJModel body,
  );

  @Get(path: 'feeds/?limit={limit}&&userid={userid}')
  Future<Response> getfeeds_by_userid_limit(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Path('limit') String limit,
    @Path('userid') int userid,
  );

  //END OF FEEDS

  @Post(path: 'signupprocessmultipart/')
  @Multipart()
  Future<Response> signupprocessmultipart(
      @Header("Accept") String appjson,
      @Part("username") String username,
      @Part("password") String password,
      @Part("email") String email,
      @Part("birthday") String birthday,
      @Part("quote") String quote,
      @PartFile("profilepicture") String profilepicture);

  @Get(path: 'signupprocessmultipart/')
  Future<Response<BuiltList<UsersResp>>> getUserProfiles();

  @Post(path: 'loginprocess/')
  Future<Response> loginprocess(
    @Body() UserSignUpRespModel body,
  );

  @Post(path: 'loginwtoken')
  Future<Response> loginwtoken(
    @Body() UserSignUpRespModel body,
  );

  @Get(path: 'smokesStatus/?limit={limit}')
  Future<Response> smokesStatus(
    @Path('limit') String limit,
  );

  @Get(path: 'gender/?limit={limit}')
  Future<Response> gender(
    @Path('limit') String limit,
  );

  @Get(
      path:
          'gender/?limit={limit}&&exclude_prefer_not_say={exclude_prefer_not_say}')
  Future<Response> gender_excludeprefernotsay(
    @Path('limit') String limit,
    @Path('exclude_prefer_not_say') String exclude_prefer_not_say,
  );

  @Get(path: 'relationshipStatus/?limit={limit}')
  Future<Response> relationshipStatus(
    @Path('limit') String limit,
  );

  @Get(path: 'drinkStatus/?limit={limit}')
  Future<Response> drinkStatus(
    @Path('limit') String limit,
  );

  @Get(path: 'educationLevel/?limit={limit}')
  Future<Response> educationLevel(
    @Path('limit') String limit,
  );

  @Get(path: 'ethnicity/?limit={limit}')
  Future<Response> ethnicity(
    @Path('limit') String limit,
  );

  //HOBBY
  @Get(path: 'hobby/?limit={limit}')
  Future<Response> hobby(
    @Path('limit') String limit,
  );

  @Post(path: 'hobby/')
  Future<Response> postHobbie(
      //@Header(DatingAppStaticParams.authorizationConst) String token,
      @Body() Map<String, dynamic> mapped_hobbieReqJModel);

  @Put(path: 'hobby/{id}/')
  Future<Response> putHobbie(
      //@Header(DatingAppStaticParams.authorizationConst) String token,
      @Path('id') int id,
      @Body() Map<String, dynamic> mapped_hobbieReqJModel);
  //END OF HOBBY

  @Get(path: 'incomeRange/?limit={limit}')
  Future<Response> incomeRange(
    @Path('limit') String limit,
  );

  @Get(path: 'religion/?limit={limit}')
  Future<Response> religion(
    @Path('limit') String limit,
  );

  @Get(path: 'wantChildrenStatus/?limit={limit}')
  Future<Response> wantChildrenStatus(
    @Path('limit') String limit,
  );

  @Get(path: 'somethingSpecific/?limit={limit}')
  Future<Response> somethingSpecific(
    @Path('limit') String limit,
  );

  //ILLNESS
  @Get(path: 'illness/?limit={limit}')
  Future<Response> illness(
    @Path('limit') String limit,
  );

  @Post(path: 'illness/')
  Future<Response> postIllness(
      @Body() Map<String, dynamic> mapped_illnessReqJModel);

  @Put(path: 'illness/{id}/')
  Future<Response> putIllness(
    @Path('id') int id,
    @Body() Map<String, dynamic> mapped_illnessReqJModel,
  );

  @Patch(path: 'illness/{id}/')
  Future<Response> patchIllness(
    @Path('id') int id,
    @Body() Map<String, dynamic> mapped_illnessReqJModel,
  );
  //END OF ILLNESS

  @Post(path: 'onboarding/')
  @Multipart()
  Future<Response> onboarding(
    @Header("Accept") String appjson,
    @Part("username") String username,
    @Part("password") String password,
    @Part("email") String email,
    @Part("birthday") String birthday,
    @Part("quote") String quote,
    @PartFile("profilepicture") String profilepicture,
    @Part("iam") int iam,
    @Part("searchingfor") int searchingfor,
    @Part("relationshipstatus") int relationshipstatus,
    @Part("do_you_smoke") int do_you_smoke,
    @Part("education_level") int education_level,
    @Part("want_children") int want_children,
    @Part("often_you_drink") int often_you_drink,
    @Part("ethnicity") int ethnicity,
    @Part("religion") int religion,
    @Part("want_date_to_drink") int want_date_to_drink,
    @Part("picky_abt_her_education") int picky_abt_her_education,
    @Part("herage_low") int herage_low,
    @Part("herage_high") int herage_high,
    @Part("interests") String interests,
    @Part("moneyshemakes") String moneyshemakes,
    @Part("somethingspecific") String somethingspecific,
  );

  //CUSTOM USER
  @Post(path: 'customusers/')
  @Multipart()
  Future<Response> customusers(
    @Part("username") String username,
    @Part("password") String password,
    @Part("confirm_password") String confirm_password,
    @Part("email") String email,
    @Part("birthday") String birthday,
    @Part("quote") String quote,
    @PartFile("profilepicture") String profilepicture,
    @Part("iam") int iam,
    @Part("searchingfor") int searchingfor,
    @Part("relationshipstatus") int relationshipstatus,
    @Part("do_you_smoke") int do_you_smoke,
    @Part("education_level") int education_level,
    @Part("want_children") int want_children,
    @Part("often_you_drink") int often_you_drink,
    @Part("ethnicity") int ethnicity,
    @Part("religion") int religion,
    @Part("want_date_to_drink") int want_date_to_drink,
    @Part("picky_abt_her_education") int picky_abt_her_education,
    @Part("herage_low") int herage_low,
    @Part("herage_high") int herage_high,
    @Part("first_name") String first_name,
    @Part("last_name") String last_name,
    @Part("phone_number") String phone_number,
    @Part("fb_link") String fb_link,
    @Part("insta_link") String insta_link,
  );

  @Patch(path: 'customusers/{id}/')
  @Multipart()
  Future<Response> patchcustomusers(
    @Path('id') int id,
    @Part("username") String username,
    @Part("password") String password,
    @Part("confirm_password") String confirm_password,
    @Part("email") String email,
    @Part("birthday") String birthday,
    @Part("quote") String quote,
    @PartFile("profilepicture") String profilepicture,
    @Part("iam") int iam,
    @Part("searchingfor") int searchingfor,
    @Part("relationshipstatus") int relationshipstatus,
    @Part("do_you_smoke") int do_you_smoke,
    @Part("education_level") int education_level,
    @Part("want_children") int want_children,
    @Part("often_you_drink") int often_you_drink,
    @Part("ethnicity") int ethnicity,
    @Part("religion") int religion,
    @Part("want_date_to_drink") int want_date_to_drink,
    @Part("picky_abt_her_education") int picky_abt_her_education,
    @Part("herage_low") int herage_low,
    @Part("herage_high") int herage_high,
    @Part("first_name") String first_name,
    @Part("last_name") String last_name,
    @Part("phone_number") String phone_number,
    @Part("fb_link") String fb_link,
    @Part("insta_link") String insta_link,
  );

  @Get(
      path:
          'userprofilesexcludingloggedinuser/?matching_user__id={matchinguserid}')
  Future<Response> getCustomusers_Auth_Excludng_LoggedInUser_By_MatchingUserId(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Path('matchinguserid') int matchinguserid,
  );

  //MATCHES
  @Post(path: 'customusers/')
  Future<Response> postCustomuser(
    //@Header(DatingAppStaticParams.authorizationConst) String token,
    @Body() Map<String, dynamic> mapped_CustomUserReqJModel,
  );

  @Patch(path: 'customusers/{id}/')
  Future<Response> patchCustomuser(
    //@Header(DatingAppStaticParams.authorizationConst) String token,
    @Path('id') int id,
    @Body() Map<String, dynamic> mapped_CustomUserReqJModel,
  );
  //END OF CUSTOM USER

  //START OF onboardingInterest
  @Patch(path: 'onboardingInterest/{id}/')
  Future<Response> patchOnboardingInterest(
    @Path('id') int id,
    @Body() Map<String, dynamic> mapped_onboardingInterestReqJModel,
  );

  @Post(path: 'onboardingInterest/')
  Future<Response> postOnboardingInterest(
    @Body() Map<String, dynamic> mapped_onboardingInterestReqJModel,
  );
  //END OF onboardingInterest

  //START OF onboardingMoneySheShldmake
  @Patch(path: 'onboardingMoneySheShldmake/{id}/')
  Future<Response> patchOnboardingMoneySheShldmake(
    @Path('id') int id,
    @Body() Map<String, dynamic> mapped_onboardingMoneyshemakeReqJModel,
  );

  @Post(path: 'onboardingMoneySheShldmake/')
  Future<Response> postOnboardingMoneySheShldmake(
    @Body() Map<String, dynamic> mapped_onboardingMoneyshemakeReqJModel,
  );
  //END OF onboardingMoneySheShldmake

  //START OF onboardingSomethingSpecific
  @Patch(path: 'onboardingSomethingSpecific/{id}/')
  Future<Response> patchOnboardingSomethingSpecific(
    @Path('id') int id,
    @Body() Map<String, dynamic> mapped_onboardingSomethingspecificReqJModel,
  );

  @Post(path: 'onboardingSomethingSpecific/')
  Future<Response> postOnboardingSomethingSpecific(
    @Body() Map<String, dynamic> mapped_onboardingSomethingspecificReqJModel,
  );
  //END OF onboardingSomethingSpecific

  //START OF onboardingUserIllness
  @Patch(path: 'user_illnesses/{id}/')
  Future<Response> patchOnboardingUserIllnesses(
    @Path('id') int id,
    @Body() Map<String, dynamic> mapped_onboardingUserIllnessesReqJModel,
  );

  @Post(path: 'user_illnesses/')
  Future<Response> postOnboardingUserIllnesses(
    @Body() Map<String, dynamic> mapped_onboardingUserIllnessesReqJModel,
  );
  //END OF onboardingMoneySheShldmake

  @Post(path: 'usersProfile/')
  @Multipart()
  Future<Response> postUsersProfiles(
    @Part("active") bool active,
    @PartFile("picture") String picture,
    @Part("isprofilepicture") bool isprofilepicture,
    @Path('createdby') int createdby,
    @Part("users") int users,
  );

  @Post(path: 'usersProfile/')
  @Multipart()
  Future<Response> postUsersProfiles_WO_isprofilepicture(
    @Part("active") bool active,
    @PartFile("picture") String picture,
    @Path('createdby') int createdby,
    @Part("users") int users,
  );

  @Patch(path: 'usersProfile/{id}/')
  @Multipart()
  Future<Response> patchUsersProfiles(
    @Path('id') int id,
    @Part("active") bool active,
    @PartFile("picture") String picture,
    @Part("isprofilepicture") bool isprofilepicture,
    @Path('createdby') int createdby,
    @Part("users") int users,
  );

  @Patch(path: 'usersProfile/{id}/')
  @Multipart()
  Future<Response> patchUsersProfiles_WO_isprofilepicture(
    @Path('id') int id,
    @Part("active") bool active,
    @PartFile("picture") String picture,
    @Path('createdby') int createdby,
    @Part("users") int users,
  );

  /*@Get(path: 'usersProfile/user/{id}')
  Future<Response> user_usersProfiles(
    @Path('id') int id,
  );*/

  @Get(path: 'usersProfile/?limit={limit}&&users={id}')
  Future<Response> user_usersProfiles(
    @Path('id') int id,
    @Path('limit') String limit,
  );

  @Get(
      path:
          'usersProfile/?limit={limit}&&users={id}&&isprofilepicture={isprofilepicture}')
  Future<Response> user_usersProfiles_limit_pictures(
    @Path('id') int id,
    @Path('isprofilepicture') String isprofilepicture,
    @Path('limit') String limit,
  );

  @Post(path: 'validatecustomuser_by_user_name/')
  Future<Response> validatecustomuser_by_user_name(
    @Body() UserNameValidationReqJModel body,
  );

  @Post(path: 'validatecustomuser_by_email/')
  Future<Response> validatecustomuser_by_email(
    @Body() UserNameValidationReqJModel body,
  );

  @Post(path: 'validatecustomuser_by_phone_no/')
  Future<Response> validatecustomuser_by_phone_no(
    @Body() UserNameValidationReqJModel body,
  );

  //CUSTOM USERS
  @Get(path: 'customusers/?limit={limit}')
  Future<Response> getCustomusers_Limit(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Path('limit') String limit,
  );

  @Get(path: 'customusers/?limit={limit}')
  Future<Response> getCustomusers_WO_Auth_Limit(
    @Path('limit') String limit,
  );

  @Get(path: 'customusers/{id}')
  Future<Response> getCustomuser_WO_Auth_By_Id(
    @Path('id') int id,
  );
  //END OF CUSOM USERS

  //MATCHES
  @Post(path: 'datematches/')
  Future<Response> postMatch(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Body() Map<String, dynamic> mapped_dateMatchReqJModel,
  );

  @Patch(path: 'datematches/{id}/')
  Future<Response> patchMatch(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Path('id') int id,
    @Body() Map<String, dynamic> mapped_dateMatchReqJModel,
  );

  @Get(path: 'datematches/?limit={limit}')
  Future<Response> get_Datematches_Auth_Limit(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Path('limit') String limit,
  );

  @Get(path: 'datematches/?limit={limit}&&isuserrequested={isuserrequested}')
  Future<Response> get_Datematches_Auth_Limit_By_Isuserrequested(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Path('limit') String limit,
    @Path('isuserrequested') String isuserrequested,
  );

  @Get(path: 'datematches/?limit={limit}&&search={searchparam}')
  Future<Response> get_Datematches_Auth_Limit_By_Searchparam(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Path('limit') String limit,
    @Path('searchparam') String searchparam,
  );

  @Get(
      path:
          'datematches/?limit={limit}&&search={searchparam}&&isuserrequested={isuserrequested}')
  Future<Response> get_Datematches_Auth_Limit_By_Searchparam_By_Isuserrequested(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Path('limit') String limit,
    @Path('searchparam') String searchparam,
    @Path('isuserrequested') String isuserrequested,
  );

  @Get(path: 'datematches/?active={active}&&approved={approved}')
  Future<Response> get_Datematches_Auth_By_Active_Approved(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Path('approved') String approved,
    @Path('active') String active,
  );

  @Get(path: 'datematchdecisions/?limit={limit}')
  Future<Response> get_DatematchDecisions_Auth_Limit(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Path('limit') String limit,
  );

  @Get(path: 'datematchdecisions/?limit={limit}&&excludenope={excludenope}')
  Future<Response> get_DatematchDecisions_Auth_Limit_WithoutNope(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Path('limit') String limit,
    @Path('excludenope') String excludenope,
  );
  //END OF MATCHES

  //DATE MATCH MODES
  @Get(path: 'date_match_modes/?limit={limit}')
  Future<Response> get_Date_match_modes_Auth_Limit(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Path('limit') String limit,
  );
  //END OF DATE MATCH MODES

  //MESSAGES

  @Patch(path: 'messages/{id}/')
  Future<Response> patchMessageRespJModels(
      @Header(DatingAppStaticParams.authorizationConst) String token,
      @Path('id') int id,
      @Body() MessageReqJModel messageReqJModel);

  @Post(path: 'messages/')
  Future<Response> postMessageRespJModels(
      @Header(DatingAppStaticParams.authorizationConst) String token,
      @Body() MessageReqJModel messageReqJModel);
  //END OF MESSAGES

  //NOTIFICATION
  @Patch(path: 'notifications/{id}/')
  Future<Response> patchSocketNotificationRespJModels(
      @Header(DatingAppStaticParams.authorizationConst)
          String token,
      @Path('id')
          int id,
      @Body()
          SocketNotificationPatchReqJModel socketNotificationPatchReqJModel);

  @Post(path: 'notifications/')
  Future<Response> postSocketNotificationRespJModels(
      @Header(DatingAppStaticParams.authorizationConst) String token,
      @Body() SocketNotificationRespJModel socketNotificationRespJModel);
  //END OF NOTIFICATION

  //SALES
  @Post(path: 'validatepayment_by_mpesacode/')
  Future<Response> validatepayment_by_mpesacode(
    @Header(DatingAppStaticParams.authorizationConst) String token,
    @Body() UserNameValidationReqJModel body,
  );
  //END OF SALES

  @Post(path: 'reset_password')
  Future<Response> resetPassword(
    @Header("Content-Type") String appjson,
    @Body() Map<String, dynamic> passwordResetRespJModel,
  );

  @Post(path: 'otp_verify')
  Future<Response> otp_verify(
    @Header("Content-Type") String appjson,
    @Body() Map<String, dynamic> passwordResetRespJModel,
  );

  @Put(path: 'password_update?phone_number={phoneno}')
  Future<Response> password_update(
      @Header("Content-Type") String appjson,
      @Body() PasswordResetRespJModel passwordResetRespJModel,
      @Path('phoneno') String phoneno);

  @Put(path: 'password_update?email={email}')
  Future<Response> password_update_email(
      @Header("Content-Type") String appjson,
      @Body() PasswordResetRespJModel passwordResetRespJModel,
      @Path('email') String email);

  /*static PostApiService create() {
    final client = ChopperClient(
      baseUrl: baseUrlStr,
      services: [
        _$PostApiService(),
      ],
      converter: BuiltValueConverter(),
      interceptors: [HttpLoggingInterceptor()],
    );
    return _$PostApiService(client);
  }*/

  static PostApiService create() {
    final client = ChopperClient(
      baseUrl: baseUrlStr,
      services: [
        _$PostApiService(),
      ],
      converter: JsonConverter(),
      interceptors: [HttpLoggingInterceptor()],
    );

    return _$PostApiService(client);
  }
}
