using System;
using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    [Serializable]
    public class SFX_TargetAttacher
    {
        private Transform _transform;

        public Transform Target { get; private set; }

        private bool _isAttached;

        public void Attach(Transform anchor, Transform selfTransform)
        {
            _transform = selfTransform;
            Target = anchor;
            _isAttached = true;
        }

        public void FindAndAttach(string anchorName, Transform parent, Transform selfTransform)
        {
            var anchor = FindChildByRecursion(parent, anchorName);
            if (anchor == null)
            {
                Debug.LogWarning("Anchor not found");
                return;
            }

            Target = anchor;
            _transform = selfTransform;

            _isAttached = true;
        }

        public void DeAttach()
        {
            _isAttached = false;
            _transform = null;
        }

        public void Update()
        {
            if (!_isAttached)
                return;

            _transform.position = Target.position;
            _transform.rotation = Target.rotation;
        }

        private static Transform FindChildByRecursion(Transform aParent, string aName)
        {
            if (aParent == null)
                return null;

            var result = aParent.Find(aName);

            if (result != null)
                return result;

            foreach (Transform child in aParent)
            {
                result = FindChildByRecursion(child, aName);
                if (result != null)
                    return result;
            }

            return null;
        }
    }
}