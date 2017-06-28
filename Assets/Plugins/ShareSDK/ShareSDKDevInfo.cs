using UnityEngine;
using System.Collections;
using System;

namespace cn.sharesdk.unity3d 
{
	[Serializable]
	public class DevInfoSet

	{
		public WeChat wechat;
		public WeChatMoments wechatMoments; 
		public WeChatFavorites wechatFavorites;
	}

	public class DevInfo 
	{	
		public bool Enable = true;
	}
	
	[Serializable]
	public class WeChat : DevInfo 
	{	
		#if UNITY_ANDROID
		public string SortId = "1";
		public const int type = (int) PlatformType.WeChat;
		public string AppId = "wxa8fd7582c564fa94";
		public string AppSecret = "f13a7c1b9436d05c2c62254492215bb7";
		public bool BypassApproval = true;
#elif UNITY_IPHONE
		public const int type = (int) PlatformType.WeChat;
		public string app_id = "wxa8fd7582c564fa94";
		public string app_secret = "f13a7c1b9436d05c2c62254492215bb7";
#endif
  }

  [Serializable]
	public class WeChatMoments : DevInfo 
	{
		#if UNITY_ANDROID
		public string SortId = "2";
		public const int type = (int) PlatformType.WeChatMoments;
		public string AppId = "wxa8fd7582c564fa94";
		public string AppSecret = "f13a7c1b9436d05c2c62254492215bb7";
		public bool BypassApproval = false;
#elif UNITY_IPHONE
		public const int type = (int) PlatformType.WeChatMoments;
		public string app_id = "wxa8fd7582c564fa94";
		public string app_secret = "f13a7c1b9436d05c2c62254492215bb7";
#endif
  }

  [Serializable]
	public class WeChatFavorites : DevInfo 
	{
		#if UNITY_ANDROID
		public string SortId = "3";
		public const int type = (int) PlatformType.WeChatFavorites;
		public string AppId = "wxa8fd7582c564fa94";
		public string AppSecret = "f13a7c1b9436d05c2c62254492215bb7";
#elif UNITY_IPHONE
		public const int type = (int) PlatformType.WeChatFavorites;
		public string app_id = "wxa8fd7582c564fa94";
		public string app_secret = "f13a7c1b9436d05c2c62254492215bb7";
#endif
  }
}
