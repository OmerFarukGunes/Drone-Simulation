// TOPDOWN CONTROL SCRIPTS 1.0 www.dlnkworks.com 2016(c) This script is licensed as free content in the pack. Support is not granted while this is not part of the art pack core. Is licensed for commercial purposes while not for resell.

using UnityEngine;
using System.Collections;
using System;

public class PushTrigger : MonoBehaviour {

    // Public vars
    [Header("[Source]")]
    public TownManager ManagerScript;
    public Transform DoorHinge;
    [Header("[Door Settings]")]
    public bool opened;
    public float Percentage = 100;
    public bool auto = false;
    [Header("[Movement Settings]")]
    public Vector3 XYZDisplacement;
    public Quaternion Rotation = new Quaternion(0f,90f,0f,100f);
    public float Duration;
    [Range(0, 100)]


 

    // Private vars
    [HideInInspector]
    public KeyCode UnlockKey;
    private Collider _activator;
    private float _timer = 0;
    private bool _iscolliding = false;
    private bool _ismoving = false;
    private float _percentage = 0;

    // Use this for initialization
    void Start () {
        // make this object invisible
        this.gameObject.GetComponent<MeshRenderer>().enabled = false;
        if (opened)
        {
            DoorHinge.transform.localPosition = XYZDisplacement;
      //      DoorHinge.rotation= new Quaternion(Rotation.x, Rotation.y,Rotation.z, Rotation.w);
            _percentage = 100;
        }
    }

    // When any collider hits the trigger.
    void OnTriggerEnter(Collider trig)
    {
        // get player collider
        _activator = ManagerScript.PlayerCollider;
        //Debug.Log(trig.name + "has entered the door trigger");
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
        Debug.Log(trig.name + "has exit the door trigger");
    }

    // Update is called once per frame
    void Update () {
        // check if ready to move
        if (_iscolliding)
        {
                // get unlock key code
                UnlockKey = ManagerScript.DoorKeyCode;
            // Set movement on when Key pressed
            if (Input.GetKey(UnlockKey) || (auto))
            {
                _ismoving = true;
                Debug.Log("Door Unlocked");
            }
        }
        if (_ismoving)
        {
            // Get time updated and fixed
            _timer = _timer + Time.deltaTime;

            //set percentage of movement done
            if (!opened)
            _percentage = (_timer / Duration);
            else
            _percentage = (1-(_timer / Duration));
            // debug
           // Debug.Log("Movement done: " + (_percentage * 100) + "%");

            //stop movement when time is over.
            if (_percentage > (Percentage * 0.01f))
            {
                _ismoving = false;
                _percentage = 1;
                _timer = 0f;
                opened = true;
                // debug
                Debug.Log("Door Opened");
            }
            else
                if (_percentage < 0f)
            {
                _ismoving = false;
                _percentage = 0;
                _timer = 0f;
                opened = false;
                // debug
                Debug.Log("Door Closed");
            }
            // Move position
            DoorHinge.transform.localPosition = (_percentage * XYZDisplacement );
            // Rotate
            DoorHinge.transform.localRotation = new Quaternion(Rotation.x * _percentage, Rotation.y * _percentage, Rotation.z * _percentage, Rotation.w);

            //debug
            Debug.Log(DoorHinge + " is moved: " + (XYZDisplacement  * _percentage) + "and rotated: " + (Rotation) + " degrees from original position");
        }

    }
}
