using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    [ExecuteInEditMode]
    public sealed class SFX_TopographicScannerController : MonoBehaviour
    {
        public KeyCode ScannerKeyCode;

        public Transform ScannerOrigin;
        public Material EffectMaterial;
        public float ScanDistance;
        public float ScanWidth;
        public float ScanSpeed;

        private float _currentScanDistance;
        private bool _isScanning;
        private SFX_TopographicScannable[] m_sfxTopographicScannables;
        private Camera _camera;

        private void OnEnable()
        {
            _camera = GetComponent<Camera>();
            _camera.depthTextureMode = DepthTextureMode.Depth;
        }

        private void Start()
        {
            m_sfxTopographicScannables = FindObjectsOfType<SFX_TopographicScannable>();
        }

        private void Update()
        {
            if (_isScanning)
            {
                _currentScanDistance += Time.deltaTime * ScanSpeed;

                foreach (var scannable in m_sfxTopographicScannables)
                {
                    var distance = Vector3.Distance(ScannerOrigin.position, scannable.transform.position);

                    if (distance <= _currentScanDistance && distance > _currentScanDistance - ScanWidth &&
                        !scannable.IsHighlighted)
                    {
                        scannable.Highlight();
                    }
                }

                if (_currentScanDistance > ScanDistance)
                {
                    _isScanning = false;
                    _currentScanDistance = 0;
                }
            }

            if (Input.GetKeyDown(ScannerKeyCode))
                Activate();
        }

        private void Activate()
        {
            _isScanning = true;

            _currentScanDistance = 0;

            foreach (var scannable in m_sfxTopographicScannables)
                scannable.Hide();
        }

        private void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            EffectMaterial.SetVector("_WorldPosition", ScannerOrigin.position);
            EffectMaterial.SetFloat("_ScanDistance", _currentScanDistance);
            EffectMaterial.SetFloat("_ScanWidth", ScanWidth);

            Graphics.Blit(source, destination, EffectMaterial);
        }
    }
}