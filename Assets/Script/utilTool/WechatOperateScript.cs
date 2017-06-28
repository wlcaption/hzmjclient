﻿using UnityEngine;
using System.Collections;
using cn.sharesdk.unity3d;
using AssemblyCSharp;
using System;
using System.IO;
using System.Diagnostics;
using LitJson;

/**
 * 微信操作
 */
public class WechatOperateScript : MonoBehaviour {
  public ShareSDK shareSdk;
  private string picPath;
  //
  void Start() {
    if (shareSdk != null) {
      shareSdk.showUserHandler = getUserInforCallback;
      shareSdk.shareHandler = onShareCallBack;
    }

  }


  void Update() {

  }


  public bool isWechatValid() {
    return shareSdk.IsClientValid(PlatformType.WechatPlatform);
  }


  /**
	 * 登录，提供给button使用
	 * 
	 */
  public void login() {
#if USE_DEBUG || UNITY_EDITOR
    debugLogin();
#else
    shareSdk.GetUserInfo(PlatformType.WeChat);
#endif
  }

  /**
	 * 获取微信个人信息成功回调,登录
	 *
	 */
  public void getUserInforCallback(int reqID, ResponseState state, PlatformType type, Hashtable data) {
    //TipsManagerScript.getInstance ().setTips ("获取个人信息成功");

    if (state == ResponseState.Fail) {
      if (GlobalDataScript.inAppPay) {
        TipsManagerScript.getInstance().setTips("微信登录失败,以游客身份登陆");
        debugLogin();
      } else {
        TipsManagerScript.getInstance().setTips("微信登录失败");
      }
      return;
    }

    if (data != null) {
      UnityEngine.Debug.Log(data.toJson());
      LoginVo loginvo = new LoginVo();
      try {

        loginvo.openId = (string)data["openid"];
        loginvo.nickName = (string)data["nickname"];
        loginvo.headIcon = (string)data["headimgurl"];
        loginvo.unionid = (string)data["unionid"];
        loginvo.province = (string)data["province"];
        loginvo.city = (string)data["city"];
        string sex = data["sex"].ToString();
        loginvo.sex = int.Parse(sex);
        loginvo.IP = GlobalDataScript.getInstance().getIpAddress();
        String msg = JsonMapper.ToJson(loginvo);

        CustomSocket.getInstance().sendMsg(new LoginRequest(msg));

        GlobalDataScript.loginVo = loginvo;
        GlobalDataScript.loginResponseData = new AvatarVO();
        GlobalDataScript.loginResponseData.account = new Account();
        GlobalDataScript.loginResponseData.account.city = loginvo.city;
        GlobalDataScript.loginResponseData.account.openid = loginvo.openId;
        UnityEngine.Debug.Log(" loginvo.nickName:" + loginvo.nickName);
        GlobalDataScript.loginResponseData.account.nickname = loginvo.nickName;
        GlobalDataScript.loginResponseData.account.headicon = loginvo.headIcon;
        GlobalDataScript.loginResponseData.account.unionid = loginvo.city;
        GlobalDataScript.loginResponseData.account.sex = loginvo.sex;
        GlobalDataScript.loginResponseData.IP = loginvo.IP;

      } catch (Exception e) {
        UnityEngine.Debug.Log("微信接口有变动！" + e.Message);
        TipsManagerScript.getInstance().setTips("请先打开你的微信客户端");
        return;
      }
    } else {
      if (GlobalDataScript.inAppPay) {
        TipsManagerScript.getInstance().setTips("微信登录失败,以游客身份登陆");
        debugLogin();
      } else {
        TipsManagerScript.getInstance().setTips("微信登录失败");
      }
    }
  }


  /***
	 * 分享战绩成功回调
	 */
  public void onShareCallBack(int reqID, ResponseState state, PlatformType type, Hashtable result) {
    if (state == ResponseState.Success) {
      TipsManagerScript.getInstance().setTips("分享成功");

    } else if (state == ResponseState.Fail) {
      UnityEngine.Debug.Log("share fail :" + result["msg"]);
    }
  }

  /**
	 * 分享战绩、战绩
	 */
  public void shareAchievementToWeChat(PlatformType platformType) {
    StartCoroutine(GetCapture(platformType));
  }

  /**
	 * 执行分享到朋友圈的操作
	 */
  private void shareAchievement(PlatformType platformType) {
    ShareContent customizeShareParams = new ShareContent();
    customizeShareParams.SetText("");
    customizeShareParams.SetImagePath(picPath);
    customizeShareParams.SetShareType(ContentType.Image);
    customizeShareParams.SetObjectID("");
    customizeShareParams.SetShareContentCustomize(platformType, customizeShareParams);
    shareSdk.ShareContent(platformType, customizeShareParams);
  }

  /**
	 * 截屏
	 * 
	 * 
	 */
  private IEnumerator GetCapture(PlatformType platformType) {
    yield return new WaitForEndOfFrame();
    if (Application.platform == RuntimePlatform.Android || Application.platform == RuntimePlatform.IPhonePlayer)

      picPath = Application.persistentDataPath;

    else if (Application.platform == RuntimePlatform.WindowsPlayer)

      picPath = Application.dataPath;

    else if (Application.platform == RuntimePlatform.WindowsEditor) {
      picPath = Application.dataPath;
      picPath = picPath.Replace("/Assets", null);
    }

    picPath = picPath + "/screencapture.png";

    UnityEngine.Debug.Log("picPath:" + picPath);

    int width = Screen.width;
    int height = Screen.height;
    Texture2D tex = new Texture2D(width, height, TextureFormat.RGB24, false);
    tex.ReadPixels(new Rect(0, 0, width, height), 0, 0, true);
    tex.Apply();
    byte[] imagebytes = tex.EncodeToPNG();//转化为png图
    tex.Compress(false);//对屏幕缓存进行压缩
    UnityEngine.Debug.Log("imagebytes:" + imagebytes);
    if (File.Exists(picPath)) {
      File.Delete(picPath);
    }
    File.WriteAllBytes(picPath, imagebytes);//存储png图
    Destroy(tex);
    shareAchievement(platformType);
  }




  public void inviteFriend() {
      RoomCreateVo roomvo = GlobalDataScript.roomVo;
    if (GlobalDataScript.roomVo != null) {
      GlobalDataScript.totalTimes = roomvo.realRoundNumber();
      GlobalDataScript.surplusTimes = roomvo.realRoundNumber();
      string str = "";

      str += "南京麻将,";
      if (roomvo.paofen > 0) {
        str += "跑" + roomvo.realPaofen() + ",";
      }
      if (roomvo.roundtype == 0) {
        str += "进园子";
        str += "  " + roomvo.realYuanzishu() + ",";
        str += roomvo.realYuanziRule() + "家干,";
      } else {
        str += "敞开头,";
        str += "圈数：" + roomvo.realRoundNumber() + ",";
      }
      if (roomvo.zashu > 0) {
        str += "砸" + roomvo.realZaShu() + ",";
      }
      if (roomvo.zhanzhuangbi) {
        str += "比下胡,";
      }
    /*
      if (roomvo.guozhuangbi) {
        str += "过庄比,";
      }
    */
    
    
      str += "有胆，你就来！";

      string title = "点点南京麻将  " + "房间号：" + roomvo.roomId;
      ShareContent customizeShareParams = new ShareContent();
      customizeShareParams.SetTitle(title);
      customizeShareParams.SetText(str);
      customizeShareParams.SetUrl(APIS.ShareUrl);
      customizeShareParams.SetImageUrl(APIS.ImageUrl);
      customizeShareParams.SetShareType(ContentType.Webpage);
      customizeShareParams.SetObjectID("");
      shareSdk.ShowShareContentEditor(PlatformType.WeChat, customizeShareParams);
    }
  }

  public void shareZhanji(int id) {
    string str = "";

    str += "回放码为【" + id + "】,  ";
    str += "【" + GlobalDataScript.loginResponseData.account.nickname + "】 邀请您观看 【点点南京麻将】 中牌局回放记录";

    string title = "点点南京麻将";
    ShareContent customizeShareParams = new ShareContent();
    customizeShareParams.SetTitle(title);
    customizeShareParams.SetText(str);
    customizeShareParams.SetUrl(APIS.ShareUrl);
    customizeShareParams.SetImageUrl(APIS.ImageUrl);
    customizeShareParams.SetShareType(ContentType.Webpage);
    customizeShareParams.SetObjectID("");
    shareSdk.ShowShareContentEditor(PlatformType.WeChat, customizeShareParams);
  }


  public void debugLogin() {
    CustomSocket.getInstance().sendMsg(new LoginRequest(null));
  }
}
