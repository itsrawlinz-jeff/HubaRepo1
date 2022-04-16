import 'package:connectivity/connectivity.dart';

bool isStringValid(String str) {
  bool isvalid = true;
  if (str == null || !(str.trim().length > 0)) {
    isvalid = false;
  }
  return isvalid;
}

bool isresponseSuccessfull(int statusCode) {
  bool isSuccessfull = false;
  if (statusCode!=null && statusCode >= 200 && statusCode < 300) {
    isSuccessfull = true;
  }
  return isSuccessfull;
}

bool isresponse400(int statusCode) {
  bool is400 = false;
  if (statusCode == 400) {
    is400 = true;
  }
  return is400;
}

Future<bool> isNetworkConnectionActive() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  bool isConnected = false;
  if (connectivityResult != ConnectivityResult.none) {
    isConnected = true;
  }
  return isConnected;
}

dynamic checkInternet(Function func) {
  isNetworkConnectionActive().then((intenet) {
    if (intenet != null && intenet) {
      func(true);
    } else {
      func(false);
    }
  });
}

bool isIntValid(int intVal) {
  bool isValid = false;
  if (intVal != null && intVal > 0) {
    isValid = true;
  }
  return isValid;
}


bool ifStringValid(String strVal) {
  bool rtnBool = true;
  if (strVal == null || !(strVal.trim().length > 0)) {
    rtnBool = false;
  }
  return rtnBool;
}



