﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using AnyThinkAds.Api;
public class MainScenes : MonoBehaviour {

	// Use this for initialization
	void Start () {
        AnyThinkAds.Demo.ATManager.loadToolsPlugins ();
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void gotoNativeScenes(){
//		DebugConsole.Log ("gotoNativeScenes");
		Debug.Log ("Developer gotoNativeScenes");
		#if UNITY_ANDROID
            AnyThinkAds.Demo.ATManager.msgTools.printLogI ("gotoNativeScenes....");
		#endif

		SceneManager.LoadScene ("nativeMainScenes");
	}
	public void gotoVideoScenes(){
//		DebugConsole.Log ("gotoVideoScenes");
		Debug.Log ("Developer gotoVideoScenes");
		#if UNITY_ANDROID
            AnyThinkAds.Demo.ATManager.msgTools.printLogI ("gotoVideoScenes....");
		#endif
		SceneManager.LoadScene ("videoMainScenes");
	}

    public void gotoBannerScences(){
        Debug.Log("Developer gotoBannerScenes");
        SceneManager.LoadScene("bannerMainScenes");
    }

    public void gotoInterstitialScences()
    {
        Debug.Log("Developer gotoInterstitialScences");
        SceneManager.LoadScene("interstitialMainScenes");
    }

    public void gotoNativeBannerScene() {
    	Debug.Log("Developer gotoNativeBannerScene");
        SceneManager.LoadScene("NativeBannerScene");
    }

    private class InitListener : ATSDKInitListener
    {
        public void initSuccess()
        {
			Debug.Log("Developer Develop callback SDK initSuccess");
        }
        public void initFail(string msg)
        {
			Debug.Log("Developer callback SDK initFail:" + msg);
        }
    }

    private class GetLocationListener:ATGetUserLocationListener
    {
        public void didGetUserLocation(int location)
        {
            Debug.Log("Developer callback didGetUserLocation(): " + location);
        }
    }

	public void initSDK(){
//		DebugConsole.Log ("init sdk");
		Debug.Log("Developer Version of the runtime: " + Application.unityVersion);
		Debug.Log ("Developer init sdk");
		Debug.Log(" Developer Screen size : {" + Screen.width + ", " + Screen.height + "}");
        ATSDKAPI.setChannel("unity3d_test_channel");
        ATSDKAPI.setSubChannel("unity3d_test_Subchannel");
        ATSDKAPI.initCustomMap(new Dictionary<string, string> { { "unity3d_data", "test_data" } });
        ATSDKAPI.setCustomDataForPlacementID(new Dictionary<string, string> { { "unity3d_data_pl", "test_data_pl" } },"b5b728e7a08cd4");
        ATSDKAPI.setLogDebug(true);
        
        Debug.Log("Developer DataConsent: " + ATSDKAPI.getGDPRLevel());
        Debug.Log("Developer isEUTrafic: " + ATSDKAPI.isEUTraffic());
       

#if UNITY_ANDROID
       ATSDKAPI.initSDK("a5aa1f9deda26d", "4f7b9ac17decb9babec83aac078742c7", new InitListener());
#elif UNITY_IOS || UNITY_IPHONE
        ATSDKAPI.initSDK("a5b0e8491845b3", "7eae0567827cfe2b22874061763f30c9", new InitListener());
#endif


        // 针对欧盟地区GDPR设置。每次启动如在欧洲且没有设置GDPR等级，都会打开授权页面
        // 设置过GDPR等级，则不会再弹授权页面
        if(ATSDKAPI.isEUTraffic() && ATSDKAPI.getGDPRLevel() == ATSDKAPI.UNKNOWN){
            ATSDKAPI.showGDPRAuth();
        }
}

	public void showGDPRAuth(){
		Debug.Log ("Developer showGDPRAuth");
	
        ATSDKAPI.showGDPRAuth();


	}
		
}
 