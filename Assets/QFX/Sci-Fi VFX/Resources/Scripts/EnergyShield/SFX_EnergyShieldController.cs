using System;
using System.Collections.Generic;
using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    [RequireComponent(typeof(SFX_ColliderCollisionDetector))]
    [ExecuteInEditMode]
    public class SFX_EnergyShieldController : SFX_ControlledObject
    {
        public Renderer TargetRenderer;

        public float HitWaveSpeed = 1f;

        //In case if it's a ParticleSystem, not a object
        public bool ProvideObjectWorldCoordinates;

        private const int HitMaxCount = 10;

        private const string HitPositionsPropertyName = "_HitPositions";
        private const string HitRadiiPropertyName = "_HitRadii";
        private const string WorldPositionPropertyName = "_ObjectWorldPosition";

        private const float MaxHitRadius = 1;
        private const float MinHitRadius = 0;

        private readonly Vector4[] _hitPositions = new Vector4[HitMaxCount];
        private readonly float[] _hitRadii = new float[HitMaxCount];

        private Material _material;

        private int _currentHitIdx = -1;

        private Transform _transform;

        private void Awake()
        {
            _transform = transform;
            _material = TargetRenderer.sharedMaterial;
            var collisionDetector = GetComponent<SFX_ColliderCollisionDetector>();
            collisionDetector.OnCollision += delegate (SFX_CollisionPoint collisionPoint)
            {
                AddHitData(collisionPoint.Point);
            };
        }

        private void Update()
        {
            if (!IsRunning)
                return;

            var hitIdxToReset = new List<int>();

            for (int i = 0; i < HitMaxCount; i++)
            {
                if (Math.Abs(_hitRadii[i] - -1) < 0.01)
                    continue;

                _hitRadii[i] += HitWaveSpeed * Time.deltaTime;
                if (_hitRadii[i] >= MaxHitRadius)
                    hitIdxToReset.Add(i);
            }

            foreach (var idx in hitIdxToReset)
            {
                _hitPositions[idx] = Vector4.zero;
                _hitRadii[idx] = -1;
            }
            UpdateMaterial();
        }

        private void AddHitData(Vector3 position)
        {
            _currentHitIdx++;

            if (_currentHitIdx >= HitMaxCount)
                _currentHitIdx = 0;

            _hitPositions[_currentHitIdx] = position;
            _hitRadii[_currentHitIdx] = MinHitRadius;
        }

        private void UpdateMaterial()
        {
            _material.SetVectorArray(HitPositionsPropertyName, _hitPositions);
            _material.SetFloatArray(HitRadiiPropertyName, _hitRadii);

            if (ProvideObjectWorldCoordinates)
                _material.SetVector(WorldPositionPropertyName, _transform.position);
        }
    }
}