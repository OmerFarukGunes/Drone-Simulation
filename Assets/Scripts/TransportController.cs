using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransportController : MonoBehaviour
{
    private GameObject transferringObject;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("StartTransportTrigger"))
        {
            Destroy(other.gameObject.transform.parent.gameObject.GetComponent<Rigidbody>());

            other.gameObject.transform.parent.SetParent(transform, true);
            transferringObject = other.gameObject.transform.parent.gameObject;
        }
        else if (other.CompareTag("EndTransportTrigger"))
        {
            if (transferringObject != null && transferringObject.transform.IsChildOf(transform))
            {
                transferringObject.transform.parent = null;
                transferringObject.AddComponent<Rigidbody>();
            }
        }
    }
}
