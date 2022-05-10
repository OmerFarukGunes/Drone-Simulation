using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace OmerFG
{
    [RequireComponent(typeof(BoxCollider))]
    public class DroneEngine : MonoBehaviour, IEngine
    {

        #region Variables

        [Header("Engine Properties")]
        [SerializeField] private float maxPower = 4f;

        #endregion
        #region Interface Methods

        public void InitEngine()
        {
            throw new System.NotImplementedException();
        }

        public void UpdateEngine(Rigidbody rb, DroneInputs input)
        {
            Vector3 engineForce = Vector3.zero;
            engineForce = transform.up * ((rb.mass * Physics.gravity.magnitude) + (input.Throttle * maxPower)) / 4f;
            Debug.Log(engineForce);
            rb.AddForce(engineForce, ForceMode.Force);
        }


        #endregion
    }
}

