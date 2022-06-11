using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using DG.Tweening;
using UnityEngine.UI;
using TMPro;

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
        [SerializeField] GameObject shootEffect;

        [Header("Health")]
        [SerializeField] Image healthBar;
        [SerializeField] TextMeshProUGUI healthBarText;
        int health = 100;

        [Header("Parts")]
        [SerializeField] List<GameObject> bodies;
        [SerializeField] List<GameObject> cameras;
        [SerializeField] List<GameObject> shoots;
        int i = 0;
        int j = 0;
        int k = 0;


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

        private void Update()
        {
            if (Input.GetKeyDown("1"))
            {
                bodies[i].SetActive(false);
                i = i + 1 > 2 ? 0 : i + 1;
                SetMass();
                bodies[i].SetActive(true);
            }
            else if (Input.GetKeyDown("2"))
            {
                cameras[j].SetActive(false);
              
                j = j + 1 > 2 ? 0 : j + 1;
                SetMass();
                cameras[j].SetActive(true);
            }
            else if (Input.GetKeyDown("3"))
            {
                shoots[k].SetActive(false);
               
                k = k + 1 > 2 ? 0 : k + 1;
                SetMass();
                shoots[k].SetActive(true);
            }
        }
        void SetMass() => weightInLbs = 5 + i + j + k;

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
            health -= (int) rb.velocity.magnitude ;
            if (health / 100f > 0)
            {
                rb.AddForce(-pos * .4f, ForceMode.Impulse);
                hitEffect.transform.rotation = rot;
                hitEffect.Play();
                healthBar.fillAmount = health / 100f;
                healthBarText.text = health + "%";
            }
            else
            {
                
            }
           
        }
        void DroneSound()
        {
            audioSource.pitch = .9f + (rb.velocity.magnitude / 50);     
            audioSource.volume = .5f + (rb.velocity.magnitude / 50);     
        }

        public void ShootingBullets() 
        {
            if (input.Shoot > 0)
            {
                if (waitTilNextFire <= 0)
                {
                    Instantiate(bulletPrefab, gunTransform.position, transform.rotation);
                    waitTilNextFire = 1;
                    if (!shootEffect.active)
                        shootEffect.SetActive(true);
                }
                waitTilNextFire -= fireRate * Time.deltaTime;
            }
            else
                shootEffect.SetActive(false);
        }
        #endregion

    }
}

