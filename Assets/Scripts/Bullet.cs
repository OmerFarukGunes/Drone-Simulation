using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public float bulletForce = 4000.0f;
    private void Awake()
    {
        gameObject.GetComponent<Rigidbody>().AddRelativeForce(Vector3.forward * bulletForce);
    }
    private void FixedUpdate()
    {
        BulletLife();
    }

    public GameObject bulletHole;

    void BulletLife()
    {
        Ray ray = new Ray(transform.position, transform.forward);
        RaycastHit hit;
        if (Physics.Raycast(ray,out hit, 1000.0f))
            if (hit.distance <3)
            {
                Vector3 position = hit.point;
                Vector3 lookRotation = hit.normal;
                Instantiate(bulletHole, position, Quaternion.LookRotation(lookRotation));
            }
        Destroy(gameObject, 4.0f);
    }
}