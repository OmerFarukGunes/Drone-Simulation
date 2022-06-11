using UnityEngine;

namespace Michsky.UI.Shift
{
    public class SplashScreenManager : MonoBehaviour
    {
        [Header("Resources")]
        public GameObject splashScreen;
        public GameObject mainPanels;

        private Animator splashScreenAnimator;
        private Animator mainPanelsAnimator;
        private TimedEvent ssTimedEvent;

        [Header("Settings")]
        public bool disableSplashScreen;
        public bool enablePressAnyKeyScreen;
        public bool enableLoginScreen;

        MainPanelManager mpm;

        void OnEnable()
        {
            if (splashScreenAnimator == null) { splashScreenAnimator = splashScreen.GetComponent<Animator>(); }
            if (ssTimedEvent == null) { ssTimedEvent = splashScreen.GetComponent<TimedEvent>(); }
            if (mainPanelsAnimator == null) { mainPanelsAnimator = mainPanels.GetComponent<Animator>(); }
            if (mpm == null) { mpm = gameObject.GetComponent<MainPanelManager>(); }

            if (disableSplashScreen == true)
            {
                splashScreen.SetActive(false);
                mainPanels.SetActive(true);

                mainPanelsAnimator.Play("Start");
                mpm.OpenFirstTab();
            }

                splashScreen.SetActive(true);
                mainPanelsAnimator.Play("Invisible");
        }

    }
}