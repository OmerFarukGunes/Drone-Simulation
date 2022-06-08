using System.Linq;
using UnityEngine;
using UnityEngine.Serialization;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_BeamScannerController : MonoBehaviour
    {
        public GameObject Scanner;
        public SFX_AnimationModule AppearAnimation;

        public bool IsDetectionEnabled;
        public Transform DetectionAnchor;
        public SFX_ObjectFinder ObjectFinder;

        public bool OverrideColor;

        [ColorUsageAttribute(true, true, 0f, 8f, 0.125f, 3f)]
        public Color NormalColor;

        [ColorUsageAttribute(true, true, 0f, 8f, 0.125f, 3f)]
        public Color DetectionColor;

        private Material _scannerMaterial;

        private float _startTime;

        private bool _isEnabled;

        private bool _wasDetected;

        private void Start()
        {
            _scannerMaterial = Scanner.GetComponent<Renderer>().material;

            var eval = AppearAnimation.Evaluate(0);

            if (_scannerMaterial != null)
                _scannerMaterial.SetFloat("_AppearProgress", eval);
        }

        private void OnEnable()
        {
            _isEnabled = true;
            _startTime = Time.time;

            if (OverrideColor && _scannerMaterial != null)
            {
                _scannerMaterial.SetColor("_TintColor", NormalColor);
                _scannerMaterial.SetColor("_DepthColor", NormalColor);
            }
        }

        private void OnDisable()
        {
            _isEnabled = false;
        }

        private void Update()
        {
            if (!_isEnabled)
                return;

            if (IsDetectionEnabled)
            {
                var colliders = ObjectFinder.FindObjects(DetectionAnchor.position);

                bool isObjectInRadius = colliders.Any();

                if (isObjectInRadius && !_wasDetected)
                {
                    _wasDetected = true;
                }
                else if (!isObjectInRadius && _wasDetected)
                {
                    _wasDetected = false;
                }

                if (OverrideColor && _scannerMaterial != null)
                {
                    _scannerMaterial.SetColor("_TintColor", _wasDetected ? DetectionColor : NormalColor);
                    _scannerMaterial.SetColor("_DepthColor", _wasDetected ? DetectionColor : NormalColor);
                }
            }

            var time = Time.time - _startTime;
            var appearValue = AppearAnimation.Evaluate(time);
            if (_scannerMaterial != null)
                _scannerMaterial.SetFloat("_AppearProgress", appearValue);
        }
    }
}