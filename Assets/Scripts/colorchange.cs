using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class colorchange : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        GetComponent<MeshRenderer>().material.DOColor(Color.red, 1).SetEase(Ease.InElastic);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
