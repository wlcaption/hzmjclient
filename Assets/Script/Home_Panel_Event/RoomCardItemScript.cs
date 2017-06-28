using UnityEngine;
using AssemblyCSharp;

public class RoomCardItemScript : MonoBehaviour{
  public GameObject rewardIcon;
  private bool hasProxy = false;

  // Use this for initialization
  void Start () {
    hasProxy = GlobalDataScript.hasProxy;
    rewardIcon.SetActive(hasProxy);
	}
	
	// Update is called once per frame
	void Update () {
    if (hasProxy != GlobalDataScript.hasProxy) {
      hasProxy = GlobalDataScript.hasProxy;
      rewardIcon.SetActive(hasProxy);
    }
  }
}
