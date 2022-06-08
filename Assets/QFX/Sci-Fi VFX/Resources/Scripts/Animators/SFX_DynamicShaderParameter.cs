using System;
using UnityEngine.Serialization;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    [Serializable]
    public class SFX_DynamicShaderParameter
    {
        public SFX_AnimationModule AnimationModule;
        public string ParameterName;
        public ParameterType Type;

        public enum ParameterType
        {
            Float,
            ColorAlpha
        }
    }
}