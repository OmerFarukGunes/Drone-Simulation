using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Truck : MonoBehaviour
{
    [SerializeField] List<GameObject> effects;
    [SerializeField] GameObject truck;
    [SerializeField] GameObject crashedTruck;
    private int health = 100;

    private void OnTriggerEnter(Collider coll)
    {
        if (coll.CompareTag("Bullet") && health >0)
        {
            health -= 5;
            effects[health / 25].SetActive(true);
            if (health <=0)
            {
                truck.SetActive(false);
                crashedTruck.SetActive(true);
            }
        }
    }
}
