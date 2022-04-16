
import 'package:dating_app/utils/data_validators.dart';

String extractFilenamefromPath(String filePath) {
  String TAG = 'extractFilenamefromPath:';
  String fileName = null;
  if (filePath != null) {
    try {
      List<String> filePathSplitList = filePath.split("/");
      fileName = filePathSplitList[filePathSplitList.length - 1];
    } catch (error) {
      print(TAG + 'error==');
      print(error);
    }
  }
  return fileName;
}

String stringFromNumber(int numberVal) {
  String TAG = 'stringFromNumber:';
  print(TAG);
  print(numberVal);
  String strVal = '';
  if (numberVal != null) {
    strVal = numberVal.toString();
  }
  return strVal;
}

int intFromString(String numberStr) {
  String TAG = 'intFromString:';
  print(TAG);
  int intVal = null;
  if (isStringValid(numberStr)) {
    try {
      intVal = int.parse(numberStr);
      return intVal;
    } catch (error) {
      print(TAG);
      print(error.toString());
      return intVal;
    }
  }
  return intVal;
}

double doubleFromString(String numberStr) {
  String TAG = 'doubleFromString:';
  print(TAG);
  double dbVal = null;
  if (isStringValid(numberStr)) {
    try {
      dbVal = double.parse(numberStr);
      return dbVal;
    } catch (error) {
      print(TAG);
      print(error.toString());
      return dbVal;
    }
  }
  return dbVal;
}
