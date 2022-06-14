using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using DG.Tweening;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;
using Cinemachine;

[RequireComponent(typeof(DroneInputs))]
public class DroneController : BaseRigidbody
{
   
    #region Variables

    [SerializeField] AudioSource audioSource;
    [SerializeField] AudioSource audioSourceShoot;

    [Header("Control Properties")]
    [SerializeField] private float minMaxPitch = 30f;
    [SerializeField] private float minMaxRoll = 30f;
    [SerializeField] private float yawPower = 4f;
    [SerializeField] private float lerpSpeed = 2f;

    [Header("Effects")]
    [SerializeField] ParticleSystem hitEffect;
    [SerializeField] GameObject shootEffect;
    [SerializeField] GameObject healEffect;
    [SerializeField] GameObject deathEffect;

    [Header("Health")]
    [SerializeField] Image healthBar;
    [SerializeField] TextMeshProUGUI healthBarText;
    int health = 100;

    [Header("Parts")]
    [SerializeField] List<GameObject> bodies;
    [SerializeField] List<GameObject> cameras;
    [SerializeField] List<GameObject> shoots;
    [SerializeField] CinemachineVirtualCamera cam;


    [Header("Specs")]
    [SerializeField] TextMeshProUGUI enginePower;
    [SerializeField] TextMeshProUGUI mass;
    [SerializeField] TextMeshProUGUI damage;
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
        rb.AddForce(Vector3.up * 20, ForceMode.Force);
        audioSource.Play();
    }

    #endregion

    private void Update()
    {
        if (Input.GetKeyDown("1"))
        {
            bodies[i].SetActive(false);
            i = i + 1 > 2 ? 0 : i + 1;
            yawPower = 2 + i;
            enginePower.text = "Engine Power: " + (yawPower * 10);
            PlayerPrefs.SetInt("Engine Power",2 + i);

            SetMass();
            bodies[i].SetActive(true);
        }
        else if (Input.GetKeyDown("2"))
        {
            cameras[j].SetActive(false);
            j = j + 1 > 2 ? 0 : j + 1;
            cam.m_Lens.FieldOfView = 60 + j;
            SetMass();
          
            cameras[j].SetActive(true);
        }
        else if (Input.GetKeyDown("3"))
        {
            shoots[k].SetActive(false);
           
            k = k + 1 > 2 ? 0 : k + 1;
            PlayerPrefs.SetInt("Damage", (k * 5) +1);
            damage.text = "Damage: " + (k * 5) + 1;
            SetMass();
            shoots[k].SetActive(true);
        }
    }
    void SetMass()
    {
        weightInLbs = 5 + i + j + k;
        mass.text = "Mass: " + weightInLbs;
    }

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
    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Heal"))
        {
            healEffect.SetActive(false);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Heal"))
        {
            healEffect.SetActive(true);
            SetHealth();
        }
    }
    private void OnCollisionEnter(Collision collision)
    {

        ContactPoint contact = collision.contacts[0];
        Quaternion rot = Quaternion.FromToRotation(Vector3.up, contact.normal);
        Vector3 pos = contact.point;
        health -= (int)rb.velocity.magnitude * 2;
        if (health / 100f > 0)
        {
            rb.AddForce(-pos * .3f, ForceMode.Impulse);
            hitEffect.transform.rotation = rot;
            hitEffect.Play();
            healthBar.fillAmount = health / 100f;
            healthBarText.text = health + "%";
        }
        else
            StartCoroutine(Explosion());

    }
    void SetHealth()
    {
        if (health<100)
        {
            health += 1;
            healthBar.fillAmount = health / 100f;
            healthBarText.text = health + "%";
        }
       
    }
    IEnumerator Explosion()
    {
        deathEffect.SetActive(true);
        yield return new WaitForSeconds(1);
        SceneManager.LoadScene(0);
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
                audioSourceShoot.Play();
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

