using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Michsky.UI.Shift
{
    [ExecuteInEditMode]
    public class UIElementSound : MonoBehaviour, IPointerClickHandler, IPointerEnterHandler
    {
        [Header("Resources")]
        public AudioSource audioObject;

        [Header("Settings")]
        public bool enableHoverSound = true;
        public bool enableClickSound = true;
        public bool checkForInteraction = true;

        private Button sourceButton;

        void OnEnable()
        {

            if (Application.isPlaying == true && audioObject == null)
            {
                try { audioObject = GameObject.Find("UI Audio").GetComponent<AudioSource>(); }
                catch { Debug.Log("<b>[UI Element Sound]</b> No Audio Source found.", this); }
            }

            if (checkForInteraction == true) { sourceButton = gameObject.GetComponent<Button>(); }
        }

        public void OnPointerEnter(PointerEventData eventData)
        {
            if (checkForInteraction == true && sourceButton != null && sourceButton.interactable == false)
                return;

        }

        public void OnPointerClick(PointerEventData eventData)
        {
            if (checkForInteraction == true && sourceButton != null && sourceButton.interactable == false)
                return;

        }
    }
}