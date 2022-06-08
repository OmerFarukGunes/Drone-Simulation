using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_GroundAttacher : SFX_ControlledObject
    {
        public LayerMask LayerMask;
        public float MaxDistance = 100;

        public bool OverrideRotation;

        public Vector3 Offset;

        private bool _isAttached;

        private Transform _transform;

        private void Awake()
        {
            _transform = transform;
        }

        private void Update()
        {
            if (!IsRunning || _isAttached)
                return;

            _isAttached = true;

            RaycastHit raycastHit;
            var hitPos = _transform.position.y;

            if (Physics.Raycast(_transform.position, Vector3.down, out raycastHit, MaxDistance, LayerMask))
                hitPos = Mathf.Min(hitPos, raycastHit.point.y);

            if (!(Mathf.Abs(_transform.position.y - hitPos) > 0.01f))
                return;

            transform.position = new Vector3(_transform.position.x, hitPos + Offset.y, _transform.position.z);

            if (OverrideRotation)
                transform.rotation = Quaternion.LookRotation(Vector3.forward);

            Stop();
        }
    }
}