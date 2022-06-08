using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_ShaderAnimator : SFX_ControlledObject
    {
        public SFX_DynamicShaderParameter[] DynamicShaderParameters;

        private float _startTime;
        private List<Material> _materials;

        public override void Setup()
        {
            base.Setup();

            _startTime = Time.time;
            _materials = new List<Material>();

            var rends = GetComponentsInChildren<Renderer>(true);
            foreach (var rend in rends)
                _materials.AddRange(rend.materials);

            UpdateMaterials(0);
        }

        public override void Run()
        {
            base.Run();
            _startTime = Time.time;
        }

        private void Update()
        {
            if (!IsRunning)
                return;

            var time = Time.time - _startTime;

            UpdateMaterials(time);
        }

        private void UpdateMaterials(float time)
        {
            if (DynamicShaderParameters == null)
                return;

            foreach (var shaderParameter in DynamicShaderParameters)
            {
                if (shaderParameter.AnimationModule == null)
                    continue;

                var val = shaderParameter.AnimationModule.Evaluate(time);

                foreach (var material in _materials)
                {
                    if (!material.HasProperty(shaderParameter.ParameterName))
                        continue;

                    if (shaderParameter.Type == SFX_DynamicShaderParameter.ParameterType.Float)
                    {
                        material.SetFloat(shaderParameter.ParameterName, val);
                    }
                    else if (shaderParameter.Type == SFX_DynamicShaderParameter.ParameterType.ColorAlpha)
                    {
                        var color = material.GetColor(shaderParameter.ParameterName);
                        color.a = val;
                        material.SetColor(shaderParameter.ParameterName, color);
                    }
                }
            }
        }
    }
}