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

        private Vector2 cyclic;
        private float pedals;
        private float throttle;

        public Vector2 Cyclic { get => cyclic; }
        public float Pedals { get => pedals; }
        public float Throttle { get => throttle; }

        #endregion

        #region Main Methods

        void Update()
        {

        }
        #endregion

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
            Debug.Log(value);
            throttle = value.Get<float>();
        }
        #endregion

    }
}


