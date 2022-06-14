using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class Truck : MonoBehaviour
{
    [SerializeField] List<GameObject> effects;
    [SerializeField] GameObject truck;
    [SerializeField] GameObject crashedTruck;
    [SerializeField] TextMeshProUGUI missionTask;
    private int health = 100;
    

    void Start() => missionTask = GameObject.FindGameObjectWithTag("TruckMission").GetComponent<TextMeshProUGUI>();

    private void OnTriggerEnter(Collider coll)
    {
        if (coll.CompareTag("Bullet") && health >0)
        {
            health -= PlayerPrefs.GetInt("Damage",5);
            effects[health / 25].SetActive(true);
            if (health <=0)
            {
                PlayerPrefs.SetInt("DestroyedTrucks", PlayerPrefs.GetInt("DestroyedTruck", 0) + 1);
                missionTask.text = "Destroy Red Trucks: " + PlayerPrefs.GetInt("DestroyedTrucks",1) + "/3";
                truck.SetActive(false);
                crashedTruck.SetActive(true);
            }
        }
    }
}
