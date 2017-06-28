using UnityEngine;
using System.Collections;
using System;
using System.Runtime.InteropServices;
using UnityEngine.UI;


public class AmapLocation {

#if UNITY_IPHONE
  [DllImport ("__Internal")]
  private static extern void _StartLocation();

  [DllImport ("__Internal")]
  private static extern void _EndLocation();
#endif

#if UNITY_ANDROID
  private AmapEvent amap;
  private AndroidJavaClass jcu;
  private AndroidJavaObject jou;
  private AndroidJavaObject mLocationClient;
  private AndroidJavaObject mLocationOption;
#endif
  public bool hasLocation = false;

  public double latitude = 0;
  public double longitude = 0;
  public string address;

  public void StartLocation() {
#if UNITY_ANDROID
    try {
      jcu = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
      jou = jcu.GetStatic<AndroidJavaObject>("currentActivity");
      mLocationClient = new AndroidJavaObject("com.amap.api.location.AMapLocationClient", jou);
      mLocationOption = new AndroidJavaObject("com.amap.api.location.AMapLocationClientOption");
      mLocationClient.Call("setLocationOption", mLocationOption);
      amap = new AmapEvent();
      amap.locationChanged += OnLocationChanged;
      mLocationClient.Call("setLocationListener", amap);
      mLocationClient.Call("startLocation");
    } catch (Exception ex) {
      Debug.Log(ex.Message);
      EndLocation();
    }
#elif UNITY_IPHONE
		_StartLocation();
#endif
  }

  public void EndLocation() {
#if UNITY_ANDROID
    if (amap != null) {
      amap.locationChanged -= OnLocationChanged;
    }
    if (mLocationClient != null) {
      mLocationClient.Call("stopLocation");
      mLocationClient.Call("onDestroy");
    }
#elif UNITY_IPHONE
	_EndLocation();
#endif
  }

#if UNITY_ANDROID
  private void OnLocationChanged(AndroidJavaObject amapLocation) {
    if (amapLocation != null) {
      if (amapLocation.Call<int>("getErrorCode") == 0) {
        try {
          latitude = amapLocation.Call<double>("getLatitude");
          longitude = amapLocation.Call<double>("getLongitude");
          address = amapLocation.Call<string>("getAddress");
          hasLocation = true;
          EndLocation();
        } catch (Exception ex) {
          Debug.Log(ex.Message);
        }
      } else {
          Debug.Log("amaperror, getErrorCode:" + amapLocation.Call<int>("getErrorCode").ToString() + "getErrorInfo:" + amapLocation.Call<string>("getErrorInfo"));
      }
      EndLocation();
    }
  }
#endif
}