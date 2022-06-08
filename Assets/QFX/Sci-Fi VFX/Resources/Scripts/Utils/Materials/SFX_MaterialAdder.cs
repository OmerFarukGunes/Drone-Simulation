using System.Collections.Generic;
using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_MaterialAdder : SFX_ControlledObject
    {
        public Material Material;
        public float LifeTime;

        public GameObject[] Targets;

        private readonly Dictionary<Renderer, Material[]> _rendToMaterialsMap = new Dictionary<Renderer, Material[]>();

        private bool _isMaterialAdded;

        private float _addedTime;

        public override void Run()
        {
            base.Run();

            _addedTime = Time.time;

            if (_isMaterialAdded)
                return;

            if (Targets != null && Targets.Length > 0)
            {
                foreach (var target in Targets)
                {
                    GetMaterialsAndFillCollection(target);
                }
            }
            else
            {
                GetMaterialsAndFillCollection(gameObject);
            }

            _isMaterialAdded = true;


            SFX_InvokeUtil.RunLater(this, Stop, LifeTime);
        }

        public override void Stop()
        {
            base.Stop();

            var timeDiff = Time.time - _addedTime;
            if (timeDiff < LifeTime)
            {
                //call again
                SFX_InvokeUtil.RunLater(this, Stop, LifeTime - timeDiff);
                return;
            }

            SFX_MaterialUtil.ReplaceMaterial(_rendToMaterialsMap);
            _rendToMaterialsMap.Clear();
            _isMaterialAdded = false;
        }

        private void GetMaterialsAndFillCollection(GameObject targetGo)
        {
            var rendToMaterials = SFX_MaterialUtil.GetOriginalMaterials(targetGo);
            foreach (var rToMat in rendToMaterials)
                _rendToMaterialsMap[rToMat.Key] = rToMat.Value;
            SFX_MaterialUtil.AddMaterial(targetGo, Material);
        }
    }
}