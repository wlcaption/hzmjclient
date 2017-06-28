using System.Runtime.InteropServices;
using Holagames;

public class PayService {
#if UNITY_IPHONE
[DllImport ("__Internal")]
private static extern void _Pay(string product_id, string account_id);

[DllImport ("__Internal")]
private static extern void _WeiPay(string product_id, string account_id);
#endif

  public static void Pay(string product_id, string account_id, bool inAppPay = false) {
#if UNITY_ANDROID
    HolagamesSDK.getInstance().Pay(product_id);
#elif UNITY_IPHONE
    if (inAppPay) {
      _Pay(product_id, account_id);
	} else {
	  _WeiPay(product_id, account_id);
	}
#endif
  }
}
