using System;
using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_DistanceCollisionDetector : SFX_ControlledObject, SFX_ICollisionsProvider
    {
        public bool IsSingleCollisionMode = true;
        public float CollisionDistance;

        public Vector3 TargetPosition;
        public DistanceComparisonMode DistanceMode;

        private bool _wasCollided;
        private Transform _transform;

        public event Action<SFX_CollisionPoint> OnCollision;

        private void Start()
        {
            _transform = transform;
        }

        private void LateUpdate()
        {
            if (!IsRunning)
                return;

            if (IsSingleCollisionMode && _wasCollided)
                return;

            bool wasCollided = false;
            Vector3 point = Vector3.zero;
            Vector3 normal = Vector3.zero;

            switch (DistanceMode)
            {
                case DistanceComparisonMode.Target:
                    var distance = Vector3.Distance(_transform.position, TargetPosition);
                    if (distance <= CollisionDistance)
                    {
                        wasCollided = true;
                        point = TargetPosition;
                    }

                    break;
                case DistanceComparisonMode.Raycast:
                    RaycastHit hit;
                    if (Physics.Raycast(_transform.position, _transform.forward, out hit, CollisionDistance))
                    {
                        wasCollided = true;
                        point = hit.point;
                        normal = hit.normal;
                    }

                    break;
            }

            if (!wasCollided)
                return;

            if (!_wasCollided)
                _wasCollided = true;

            if (OnCollision != null)
                OnCollision.Invoke(new SFX_CollisionPoint
                {
                    Point = point,
                    Normal = normal
                });
        }

        public enum DistanceComparisonMode
        {
            Target,
            Raycast
        }
    }
}