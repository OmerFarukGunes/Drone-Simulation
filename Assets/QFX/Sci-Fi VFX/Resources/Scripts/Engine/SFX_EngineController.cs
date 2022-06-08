using System;
using System.Globalization;
using UnityEngine;
using UnityEngine.UI;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    internal sealed class SFX_EngineController : MonoBehaviour
    {
        public float PowerFactor = 1;

        public KeyCode EngineKeyCode = KeyCode.W;

        public ParticleSystem FlareParticleSystem;
        public float FlareFactor = 150;

        public ParticleSystem SlowSparksParticleSystem;
        public float SlowSparksFactor = 10;

        public ParticleSystem FastSparksParticleSystem;
        public float FastSparksFactor = 10;

        public ParticleSystem DistortionParticleSystem;
        public float DistortionFactor;

        public GameObject EngineInner;
        
        //ONLY FOR THE DEMO
        public Text TextUi;
        
        private float _currentPower;
        private bool _isButtonHeld;

        private Material _engineInnerMaterial;
        
        private void OnEnable()
        {
            _engineInnerMaterial = EngineInner.GetComponent<Renderer>().material;
        }

        private void Update()
        {
            var enginePower = PowerFactor * Time.deltaTime;

            if (Input.GetKeyDown(EngineKeyCode))
                _isButtonHeld = true;
            else if (Input.GetKeyUp(EngineKeyCode))
                _isButtonHeld = false;

            if (_isButtonHeld)
                _currentPower += enginePower;
            else
                _currentPower -= enginePower;

            _currentPower = Mathf.Clamp01(_currentPower);

            var flareForceModule = FlareParticleSystem.forceOverLifetime;
            flareForceModule.zMultiplier = -(FlareFactor * _currentPower);

            var slowSparksMain = SlowSparksParticleSystem.main;
            var slowSpeedModule = slowSparksMain.startSpeed;
            slowSpeedModule.constantMin = _currentPower * SlowSparksFactor;
            slowSpeedModule.constantMax = _currentPower * (SlowSparksFactor + 7);
            slowSparksMain.startSpeed = slowSpeedModule;

            var fastSparksMain = FastSparksParticleSystem.main;
            var fastSpeedModule = fastSparksMain.startSpeed;
            fastSpeedModule.constantMin = _currentPower * FastSparksFactor;
            fastSpeedModule.constantMax = _currentPower * (FastSparksFactor + 10);
            fastSparksMain.startSpeed = fastSpeedModule;

            var noiseModule = FastSparksParticleSystem.noise;
            noiseModule.enabled = Math.Abs(_currentPower) > 0.01;

            var distortionModule = DistortionParticleSystem.forceOverLifetime;
            distortionModule.zMultiplier = -(DistortionFactor * _currentPower);

            var tintColor = _engineInnerMaterial.GetColor("_TintColor");
            tintColor.a = _currentPower;
            _engineInnerMaterial.SetColor("_TintColor", tintColor);
            
            //ONLY FOR THE DEMO
            TextUi.text = ((int) (_currentPower * 100)).ToString(CultureInfo.InvariantCulture);
        }
    }
}