using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivateGO : MonoBehaviour
{
    // Public vars
    [Header("[Source]")]
    public TownManager ManagerScript;
    public List<GameObject> TargetGO = new List<GameObject>();
    public GameObject GOnTrigger;

    [Header("[ActivateGO Settings]")]
    public bool OverrideScene = false;
    public bool Enable;

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
        // Unable Ontrigger object
        GOnTrigger.SetActive(false);
        // Check active object
        foreach (GameObject GO in TargetGO)
        if (!OverrideScene)
        {
            if (GO.activeInHierarchy)
                Enable = true;
            else
                Enable = false;
        }
        else
        {
            GO.SetActive(Enable);
        }
    }

    // When any collider hits the trigger.
    void OnTriggerEnter(Collider trig)
    {
        // active Object ontrigger
        GOnTrigger.SetActive(true);
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
        // deactive Object ontrigger
        GOnTrigger.SetActive(false);
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
            // Set movement on when Key pressed
            if (Input.GetKeyUp(UnlockKey))
            {
                foreach (GameObject GO in TargetGO)
                    if (!GO.activeInHierarchy)
                    GO.gameObject.SetActive(true);
                else
                    GO.gameObject.SetActive(false);
            }
        }

    }
}