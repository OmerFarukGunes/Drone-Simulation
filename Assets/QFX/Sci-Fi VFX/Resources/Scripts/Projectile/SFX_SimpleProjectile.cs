using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    [RequireComponent(typeof(SFX_ICollisionsProvider))]
    public class SFX_SimpleProjectile : SFX_ControlledObject, SFX_IEmitterKeeper
    {
        public float Speed = 1;

        public bool DestroyAfterCollision;
        public float DestroyAfterCollisionTimeout;

        private Transform _transform;

        private bool _wasCollided;

        public Transform EmitterTransform { get; set; }

        private void Awake()
        {
            var collisionsProvider = GetComponent<SFX_ICollisionsProvider>();
            collisionsProvider.OnCollision += delegate(SFX_CollisionPoint collisionPoint)
            {
                _wasCollided = true;

                if (DestroyAfterCollision)
                    Destroy(gameObject, DestroyAfterCollisionTimeout);

                _transform.position = collisionPoint.Point;
            };

            _transform = transform;
        }

        private void Update()
        {
            if (_wasCollided || !IsRunning)
                return;

            _transform.position += _transform.forward * Speed * Time.deltaTime;

//            if (EmitterSource != null)
//                impactEffect.transform.LookAt(EmitterSource);
//            else
//                impactEffect.transform.LookAt(_transform.position + hit.normal);
        }
    }
}