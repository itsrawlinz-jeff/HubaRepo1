class DatingAppStaticParams {
  DatingAppStaticParams._();

  static String baseUrlWSIP_Address =
  'ws://';


  static const String authorizationConst = 'Authorization';
  static const String content_Type = 'Content-Type';
  static String authorization = 'Authorization';
  static String token = 'token';
  static String tokenWspace = 'token ';
  static String basicWspace = 'Basic ';
  static String application_json = 'application/json';
  static String multipart_data = 'multipart/form-data';
  static String TECHNICIAN = 'TECHNICIAN';
  static String TICKET_MANAGER = 'TICKET MANAGER';
  static String TEAMLEAD = 'TEAM LEAD';
  static String SAFETYOFFICER = 'SAFETY OFFICER';
  static String PROJECTMANAGER = 'PROJECT MANAGER';
  static String SUPERVISOR = 'SUPERVISOR';
  static String HOD = 'HOD';
  static String WAREHOUSEATTENDANT = 'WAREHOUSE ATTENDANT';
  static String Default_Sound_Socket = 'Default_Sound_Socket';

  //PERMISSIONS
  static String str_ticket = 'ticket';
  //END OF PERMISSIONS

  static int MAX_BIG_INT = 9223372036854775807;

  static String lc_Open = 'open';
  static String lc_Closed = 'closed';
  static String lc_In_progress = 'in progress';
  static String lc_Pending = 'Pending';
  static String lc_Resolved = 'resolved';

  static String st_approved = 'approved';
  static String st_rejected = 'rejected';

  static String str_websocket = 'websocket';

  //OHS FORMS
  static String ohs_Safety_Induction = 'Safety Induction Form';
  static String ohs_Toolbox_Attendance = 'Toolbox Talks Form';
  static String ohs_Job_Hazard_Analysis = 'Job Hazard Analysis Form';
  static String ohs_Project_Communication_Plan =
      'Project Communication Plan Form';
  static String ohs_Incident_Notification = 'Incident Notification Form';
  static String ohs_Pwt = 'Permit To Work Form';

  static String ohs_PPE = 'PPEs';
  static String ohs_SSE = 'Site Safety Equipment';
  static String ohs_site_inspection = 'Site Inspection Form';
  static String ohs_certifcates = 'Certificates';

  static List<String> ohs_Forms = [
    ohs_Safety_Induction,
    ohs_Toolbox_Attendance,
    ohs_Job_Hazard_Analysis,
    ohs_Project_Communication_Plan,
    ohs_Incident_Notification,
    ohs_Pwt,
    ohs_PPE,
    ohs_SSE,
    //ohs_Images,
    ohs_site_inspection,
    ohs_certifcates
  ];

  //FIELD NAMES
  static String createdby = 'createdby';
  static String approvedby = 'approvedby';
  static String user = 'user';
  static String approved = 'approved';
  static String approveddate = 'approveddate';
  static String active = 'active';
  static String hobby = 'hobby';
  static String income_range = 'income_range';
  static String name = 'name';

  static String match_to = 'match_to';
  static String matching_user = 'matching_user';
  static String interestedin = 'interestedin';
  static String age_low = 'age_low';
  static String age_high = 'age_high';
  static String fb_insta_link = 'fb_insta_link';
  static String first_name = 'first_name';
  static String last_name = 'last_name';
  static String email = 'email';
  static String username = 'username';
  static String phone_number = 'phone_number';
  static String picture = 'picture';
  static String createdate = 'createdate';
  static String txndate = 'txndate';

  static String quote = 'quote';
  static String age = 'age';
  static String fb_link = 'fb_link';
  static String insta_link = 'insta_link';
  static String date_match_mode = 'date_match_mode';

  //QUERY LIMITS
  static String default_Query_Limit = '15';
  static int default_Future_delayed_to_build_layout = 50;
  static int default_Future_delayed_to_initial_query = 55;
  static String default_Max_int = '9223372036854775807';
  static String fiber = 'fiber';
  static int default_animation_curve_divider = 9;

  //BACKEND
  static String SYSTEM = 'SYSTEM';
  static String MOBILE_APP_USER = 'MOBILE_APP_USER';
  static String Like = 'Like';
  static String Nope = 'Nope';
  static String Super_Like = 'Super Like';
  static String mpesa_payment = 'mpesa_payment';
}
