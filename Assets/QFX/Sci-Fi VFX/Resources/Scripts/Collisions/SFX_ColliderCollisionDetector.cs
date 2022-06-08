using System;
using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_ColliderCollisionDetector : SFX_ControlledObject, SFX_ICollisionsProvider
    {
        public bool IsSingleCollisionMode = true;

        private bool _wasCollided;

        public event Action<SFX_CollisionPoint> OnCollision;

        private void OnCollisionEnter(Collision collision)
        {
            if (!IsRunning)
                return;

            if (_wasCollided && IsSingleCollisionMode)
                return;

            foreach (var contact in collision.contacts)
            {
                if (!_wasCollided)
                    _wasCollided = true;

                if (OnCollision != null)
                    OnCollision.Invoke(new SFX_CollisionPoint
                    {
                        Point = contact.point,
                        Normal = contact.normal
                    });
            }
        }
    }
}