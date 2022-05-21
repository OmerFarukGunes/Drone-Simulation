// TOPDOWN CONTROL SCRIPTS 1.0 www.dlnkworks.com 2016(c) This script is licensed as free content in the pack. Support is not granted while this is not part of the art pack core. Is licensed for commercial purposes while not for resell.

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

[ExecuteInEditMode]
public class TownManager : MonoBehaviour {

    // Public vars
    [Header("[Global Settings]")]
    public bool EnableTownControl = true;
    public bool CheapDecoration = true;
    public bool OverrideLocalSett = true;

    [System.Serializable]
    public class Building
    {
        [HideInInspector]
        public string Name;
        public BuildingControl BuildingTarget;
        public bool CheapDecoration;
      
    };
    public List<Building> Buildings;

    // Hidden vars
    [HideInInspector]
    public string PlayerLocation;
    [HideInInspector]
    public Collider PlayerCollider;
    [HideInInspector]
    public int ActualFloor;
    [HideInInspector]
    public bool FPSMode = false;
    [HideInInspector]
    public KeyCode DoorKeyCode;


    // Use this for initialization
    void Start () {
        // Check if TopDown system is unabled
        if (!EnableTownControl)
            gameObject.GetComponent<TownManager>().enabled = false;
    }
	
	// Update is called once per frame
	void Update () {

        foreach (Building bg in Buildings)
        {
            // Set Building Name from Building Target
            bg.Name = bg.BuildingTarget.BuildingName;
            // Set Building Script associated with this Town Manager
            bg.BuildingTarget.TownManagerScript = this;
            // Use Global settings for interior decoration quality
            if (OverrideLocalSett)
                bg.BuildingTarget.CheapDecoration = CheapDecoration;
            // Use Local settings for interior decoration quality
            else
                bg.BuildingTarget.CheapDecoration = bg.CheapDecoration;

            // Enable or unable Building Control scripts according with Global settings
            if (EnableTownControl)
                bg.BuildingTarget.gameObject.GetComponent<BuildingControl>().enabled = true;
            else
                bg.BuildingTarget.gameObject.GetComponent<BuildingControl>().enabled = false;
        }

    }
}
