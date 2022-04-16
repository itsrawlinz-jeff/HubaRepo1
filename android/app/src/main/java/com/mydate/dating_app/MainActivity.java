package com.mydate.dating_app;

import android.os.Bundle;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import java.util.*;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "biessek.rocks/flutter_country_picker";
    private String GET_COUNTRY_NAMES = "getCountryNames";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals(GET_COUNTRY_NAMES)) {
                            try {
                                ArrayList<String> ccodes = (ArrayList<String>) call.argument("isoCodes");
                                HashMap<String, String> countryNamesHmap = getCountryNames(ccodes);
                                result.success(countryNamesHmap);
                            }catch (Exception xx){
                                xx.printStackTrace();
                            }
                        }
                    }
                });
    }


    private HashMap<String, String> getCountryNames(ArrayList<String> isoCodes) {
        HashMap<String, String> localCountries = new HashMap<String, String>();
        for (String isoCode : isoCodes) {
            if (isoCode != null) {
                localCountries.put(isoCode, new Locale("", isoCode).getDisplayCountry());
            }
        }
        return localCountries;
    }
}
