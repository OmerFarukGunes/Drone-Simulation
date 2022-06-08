using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_Rotator : SFX_ControlledObject
    {
        public Vector3 Rotation;
        private Vector3 _rotation;

        private void Update()
        {
            if (!IsRunning)
                return;

            _rotation += Rotation * Time.deltaTime;
            transform.rotation = Quaternion.Euler(_rotation);
        }
    }
}