using UnityEngine.Serialization;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_ComponentsStartupController : SFX_ControlledObject
    {
        public SFX_ControlledObject[] ControlledObjects;

        public override void Run()
        {
            base.Run();
            
            foreach (var controlledObject in ControlledObjects)
            {
                controlledObject.Setup();
                controlledObject.Run();
            }
        }
    }
}