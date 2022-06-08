using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public static class SFX_FxObjectInstancer
    {
        public static void InstantiateFx(SFX_FxObject sfxFxObject, Vector3 targetPosition, Vector3 targetRotation)
        {
            var go = Object.Instantiate(sfxFxObject.Fx);
            go.transform.position = targetPosition;

            if (sfxFxObject.FxRotation == SFX_FxRotationType.Normal)
            {
                go.transform.rotation = Quaternion.FromToRotation(go.transform.up, targetRotation) *
                                        go.transform.rotation;
            }
            else if (sfxFxObject.FxRotation == SFX_FxRotationType.Default)
            {
                go.transform.rotation = Quaternion.identity;
            }
            else if (sfxFxObject.FxRotation == SFX_FxRotationType.LookAtEmitter)
            {
                go.transform.LookAt(targetRotation);
            }

            go.SetActive(true);
        }
    }
}