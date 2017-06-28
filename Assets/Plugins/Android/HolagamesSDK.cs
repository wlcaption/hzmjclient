using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Holagames
{
    public class HolagamesSDK
    {
        private static HolagamesSDK _instance;

        private AndroidJavaClass jc;
        private AndroidJavaObject jo;

        public static HolagamesSDK getInstance()
        {
            if (null == _instance)
            {
                _instance = new HolagamesSDK();
            }
            return _instance;
        }

        public HolagamesSDK()
        {
            jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
        }

        public void Pay(string msg)
        {
            Debug.Log("android pay=" + msg);
            jo.Call("Pay", msg);
        }
    }
}

