using UnityEngine;

namespace Michsky.UI.Shift
{
    public class SplashScreenManager : MonoBehaviour
    {
        [Header("Resources")]
        public GameObject mainPanels;

        private Animator mainPanelsAnimator;

        MainPanelManager mpm;

        void OnEnable()
        {
            if (mainPanelsAnimator == null) { mainPanelsAnimator = mainPanels.GetComponent<Animator>(); }
            if (mpm == null) { mpm = gameObject.GetComponent<MainPanelManager>(); }

                mainPanels.SetActive(true);

                mainPanelsAnimator.Play("Start");
                mpm.OpenFirstTab();

        }

    }
}