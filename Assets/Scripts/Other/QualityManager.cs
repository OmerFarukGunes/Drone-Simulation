using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.Events;
using TMPro;

namespace Michsky.UI.Shift
{
    public class QualityManager : MonoBehaviour
    {

        [Header("Resolution")]
        public bool preferSelector = true;
        public HorizontalSelector resolutionSelector;
        public TMP_Dropdown resolutionDropdown;
        [System.Serializable]
        public class DynamicRes : UnityEvent<int> { }
        public DynamicRes clickEvent;

        Resolution[] resolutions;
        List<string> options = new List<string>();

        void Start()
        {
            resolutions = Screen.resolutions;

            if (preferSelector == true)
            {
                if (resolutionDropdown != null)
                    resolutionDropdown.gameObject.SetActive(false);

                if (resolutionSelector != null)
                    resolutionSelector.gameObject.SetActive(true);
                else
                    return;

                resolutionSelector.itemList.RemoveRange(0, resolutionSelector.itemList.Count);

                int currentResolutionIndex = 0;
                for (int i = 0; i < resolutions.Length; i++)
                {
                    string option = resolutions[i].width + "x" + resolutions[i].height + " " + resolutions[i].refreshRate + "hz";
                    options.Add(option);

                    if (resolutions[i].width == Screen.currentResolution.width && resolutions[i].height == Screen.currentResolution.height)
                    {
                        currentResolutionIndex = i;
                        resolutionSelector.index = currentResolutionIndex;
                    }

                    resolutionSelector.CreateNewItem(options[i]);
                }

                resolutionSelector.UpdateUI();
            }

            else
            {
                if (resolutionSelector != null)
                    resolutionSelector.gameObject.SetActive(false);

                if (resolutionDropdown != null)
                    resolutionDropdown.gameObject.SetActive(true);
                else
                    return;

                resolutionDropdown.ClearOptions();

                List<string> options = new List<string>();

                int currentResolutionIndex = 0;
                for (int i = 0; i < resolutions.Length; i++)
                {
                    string option = resolutions[i].width + "x" + resolutions[i].height + " " + resolutions[i].refreshRate + "hz";
                    options.Add(option);

                    if (resolutions[i].width == Screen.currentResolution.width
                        && resolutions[i].height == Screen.currentResolution.height)
                        currentResolutionIndex = i;
                }

                resolutionDropdown.AddOptions(options);
                resolutionDropdown.value = currentResolutionIndex;
                resolutionDropdown.RefreshShownValue();
            }
        }

        public void UpdateResolution() =>  clickEvent.Invoke(resolutionSelector.index);

        public void SetResolution(int resolutionIndex) => Screen.SetResolution(resolutions[resolutionIndex].width, resolutions[resolutionIndex].height, Screen.fullScreen);

        public void AnisotrpicFilteringEnable() =>  QualitySettings.anisotropicFiltering = AnisotropicFiltering.ForceEnable;

        public void AnisotrpicFilteringDisable() => QualitySettings.anisotropicFiltering = AnisotropicFiltering.Disable;

        public void AntiAlisasingSet(int index) => QualitySettings.antiAliasing = index;

        public void VsyncSet(int index) => QualitySettings.vSyncCount = index;

        public void ShadowResolutionSet(int index)
        {
            if (index == 3)
                QualitySettings.shadowResolution = ShadowResolution.VeryHigh;
            else if (index == 2)
                QualitySettings.shadowResolution = ShadowResolution.High;
            else if (index == 1)
                QualitySettings.shadowResolution = ShadowResolution.Medium;
            else if (index == 0)
                QualitySettings.shadowResolution = ShadowResolution.Low;
        }

        public void ShadowsSet(int index)
        {
            if (index == 0)
                QualitySettings.shadows = ShadowQuality.Disable;
            else if (index == 1)
                QualitySettings.shadows = ShadowQuality.All;
        }

        public void ShadowsCascasedSet(int index) => QualitySettings.shadowCascades = index;

        public void TextureSet(int index) =>  QualitySettings.masterTextureLimit = index;

        public void SoftParticleSet(int index)
        {
            if (index == 0)
                QualitySettings.softParticles = false;
            else if (index == 1)
                QualitySettings.softParticles = true;
        }

        public void ReflectionSet(int index)
        {
            if (index == 0)
                QualitySettings.realtimeReflectionProbes = false;
            else if (index == 1)
                QualitySettings.realtimeReflectionProbes = true;
        }

        public void SetOverallQuality(int qualityIndex) => QualitySettings.SetQualityLevel(qualityIndex);

        public void WindowFullscreen()
        {
            Screen.fullScreen = true;
            Screen.fullScreenMode = FullScreenMode.FullScreenWindow;
        }

        public void WindowBorderless() => Screen.fullScreenMode = FullScreenMode.MaximizedWindow;

        public void WindowWindowed()
        {
            Screen.fullScreen = false;
            Screen.fullScreenMode = FullScreenMode.Windowed;
        }
    }
}