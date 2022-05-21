// TOPDOWN CONTROL SCRIPTS 1.0 www.dlnkworks.com 2016(c) This script is licensed as free content in the pack. Support is not granted while this is not part of the art pack core. Is licensed for commercial purposes while not for resell.

using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class SceneControl : MonoBehaviour {

    // public vars
    [Header("[Scene Settings]")]
    public Light SunLight;
    public Material SkyBackground;
    public AudioSource BackgroundMusic;
    public GameObject Fxs;
    public KeyCode EnableFx;
    [Header("[Player & Camera]")]
    public TownManager Town;
    public Collider PlayerCharacter;
    public bool EnableCameraMode;
    public GameObject FPSCamera;
    public GameObject TopDownCamera;
    public bool TopDownMode;
    [Header("[Interface]")]
    public KeyCode CameraSwitchKey = KeyCode.F5;
    public KeyCode HelpKey = KeyCode.F1;
    public KeyCode DecoCheap = KeyCode.F2;
    public KeyCode DoorKey;
    public Text LocationGUI;
    public Text CameraGUI;
    public Text HelpText;
    public Slider VolSlider;
    public Slider SunRotation;
    public Slider SunIntensity;
    public Texture2D myCursor;
    public Vector2 hotSopot = Vector2.zero;
    private float k;

    // hidden vars
    [HideInInspector]
    public bool FPSMode = false;

    // Use this for initialization
    void Start () {
        // Set Player Character on Town Manager script
        Town.PlayerCollider = PlayerCharacter;

        // Set Help Text
       // HelpText.text = "[" + HelpKey + "] Show/Hide help. [" + DoorKey + "] Open / close doors. [" + CameraSwitchKey + "] Switch camera. [" + DecoCheap + "] Decoration Quality";
       
        // Set DoorKeycode on TownManager
        Town.DoorKeyCode = DoorKey;

        // Save original sun rotation
        k = SunLight.gameObject.transform.eulerAngles.y;

        // Set cursor
        Cursor.SetCursor(myCursor, hotSopot, CursorMode.Auto);
        Cursor.visible = false;
        SunIntensity.value = SunLight.intensity;

        // Set volume level
        VolSlider.value = BackgroundMusic.volume;

        // Check camera mode active
        if (!TopDownMode)
        // Change from TopDown to FPS
        {
            Town.FPSMode = true;
            TopDownCamera.SetActive(false);
            FPSCamera.gameObject.SetActive(true);
            CameraGUI.text = "Handheld Camera (FPS)";
        }
        else
        // Change from FPS to TopDown
        {
            Town.FPSMode = false;
            TopDownCamera.SetActive(true);
            FPSCamera.gameObject.SetActive(false);
            CameraGUI.text = "Top Down Camera";
        }
    }

    // Update is called once per frame
    void Update () {
        // Check Settings
        if ((HelpText != null) && (HelpText.isActiveAndEnabled))
        {
            // Set Sun Light intensity
            if (SunLight != null)
            {
                // Set correct sun rotation
                Vector3 n = new Vector3(SunLight.gameObject.transform.eulerAngles.x, (k + SunRotation.value), SunLight.gameObject.transform.eulerAngles.z);

                SunLight.gameObject.transform.eulerAngles = n;
            }
            // Set Sun Light rotation
            if (SunLight != null)
            {
                SunLight.intensity = SunIntensity.value;
            }
            // Set volume
            if (BackgroundMusic != null)
            {
                BackgroundMusic.volume = VolSlider.value;
            }
        }

        // Enable/Unable Fxs
        if (Input.GetKeyUp(EnableFx))
        { 
            if (Fxs.activeInHierarchy)
                {
                    Fxs.SetActive(false);
                }
             else
                Fxs.SetActive(true);
        }

        // Show/Hide Help
        if (Input.GetKeyUp(HelpKey))
        {
            if (HelpText.isActiveAndEnabled)
            {
                // Restore game
                Time.timeScale = 1f;
                // Hide cursor
                Cursor.visible = false;
            //    LocationGUI.gameObject.SetActive(false);
            //    CameraGUI.gameObject.SetActive(false);
                HelpText.gameObject.SetActive(false);
                SunRotation.gameObject.SetActive(false);
                SunIntensity.gameObject.SetActive(false);
                VolSlider.gameObject.SetActive(false);
            }
            else
            {
                // Pause Game
                Time.timeScale = 0f;
                // Show cursor
              //  Cursor.SetCursor(myCursor, hotSopot, CursorMode.Auto);
                Cursor.lockState = CursorLockMode.None;
                Cursor.visible = true;
                //    LocationGUI.gameObject.SetActive(true);
                //    CameraGUI.gameObject.SetActive(true);
                HelpText.gameObject.SetActive(true);
                SunIntensity.gameObject.SetActive(true);
                SunRotation.gameObject.SetActive(true);
                VolSlider.gameObject.SetActive(true);
            }
        }
        // Show Player Location on gui
        LocationGUI.text = (Town.PlayerLocation + " [Floor " + Town.ActualFloor + "]");

        // Camera Switch key pressed
        if (Input.GetKeyUp(CameraSwitchKey) && (EnableCameraMode))
        {
            if (TopDownCamera.activeInHierarchy)
                // Change from TopDown to FPS
        {
            Town.FPSMode = true;
            TopDownCamera.SetActive(false);
            FPSCamera.gameObject.SetActive(true);
            CameraGUI.text = "Handheld Camera (FPS)";
        }
        else
                 // Change from FPS to TopDown
        {
            Town.FPSMode = false;
            TopDownCamera.SetActive(true);
            FPSCamera.gameObject.SetActive(false);
            CameraGUI.text = "Top Down Camera";
        }
    }
        // Change Decoration Quality on Town Manager with Hotkey

        if (Input.GetKeyUp(DecoCheap))
        {
            if (Town.CheapDecoration)
                Town.CheapDecoration = false;
            else
                Town.CheapDecoration = true;
        }

    }
}
