using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_ProjectileLauncher : SFX_ControlledObject
    {
        public GameObject Projectile;

        public override void Run()
        {
            base.Run();

            var projectile = Instantiate(Projectile, transform.position, transform.rotation)
                .GetComponent<SFX_ControlledObject>();

            var emitterKeeper = projectile.GetComponent<SFX_IEmitterKeeper>();
            if (emitterKeeper != null)
                emitterKeeper.EmitterTransform = transform;

            projectile.Run();
        }
    }
}