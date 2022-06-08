using System;
using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public interface SFX_ICollisionsProvider
    {
        event Action<SFX_CollisionPoint> OnCollision;
    }
}