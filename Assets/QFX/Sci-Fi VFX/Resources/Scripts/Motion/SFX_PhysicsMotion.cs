using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    [RequireComponent(typeof(SFX_ICollisionsProvider))]
    public class SFX_PhysicsMotion : SFX_ControlledObject
    {
        public float ColliderRadius = 0.1f;
        public float Speed;
        public float Mass;
        public float Drag;
        public bool UseGravity;
        public ForceMode ForceMode;
        public Transform Target;

        public bool DestroyAfterCollision;
        public float DestroyAfterCollisionTimeout;

        private SphereCollider _sphereCollider;
        private Rigidbody _rigidbody;

        public override void Run()
        {
            base.Run();

            var targetDirection =
                Target != null ? (Target.position - transform.position).normalized : transform.forward;

            _rigidbody.AddForce(targetDirection * Speed, ForceMode);
        }

        private void Awake()
        {
            _rigidbody = gameObject.GetComponent<Rigidbody>();
            _rigidbody.mass = Mass;
            _rigidbody.drag = Drag;
            _rigidbody.useGravity = UseGravity;

            _rigidbody.collisionDetectionMode = CollisionDetectionMode.ContinuousDynamic;
            _rigidbody.interpolation = RigidbodyInterpolation.Interpolate;

            _sphereCollider = gameObject.AddComponent<SphereCollider>();
            _sphereCollider.radius = ColliderRadius;

            var collisionsProvider = GetComponent<SFX_ICollisionsProvider>();
            collisionsProvider.OnCollision += delegate
            {
                if (DestroyAfterCollision)
                    Destroy(gameObject, DestroyAfterCollisionTimeout);
            };
        }
    }
}