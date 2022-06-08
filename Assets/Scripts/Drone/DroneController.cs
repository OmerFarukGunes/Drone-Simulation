using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using DG.Tweening;
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

        [Header("Effects")]
        [SerializeField] ParticleSystem hitEffect;

        public DroneInputs input;
        private List<IEngine> engines = new List<IEngine>();
        private float finalPitch;
        private float finalRoll;
        private float finalYaw;
        public float yaw;


        [Header("Soohter")]
        public Transform gunTransform;
        public GameObject bulletPrefab;
        public float fireRate = 6;
        private float waitTilNextFire = 0.0f;

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
            ShootingBullets();
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
        private void OnCollisionEnter(Collision collision)
        {

            ContactPoint contact = collision.contacts[0];
            Quaternion rot = Quaternion.FromToRotation(Vector3.up, contact.normal);
            Vector3 pos = contact.point;
            rb.AddForce(-pos * 2, ForceMode.Impulse);
            hitEffect.transform.rotation = rot;
            hitEffect.Play();
        }
        void DroneSound()
        {
            audioSource.pitch = .9f + (rb.velocity.magnitude / 50);     
            audioSource.volume = .5f + (rb.velocity.magnitude / 50);     
        }

        public void ShootingBullets() 
        {
            if (input.Shoot>0)
            {
                if (waitTilNextFire <= 0)
                {
                    Instantiate(bulletPrefab, gunTransform.position, transform.rotation);
                    waitTilNextFire = 1;
                }
                waitTilNextFire -= fireRate * Time.deltaTime;
            }
          
        }
        #endregion

    }
}

