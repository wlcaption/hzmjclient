using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Holagames;

public class MaJiangGameCenter : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    void OnGUI()
    {
        if (GUILayout.Button("Pay", GUILayout.Height(200), GUILayout.Width(400)))
        {
            HolagamesSDK.getInstance().Pay("0.01_AndroidS1_10001_1_6"); //分别是价格 服务器 游戏id 支付类型 发放的钻石
        }
    }
}
