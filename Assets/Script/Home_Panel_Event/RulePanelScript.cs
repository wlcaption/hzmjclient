using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using AssemblyCSharp;
using System.Collections.Generic;


public class RulePanelScript : MonoBehaviour {
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	public void closeDialog(){
    SoundCtrl.getInstance().playSoundUI();
		RulePanelScript self = GetComponent<RulePanelScript> ();
		self = null;
		Destroy (this);
		Destroy (gameObject);
	}
}
