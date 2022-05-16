using OmerFG;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Camera : MonoBehaviour
{
    public enum HorizontalFollow
    {
        None,
        Instant,
        Gradually
    }

    [Header("Follow Settings")]
    /*[HideInInspector]*/
    public bool follow;

    [Header("Follow Method Variables")]
    [SerializeField] Rigidbody target;
    [SerializeField] float speed = 3f;

    [Header("Horizonral Follow")]
    public HorizontalFollow horizontalFollowType;
    public float horizontalFollowLerpMult;
    public float horizontalClampVal;


    private Vector3 newPos = Vector3.zero;
    private Vector3 vel = Vector3.zero;
    float temporaryXVal;

    [HideInInspector] public Vector3 offset;


    [Header("Camera")]
    Camera cam;

    void Awake()
    {
        follow = true;
        OffsetCalculate();
        cam = GetComponent<Camera>();
        newPos.x = transform.position.x;
    }

    void LateUpdate()
    {
        if (follow)
        {
            FollowMethod();
        }
    }

    void FollowMethod()
    {
        if (target)//for safety
        {
            NewPosCalculator();
            transform.position = Vector3.SmoothDamp(transform.position, newPos, ref vel, speed);
        }
    }

    Vector3 NewPosCalculator()
    {
        NewPosX();
        newPos.y = target.position.y + offset.y;
        newPos.z = target.position.z + offset.z;
        return newPos;
    }

    float NewPosX()
    {
        switch (horizontalFollowType)
        {
            case HorizontalFollow.None:
                return newPos.x;

            case HorizontalFollow.Instant:
                newPos.x = target.position.x + offset.x;
                return newPos.x;

            case HorizontalFollow.Gradually:
                newPos.x = target.position.x + offset.x;
                newPos.x = Mathf.Clamp(newPos.x, -horizontalClampVal, horizontalClampVal);
                temporaryXVal = Mathf.Lerp(transform.position.x, newPos.x, horizontalFollowLerpMult * Time.deltaTime);
                newPos.x = temporaryXVal;
                return newPos.x;
        }
        Debug.Log(true);
        return newPos.x;
    }

    public Vector3 OffsetCalculate()
    {
        offset = transform.position - target.position;
        newPos.y = target.position.y + offset.y;
        //Debug.Log("OFFSET :::: " + newPos);
        return offset;
    }

    public void CameraShake()
    {
        //cam.DOShakePosition(.1f, .2f).SetId(1);
        cam.transform.DOShakeRotation(.1f, 3.5f, 100).SetEase(Ease.Linear).SetId(2);
    }

    public void ReTarget(Transform desiredObj)
    {
        target = desiredObj.GetComponent<Rigidbody>();
        OffsetCalculate();
    }
}
