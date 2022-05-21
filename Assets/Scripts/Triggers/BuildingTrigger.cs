// TOPDOWN CONTROL SCRIPTS 1.0 www.dlnkworks.com 2016(c) This script is licensed as free content in the pack. Support is not granted while this is not part of the art pack core. Is licensed for commercial purposes while not for resell.

using UnityEngine;
using System.Collections;
using System;

public class BuildingTrigger : MonoBehaviour {

    //public vars
    public enum Direction
    {
        RiseUpFloor,
        StayOnFloor,
        DownFloor
    }

    [Header("[Source]")]
    public BuildingControl Building;

    [Header("[Normal]")]
    public int FloorLevel;
    public int TargetFloor;

    [Header("[Dynamic]")]
    public bool Dynamic = true;
    public Direction FloorMovement;

    // hidden vars
    [HideInInspector]
    public bool Allvisible;
    private TownManager TownManagerScript;
    private Collider Activator;


	// Use this for initialization
	void Start () { 
        TownManagerScript = Building.TownManagerScript;
        // make this object invisible
        this.gameObject.GetComponent<MeshRenderer>().enabled = false;
	}

    // When any collider hits the trigger.
    void OnTriggerEnter(Collider trig)
    {
        // Set the correct character collider that will interact with this trigger.
        Activator = TownManagerScript.PlayerCollider;
        //LOG
        Debug.Log("Collision in course. Object: " + trig.name + ". Activator for this trigger [" + Activator + "] This floor is " + Building.ActualFloor + "Target floor is " + TargetFloor);
        // Set the Player Location at this building
        TownManagerScript.PlayerLocation = Building.BuildingName;
        // LOG
        Debug.Log("[Fase 1] Target floor is: " + TargetFloor);
        // Test if the colliders is from activator target (character)
        if (trig.GetComponent<Collider>() == Activator)
        {
            //If the result is possitive and the player did hit the trigger then we set the current floor to the one where the collider is located. Now we know where we are in the main script.
            Building.ActualFloor = FloorLevel;
            // LOG
            Debug.Log("[Fase 2] Target floor is: " + TargetFloor);
            //test if we're working with Direction or with target.
            if (Dynamic)
            {
                //test if we're rising up, down, or stand and change floor values.
                //LOG
                Debug.Log("Dynamic mode on");
                switch (this.FloorMovement)
                {
                    case Direction.RiseUpFloor:
                        Building.ActualFloor = FloorLevel + 1;
                        break;
                    case Direction.DownFloor:
                        Building.ActualFloor = FloorLevel - 1;
                        break;
                }
            }

            // In case we selected manual target floor, set it.
            else
            {
                // LOG
                Debug.Log("[Fase 1] Target floor is: " + TargetFloor);
                Building.ActualFloor = TargetFloor;
            }
        }
        TownManagerScript.ActualFloor = Building.ActualFloor;
        //LOG
        Debug.Log("Script finished. Building script Floor now is " + Building.ActualFloor);
    }
}   
