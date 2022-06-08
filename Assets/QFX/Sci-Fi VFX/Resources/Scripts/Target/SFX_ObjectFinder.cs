using System;
using System.Collections.Generic;
using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    [Serializable]
    public class SFX_ObjectFinder
    {
        public float Radius;
        public LayerMask LayerMask;
        public string Tag;

        public List<Collider> FindObjects(Vector3 position)
        {
            var objectsInArea = SFX_ObjectAreaFinder.FindObjects(position, Radius, LayerMask, Tag);
            return objectsInArea;
        }
    }
}
