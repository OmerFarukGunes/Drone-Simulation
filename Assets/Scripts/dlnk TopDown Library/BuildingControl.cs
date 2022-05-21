// TOPDOWN CONTROL SCRIPTS 1.0 www.dlnkworks.com 2016(c) This script is licensed as free content in the pack. Support is not granted while this is not part of the art pack core. Is licensed for commercial purposes while not for resell.

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class BuildingControl : MonoBehaviour {

    //vars
    public string BuildingName = "";
    [HideInInspector]
    public bool CheapDecoration;
    [HideInInspector]
    public TownManager TownManagerScript;
    [HideInInspector]
    public int ActualFloor = 0;
    [HideInInspector]
    public int PreviousTest;

    [System.Serializable]
    public class Target
    {
        public string FloorName = "New Floor";
        public GameObject TargetGo;
        public int FloorNum;
        public bool AllFloors = false;
        public GameObject PropsGroup;
        public GameObject CeilingShadow;
    };
    public List<Target> Floors;

    // Use this for initialization
    void Start() {

        // Set initial values
        PreviousTest = Floors.Count;
        ActualFloor = PreviousTest;

        // FPS mode
        if (TownManagerScript.FPSMode)
            {
            foreach (Target fl in Floors)
            { 
                fl.TargetGo.SetActive(true);
  //              fl.PropsGroup.SetActive(true);
            }
        }
    }
	
	// Update is called once per frame
	void Update () {
        // View actual floor in console
        //Debug.Log(ActualFloor + " " + PreviousTest);
        // Check if the floor has changed from the previous update
        if (TownManagerScript.PlayerLocation == BuildingName)
        {
            // Let Town Manager know what building we're entering on
            TownManagerScript.PlayerLocation = BuildingName;

            //Change the visible floors for each building group

            if (!TownManagerScript.FPSMode)
            {
                foreach (Target fl in Floors)
                {
                    // Set inactive upper levels
                    if (ActualFloor < fl.FloorNum)
                        fl.TargetGo.SetActive(false);
                    // Set active lower and actual levels
                    else
                        fl.TargetGo.SetActive(true);
                    // Set visible fake ceiling shadow for realtime lighting
                    if (fl.CeilingShadow != null)
                    {
                        if (ActualFloor <= fl.FloorNum)
                            fl.CeilingShadow.SetActive(true);
                        else
                            fl.CeilingShadow.SetActive(false);
                    }
                }
            }
            else
            {
                // FPS mode
                if (TownManagerScript.FPSMode)
                {
                    foreach (Target fl in Floors)
                    {
                        fl.TargetGo.SetActive(true);
                //        fl.PropsGroup.SetActive(true);
                        fl.CeilingShadow.SetActive(false);
                    }
                }
            }
     
            // Store the floor level in this call to check if changed in next one
            PreviousTest = ActualFloor;
        }

        // Delete unnecesary deco items if required by Town Manager
        if (CheapDecoration)
        {
            foreach (Target fl in Floors)
            {
                if (fl.PropsGroup != null) {
                    if (TownManagerScript.PlayerLocation == BuildingName)
                {
                    if ((fl.FloorNum == ActualFloor) || (fl.AllFloors))
                        fl.PropsGroup.SetActive(true);
                    else
                        fl.PropsGroup.SetActive(false);
                }
                else
                    fl.PropsGroup.SetActive(false);
                }
            }
        }
    }
}
