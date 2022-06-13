using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;


[RequireComponent(typeof(PlayerInput))]
public class DroneInputs : MonoBehaviour
{
    #region Variables

    [SerializeField] GameObject lightObj;

    private Vector2 cyclic;
    private float pedals;
    private float throttle;
    private float shoot;
    private float lightInput;

    public Vector2 Cyclic { get => cyclic; }
    public float Pedals { get => pedals; }
    public float Throttle { get => throttle; }
    public float Shoot { get => shoot; }
    public float LightInput { get => lightInput; }
    

    #endregion

    #region Input Methods
    void OnCyclic(InputValue value)
    {
        cyclic = value.Get<Vector2>();
    }
    void OnPedals(InputValue value)
    {
        pedals = value.Get<float>();
    }
    private void OnThrottle(InputValue value)
    {
        throttle = value.Get<float>();
    }
    private void OnShoot(InputValue value)
    {
        shoot = value.Get<float>();
    }
    private void OnLightInput(InputValue value)
    {
        lightInput = value.Get<float>();
        if (lightInput > 0)
            lightObj.SetActive(!lightObj.active);
        
    }
    #endregion

}


