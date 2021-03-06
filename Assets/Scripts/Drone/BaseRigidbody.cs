using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class BaseRigidbody : MonoBehaviour
{
    #region Variables

    [Header("Rigidbody Properties")]
    [SerializeField] public float weightInLbs = 1f;

    const float lbsToKg = 0.454f;

    protected Rigidbody rb;
    protected float startDrag;
    protected float startAngularDrag;
    #endregion

    #region Main Methods
    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
        if (rb)
        {
            rb.mass = weightInLbs * lbsToKg;
            startDrag = rb.drag;
            startAngularDrag = rb.angularDrag;
        }
    }
    private void FixedUpdate()
    {
        if (!rb)
            return;

        HandlePhysics();
    }
    #endregion

    #region Custom Methods

    protected virtual void HandlePhysics() { }

    #endregion
}

