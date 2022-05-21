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

        [SerializeField] AudioSource audioSource;

        [Header("Control Properties")]
        [SerializeField] private float minMaxPitch = 30f;
        [SerializeField] private float minMaxRoll = 30f;
        [SerializeField] private float yawPower = 4f;
        [SerializeField] private float lerpSpeed = 2f;

        public DroneInputs input;
        private List<IEngine> engines = new List<IEngine>();
        private float finalPitch;
        private float finalRoll;
        private float finalYaw;
        public float yaw;
        #endregion

        #region Main Methods

        void Start()
        {
            input = GetComponent<DroneInputs>();
            engines = GetComponentsInChildren<DroneEngine>().ToList<IEngine>();
            rb.AddForce(Vector3.up*20, ForceMode.Force);
        }

        #endregion

        #region Custom Methods

        protected override void HandlePhysics()
        {
            HandleEngines();
            HandleControls();
        }

        protected virtual void HandleEngines() 
        {            //rb.AddForce(Vector3.up * (rb.mass * Physics.gravity.magnitude));
            foreach (IEngine engine in engines)
            {
                engine.UpdateEngine(rb, input);
                DroneSound();
            }
        }
        protected virtual void HandleControls()
        {
            float pitch = input.Cyclic.y * minMaxPitch;
            float roll = -input.Cyclic.x * minMaxRoll;
            yaw += input.Pedals * yawPower;

            finalPitch = Mathf.Lerp(finalPitch, pitch, Time.deltaTime * lerpSpeed);
            finalRoll = Mathf.Lerp(finalRoll, roll, Time.deltaTime * lerpSpeed);
            finalYaw = Mathf.Lerp(finalYaw, yaw, Time.deltaTime * lerpSpeed);

            Quaternion rot = Quaternion.Euler(finalPitch, finalYaw, finalRoll);
            rb.MoveRotation(rot);


        }
        void DroneSound()
        {
            audioSource.pitch = .9f + (rb.velocity.magnitude / 50);     
            audioSource.volume = .5f + (rb.velocity.magnitude / 50);     
        }
        #endregion

    }
}
