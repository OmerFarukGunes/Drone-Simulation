using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetMaterialGO : MonoBehaviour
{
    // Public vars
    [Header("[Source]")]
    public TownManager ManagerScript;
    public List<GameObject> SwitchGO = new List<GameObject>();


    [Header("[Material Settings]")]
    public Material OriginalMaterial;
    public Material SwitchedMaterial;
    public bool EnableSwitch;

    // Private vars
    [HideInInspector]
    public KeyCode UnlockKey;
    private Collider _activator;
    private bool _iscolliding = false;

    // Use this for initialization
    void Start()
    {
        // make this object invisible
        this.gameObject.GetComponent<MeshRenderer>().enabled = false;
        // Check active object
        foreach (GameObject GO in SwitchGO)
            if (EnableSwitch)
            {
                GO.GetComponent<Renderer>().material = SwitchedMaterial;
            }
            else
            {
                GO.GetComponent<Renderer>().material = OriginalMaterial;
            }
    }

    // When any collider hits the trigger.
    void OnTriggerEnter(Collider trig)
    {
        // get player collider
        _activator = ManagerScript.PlayerCollider;
        //Debug.Log(trig.name + "has entered the activator trigger");
        // check if Key pressed and collider hit was from correct target
        if (trig.GetComponent<Collider>() == _activator)
        {
            // set the door ready to move
            _iscolliding = true;
        }
    }
    void OnTriggerExit(Collider trig)
    {
        // set the door out of reach
        _iscolliding = false;
        //debug
        Debug.Log(trig.name + "has exit the activator trigger");
    }

    // Update is called once per frame
    void Update()
    {
        // check if ready to move
        if (_iscolliding)
        {
            // get unlock key code
            UnlockKey = ManagerScript.DoorKeyCode;
            // Set materials on when Key pressed
            if (Input.GetKeyUp(UnlockKey))
            {
                if (EnableSwitch)
                {
                    EnableSwitch = false;
                    foreach (GameObject GO in SwitchGO)
                        GO.GetComponent<Renderer>().material = OriginalMaterial;
                }
                else
                {
                    EnableSwitch = true;
                    foreach (GameObject GO in SwitchGO)
                    GO.GetComponent<Renderer>().material = SwitchedMaterial;

                }
            }
        }

    }
}