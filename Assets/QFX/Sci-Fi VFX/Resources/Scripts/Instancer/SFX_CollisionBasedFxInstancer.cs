using System;
using UnityEngine;
using UnityEngine.Serialization;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    [RequireComponent(typeof(SFX_ICollisionsProvider))]
    public class SFX_CollisionBasedFxInstancer : SFX_ControlledObject
    {
        public SFX_FxObject[] FxObjects;

        private bool _wasCollided;

        private void Awake()
        {
            var collisionProviders = GetComponents<SFX_ICollisionsProvider>();
            foreach (var collisionsProvider in collisionProviders)
            {
                collisionsProvider.OnCollision += delegate(SFX_CollisionPoint collisionPoint)
                {
                    if (_wasCollided)
                        return;

                    var targetRotation = Vector3.zero;

                    foreach (var fxObject in FxObjects)
                    {
                        switch (fxObject.FxRotation)
                        {
                            case SFX_FxRotationType.Default:
                                break;
                            case SFX_FxRotationType.Normal:
                                targetRotation = collisionPoint.Normal;
                                break;
                            case SFX_FxRotationType.LookAtEmitter:
                                targetRotation = GetComponent<SFX_IEmitterKeeper>().EmitterTransform.position;
                                break;
                            default:
                                throw new ArgumentOutOfRangeException();
                        }

                        SFX_FxObjectInstancer.InstantiateFx(fxObject, collisionPoint.Point, targetRotation);
                    }

                    _wasCollided = true;
                };
            }
        }
    }
}