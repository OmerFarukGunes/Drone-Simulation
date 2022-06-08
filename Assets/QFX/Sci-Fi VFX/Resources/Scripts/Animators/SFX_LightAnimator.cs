using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    [RequireComponent(typeof(Light))]
    public class SFX_LightAnimator : SFX_ControlledObject
    {
        public SFX_AnimationModule LightIntensity;

        private float _startedTime;

        private Light _light;

        public override void Run()
        {
            base.Run();

            _light.gameObject.SetActive(true);
            _startedTime = Time.time;
            _light.intensity = LightIntensity.Evaluate(0);
        }

        public override void Stop()
        {
            base.Stop();

            _light.gameObject.SetActive(false);
        }

        private void Awake()
        {
            _light = GetComponent<Light>();
            _light.intensity = LightIntensity.Evaluate(0);
        }

        private void Update()
        {
            if (!IsRunning)
                return;

            var time = Time.time - _startedTime;
            var lightIntensity = LightIntensity.Evaluate(time);
            _light.intensity = lightIntensity;
        }
    }
}