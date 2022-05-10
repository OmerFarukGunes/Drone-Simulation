using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
namespace OmerFG
{
    [RequireComponent(typeof(DroneInputs))]
    public class DroneController : BaseRigidbody
    {

        #region Variables

        [Header("Control Properties")]
        [SerializeField] private float minMaxPitch = 30f;
        [SerializeField] private float minMaxRoll = 30f;
        [SerializeField] private float yawPower = 4f;

        private DroneInputs input;
        private List<IEngine> engines = new List<IEngine>();

        #endregion

        #region Main Methods

        void Start()
        {
            input = GetComponent<DroneInputs>();
            engines = GetComponentsInChildren<DroneEngine>().ToList<IEngine>();
        }

        #endregion

        #region Custom Methods

        protected override void HandlePhysics()
        {
            HandleEngines();
            HandleControls();
        }

        protected virtual void HandleEngines() 
        {
            //rb.AddForce(Vector3.up * (rb.mass * Physics.gravity.magnitude));
            foreach (IEngine engine in engines)
            {
                engine.UpdateEngine(rb, input);
            }
        }
        protected virtual void HandleControls()
        {
        
        }

        #endregion

    }
}

