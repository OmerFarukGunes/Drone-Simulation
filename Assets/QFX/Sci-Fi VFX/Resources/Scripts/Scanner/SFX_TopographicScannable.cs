using System.Linq;
using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public sealed class SFX_TopographicScannable : MonoBehaviour
    {
        public Material ScannableMaterial;
        public SFX_AnimationModule HighlightIntensity;

        private Material _scannableMaterialInstance;
        private float _startTime;

        public bool IsHighlighted { get; private set; }

        public void Highlight()
        {
            IsHighlighted = true;
            _startTime = Time.time;
        }

        public void Hide()
        {
            IsHighlighted = false;
            Reset();
        }

        private void Reset()
        {
            _scannableMaterialInstance.SetFloat("_Alpha", HighlightIntensity.Evaluate(0));
        }

        private void Start()
        {
            _scannableMaterialInstance = new Material(ScannableMaterial);

            foreach (var rend in GetComponentsInChildren<Renderer>())
            {
                var materials = rend.materials.ToList();
                materials.Add(_scannableMaterialInstance);
                rend.materials = materials.ToArray();
            }

            Reset();
        }

        private void Update()
        {
            if (!IsHighlighted)
                return;

            var time = Time.time - _startTime;
            var evalIntensity = HighlightIntensity.Evaluate(time);
            _scannableMaterialInstance.SetFloat("_Alpha", evalIntensity);
        }
    }
}