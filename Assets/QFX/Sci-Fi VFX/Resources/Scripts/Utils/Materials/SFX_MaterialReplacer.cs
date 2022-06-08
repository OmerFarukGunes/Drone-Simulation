using System.Collections.Generic;
using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_MaterialReplacer : SFX_ControlledObject
    {
        public Material Material;
        public float LifeTime;

        private Dictionary<Renderer, Material[]> _originalMaterials;

        public override void Setup()
        {
            base.Setup();
            
            _originalMaterials = SFX_MaterialUtil.GetOriginalMaterials(gameObject);
            SFX_MaterialUtil.ReplaceMaterial(gameObject, Material);
        }

        public override void Run()
        {
            base.Run();
            
            //Revert
            SFX_InvokeUtil.RunLater(this, delegate
            {
                SFX_MaterialUtil.ReplaceMaterial(_originalMaterials);
                _originalMaterials.Clear();
            }, LifeTime);
        }
    }
}