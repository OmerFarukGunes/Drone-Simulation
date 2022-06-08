// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_SelfDestroyer : SFX_ControlledObject
    {
        public float LifeTime;

        public override void Run()
        {
            base.Run();
            Destroy(gameObject, LifeTime);
        }
    }
}