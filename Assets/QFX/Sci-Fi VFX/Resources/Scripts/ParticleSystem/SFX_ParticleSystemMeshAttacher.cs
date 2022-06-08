using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public static class SFX_ParticleSystemMeshAttacher
    {
        public static void Attach(ParticleSystem particleSystem, MeshRenderer meshRenderer, float normalOffset)
        {
            var psShape = particleSystem.shape;
            psShape.shapeType = ParticleSystemShapeType.MeshRenderer;
            psShape.normalOffset = normalOffset;
            psShape.meshRenderer = meshRenderer;
        }

        public static void Attach(ParticleSystem particleSystem, SkinnedMeshRenderer skinnedMeshRenderer,
            float normalOffset)
        {
            var psShape = particleSystem.shape;
            psShape.shapeType = ParticleSystemShapeType.SkinnedMeshRenderer;
            psShape.normalOffset = normalOffset;
            psShape.skinnedMeshRenderer = skinnedMeshRenderer;
        }
    }
}