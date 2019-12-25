package com.anythink.unitybridge.interstitial;


/**
 * Copyright (C) 2018 {XX} Science and Technology Co., Ltd.
 *
 * @version V{XX_XX}
 * @Author ：Created by zhoushubin on 2018/8/3.
 * @Email: zhoushubin@salmonads.com
 */
public interface InterstitialListener {

    public void onInterstitialAdLoaded(String unitId);

    public void onInterstitialAdLoadFail(String unitId, String code, String msg);

    public void onInterstitialAdClicked(String unitId);

    public void onInterstitialAdShow(String unitId);

    public void onInterstitialAdClose(String unitId);

    public void onInterstitialAdVideoStart(String unitId);

    public void onInterstitialAdVideoEnd(String unitId);

    public void onInterstitialAdVideoError(String unitId, String code, String msg);
}