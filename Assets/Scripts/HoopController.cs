using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoopController : MonoBehaviour
{

    #region Variables
    [SerializeField]
    public List<GameObject> Hoops;
    [SerializeField]
    public Sprite GreenSprite;
    [SerializeField]
    public Sprite RedSprite;


    #endregion

    void Start()
    {
        if (Hoops != null && Hoops.Count > 0)
        {
            HoopSetColorGreen(Hoops[0]);
            for (int i = 1; i < Hoops.Count; i++)
            {
                HoopSetColorRed(Hoops[i]);
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Green"))
        {
            other.gameObject.GetComponentInChildren<ParticleSystem>().Play();
            HoopSetColorRed(other.gameObject);
            int index = Hoops.FindIndex(x => x.Equals(other.gameObject));
            if (Hoops.Count > index + 1)
            {
                HoopSetColorGreen(Hoops[++index]);
            }
        }
    }

    private void HoopSetColorRed(GameObject hoop)
    {
        hoop.tag = "Red";
        hoop.GetComponent<SpriteRenderer>().sprite = RedSprite;
    }

    private void HoopSetColorGreen(GameObject hoop)
    {
        hoop.tag = "Green";
        hoop.GetComponent<SpriteRenderer>().sprite = GreenSprite;
    }
}
