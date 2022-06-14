using UnityEngine;
using UnityEngine.UI;
using TMPro;

namespace Michsky.UI.Shift
{
    public class QuickMatchButton : MonoBehaviour
    {

        public Sprite backgroundImage;

        Image image1;

        void Start()
        {
                image1 = gameObject.transform.Find("Content/Background").GetComponent<Image>();
                image1.sprite = backgroundImage;
        }
    }
}