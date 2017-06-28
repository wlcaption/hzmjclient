using UnityEngine;
using AssemblyCSharp;

public class RoomCardScript : MonoBehaviour{
  private int roomCardCount_ = 0;
	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
	}

  public void OnPay(int index) {
    roomCardCount_ = 0;
    string product = "";
    string account_id = GlobalDataScript.loginResponseData.account.uuid.ToString();
    bool hasProxy = GlobalDataScript.hasProxy;
    switch (index) {
      case 0:
      product = "6_AndroidS1_" + account_id + "_1_";
      roomCardCount_ = hasProxy? 10: 8;
      product = product + roomCardCount_;
      break;
      case 1:
      product = "18_AndroidS1_" + account_id + "_1_";
      roomCardCount_ = hasProxy? 30: 24;
      product = product + roomCardCount_;
      break;
      case 2:
      product = "30_AndroidS1_" + account_id + "_1_";
      roomCardCount_ = hasProxy? 50: 40;
      product = product + roomCardCount_;
      break;
      case 3:
      product = "68_AndroidS1_" + account_id + "_1_";
      roomCardCount_ = hasProxy? 115: 92;
      product = product + roomCardCount_;
      break;
      case 4:
      product = "128_AndroidS1_" + account_id + "_1_";
      roomCardCount_ = hasProxy? 220: 175;
      product = product + roomCardCount_;
      break;
      case 5:
      product = "328_AndroidS1_" + account_id + "_1_";
      roomCardCount_ = hasProxy? 568: 450;
      product = product + roomCardCount_;
      break;
    }
#if UNITY_IPHONE
  if (GlobalDataScript.inAppPay) {
      switch (index) {
        case 0:
        product = "com.holagames.njmj.d6";
        break;
        case 1:
        product = "com.holagames.njmj.d18";
        break;
        case 2:
        product = "com.holagames.njmj.d30";
        break;
        case 3:
        product = "com.holagames.njmj.d68";
        break;
        case 4:
        product = "com.holagames.njmj.d128";
        break;
        case 5:
        product = "com.holagames.njmj.d328";
        break;
      }
    }
#endif
    PayService.Pay(product, account_id, GlobalDataScript.inAppPay);
  }

  public void PayCallback(string message) {
    Debug.Log("PayCallback: " + message);
    if (message.Equals("success")) {
#if UNITY_IPHONE
    if (GlobalDataScript.inAppPay) {
        CustomSocket.getInstance().sendMsg(new UpdateRoomCardRequest(roomCardCount_));
	  } else {
		  CustomSocket.getInstance().sendMsg(new UpdateRoomCardRequest(0));
	  }
#else
      CustomSocket.getInstance().sendMsg(new UpdateRoomCardRequest(0));
#endif
      TipsManagerScript.getInstance().setTips("充值成功");
    } else {
      TipsManagerScript.getInstance().setTips("充值失败");
    }
  }
}
