using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using AssemblyCSharp;

public class ProxyPanelScript : MonoBehaviour{
  public GameObject proxyButton;
  public GameObject proxyPanel;
  public InputField proxyInput;

	// Use this for initialization
	void Start () {
    proxyButton.SetActive(GlobalDataScript.hasProxy == false);
    StartCoroutine(proxyBindCheck());
  }

  // Update is called once per frame
  void Update () {
	}

  public void OnProxyButtonClick() {
    proxyButton.SetActive(false);
    proxyPanel.SetActive(true);
  }

  public void OnProxyPanelCloseClick() {
    proxyPanel.SetActive(false);

    proxyButton.SetActive(GlobalDataScript.hasProxy == false);
  }

  public void OnBindButtonClick() {
    string senior_id = proxyInput.text;
    if (string.IsNullOrEmpty(senior_id) == false) {
      StartCoroutine(proxyBind(senior_id));
    } else {
      TipsManagerScript.getInstance().setTips("邀请码不能为空");
    }
  }

  private static readonly string bindCheckUrl = "http://njmj.holagames.cn/wechat/bindCheck.php";
  private static readonly string bindUrl = "http://njmj.holagames.cn/wechat/bind.php";
  //private static readonly string bindCheckUrl = "http://localhost/wechat/bindCheck.php";
  //private static readonly string bindUrl = "http://localhost/wechat/bind.php";
  private IEnumerator proxyBindCheck() {
    WWWForm data = new WWWForm();
    data.AddField("id", GlobalDataScript.loginResponseData.account.uuid);
    WWW www = new WWW(bindCheckUrl, data);
    yield return www;

    if (www != null && string.IsNullOrEmpty(www.error)) {
      Debug.Log(www.text);
      if ("1".Equals(www.text)) {
        GlobalDataScript.hasProxy = true;
      }
    } else {
      Debug.Log("bind Check failed.");
    }

    proxyButton.SetActive(GlobalDataScript.hasProxy == false);
  }

  private IEnumerator proxyBind(string seniorId) {
    WWWForm data = new WWWForm();
    data.AddField("senior_id", seniorId);
    data.AddField("junior_id", GlobalDataScript.loginResponseData.account.uuid);
    WWW www = new WWW(bindUrl, data);
    yield return www;

    if (www != null) {
      if (string.IsNullOrEmpty(www.error)) {
        if ("0".Equals(www.text)) {
          TipsManagerScript.getInstance().setTips("绑定成功");
          CustomSocket.getInstance().sendMsg(new UpdateRoomCardRequest(0));
          GlobalDataScript.hasProxy = true;
        } else {
          if (string.IsNullOrEmpty(www.text)) {
            TipsManagerScript.getInstance().setTips("绑定失败");
          } else {
            TipsManagerScript.getInstance().setTips("绑定失败（" + www.text + "）");
          }
        }
      } else {
        TipsManagerScript.getInstance().setTips("绑定失败（" + www.error + "）");
      }
    } else {
      TipsManagerScript.getInstance().setTips("绑定失败");
    }
  }
}
