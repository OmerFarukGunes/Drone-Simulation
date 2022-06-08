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
    [SerializeField]
    public Sprite YellowSprite;


    #endregion

    void Start()
    {
        if (Hoops != null && Hoops.Count > 0)
        {
            HoopSetColorGreen(Hoops[0]);
            if (Hoops.Count > 1)
                HoopSetColorYellow(Hoops[1]);
            for (int i = 2; i < Hoops.Count; i++)
                HoopSetColorRed(Hoops[i]);
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
                if (Hoops.Count > index + 1)
                    HoopSetColorYellow(Hoops[++index]);
            }
            other.gameObject.SetActive(false);
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

    private void HoopSetColorYellow(GameObject hoop)
    {
        hoop.tag = "Yellow";
        hoop.GetComponent<SpriteRenderer>().sprite = YellowSprite;
    }
}
