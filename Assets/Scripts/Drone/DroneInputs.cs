using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;


namespace OmerFG
{
    [RequireComponent(typeof(PlayerInput))]
    public class DroneInputs : MonoBehaviour
    {
        #region Variables

        [SerializeField] GameObject lightObj;

        private Vector2 cyclic;
        private float pedals;
        private float throttle;
        private float shoot;
        private float light;

        public Vector2 Cyclic { get => cyclic; }
        public float Pedals { get => pedals; }
        public float Throttle { get => throttle; }
        public float Shoot { get => shoot; }
        public float Light { get => throttle; }

        DroneController droneController;

        #endregion
        private void Start() => droneController = FindObjectOfType<DroneController>();
        #region Input Methods
        void OnCyclic (InputValue value)
        {
            cyclic = value.Get<Vector2>();
        }
        void OnPedals (InputValue value) 
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
        private void OnLight(InputValue value)
        {
             lightObj.SetActive(!lightObj.active);
        }
        #endregion

    }
}


