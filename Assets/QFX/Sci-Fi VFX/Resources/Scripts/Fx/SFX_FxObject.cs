using System;
using UnityEngine;
using UnityEngine.Serialization;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    [Serializable]
    public class SFX_FxObject : ICloneable
    {
        public GameObject Fx;
        public SFX_FxRotationType FxRotation = SFX_FxRotationType.Normal;

        public virtual object Clone()
        {
            return new SFX_FxObject
            {
                Fx = Fx,
                FxRotation = FxRotation
            };
        }
    }
}