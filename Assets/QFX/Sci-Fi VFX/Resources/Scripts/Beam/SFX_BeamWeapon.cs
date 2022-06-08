using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_BeamWeapon : SFX_ControlledObject
    {
        public Transform StartTransform;

        [HideInInspector] public Vector3 EndPosition;

        public GameObject LaunchParticleSystem;
        public Light LaunchLight;

        public GameObject ImpactParticleSystem;
        public float ImpactOffset;

        public LineRenderer LineRenderer;

        public float MaxDistance;

        public float LightIntensity;
        public float LineRendererWidth;
        public float AppearSpeed;

        private float _appearProgress;
        private float _beamActivatedTime;

        private ParticleSystem _launchPs;
        private ParticleSystem _impactPs;

        private LineRenderer _lineRenderer;

        public override void Setup()
        {
            base.Setup();

            _lineRenderer = Instantiate(LineRenderer, transform, true);

            _lineRenderer.positionCount = 2;
            LaunchLight.intensity = 0;
            _lineRenderer.widthMultiplier = 0;

            var launchGo = Instantiate(LaunchParticleSystem, StartTransform.position, Quaternion.identity,
                StartTransform);

            _launchPs = launchGo.GetComponent<ParticleSystem>();
            _impactPs = Instantiate(ImpactParticleSystem).GetComponent<ParticleSystem>();
        }

        public override void Run()
        {
            if (IsRunning)
                return;

            _launchPs.Play();
            _impactPs.Play();

            base.Run();
        }

        public override void Stop()
        {
            base.Stop();

            _launchPs.Stop();
            _impactPs.Stop();
        }

        private void Update()
        {
            if (Input.GetMouseButtonDown(0))
                Run();
            else if (Input.GetMouseButtonUp(0))
                Stop();

            if (!IsRunning && _appearProgress <= 0.0f)
                return;

            var incValue = Time.deltaTime * AppearSpeed;

            if (IsRunning)
                _appearProgress += incValue;
            else
                _appearProgress -= incValue;

            _appearProgress = Mathf.Clamp01(_appearProgress);

            RaycastHit hit;
            if (Physics.Raycast(transform.position, transform.forward, out hit, MaxDistance))
                EndPosition = hit.point;
            else EndPosition = transform.position + transform.forward * MaxDistance;

            //            if (_appearProgress >= 0.2f)
            //            {
            //                if (!_launchPs.isPlaying)
            //                    _launchPs.Play(true);
            //                _impactPs.Play(true);

            var hitPosition = hit.point;

            var startPosition = StartTransform.position;
            var directionToEmitter = (hitPosition - startPosition).normalized;
            hitPosition += directionToEmitter * ImpactOffset;

            _impactPs.transform.position = hitPosition;
            _impactPs.transform.LookAt(startPosition);

            //            }
            //            else
            //            {
            //                if (_launchPs.isPlaying)
            //                    _launchPs.Stop(true);
            //                _impactPs.Stop(true);
            //            }

            LaunchLight.intensity = LightIntensity * _appearProgress;

            UpdateLineRenderer();
        }

        private void UpdateLineRenderer()
        {
            _lineRenderer.widthMultiplier = _appearProgress * LineRendererWidth;
            _lineRenderer.SetPosition(0, StartTransform.position);
            _lineRenderer.SetPosition(1, EndPosition);
        }
    }
}