using System.Collections.Generic;
using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_MotionCloner : SFX_ControlledObject
    {
        public GameObject TargetGameObject;

        public float CloneLifeTime = 1f;
        public float CloneRate = 1f;

        public bool ReplaceMaterialInMotion;
        public Material MotionMaterial;

        public GameObject TrailParticleSystem;
        public GameObject ActivateCloneParticleSystem;
        public GameObject FinishMotionParticleSystem;

        public GameObject CloneParticleSystem;
        public MeshRenderer MeshRenderer;
        public SkinnedMeshRenderer SkinnedMeshRenderer;

        private GameObject _activateCloneGo;
        private ParticleSystem _activateClonePs;

        private GameObject _trailGo;
        private ParticleSystem _trailPs;

        private GameObject _finishGo;
        private ParticleSystem _finishPs;

        private readonly Dictionary<Renderer, Material[]> _rendererToSharedMaterials =
            new Dictionary<Renderer, Material[]>();

        private float _time;

        public override void Setup()
        {
            base.Setup();

            if (ReplaceMaterialInMotion)
            {
                var rends = TargetGameObject.GetComponentsInChildren<Renderer>();
                foreach (var rend in rends)
                    _rendererToSharedMaterials[rend] = rend.sharedMaterials;
            }

            if (ActivateCloneParticleSystem != null)
            {
                _activateCloneGo = Instantiate(ActivateCloneParticleSystem, Vector3.zero, Quaternion.identity);
                _activateClonePs = _activateCloneGo.GetComponent<ParticleSystem>();
                _activateCloneGo.SetActive(true);
                _activateCloneGo.transform.parent = TargetGameObject.transform;
                if (MeshRenderer != null)
                    SFX_ParticleSystemMeshAttacher.Attach(_activateClonePs, MeshRenderer, 0f);
                else if (SkinnedMeshRenderer != null)
                    SFX_ParticleSystemMeshAttacher.Attach(_activateClonePs, SkinnedMeshRenderer, 0f);
            }

            if (TrailParticleSystem != null)
            {
                _trailGo = Instantiate(TrailParticleSystem, Vector3.zero, Quaternion.identity);
                _trailPs = _trailGo.GetComponent<ParticleSystem>();
                _trailGo.SetActive(true);
                _trailGo.transform.parent = TargetGameObject.transform;
                if (MeshRenderer != null)
                    SFX_ParticleSystemMeshAttacher.Attach(_trailPs, MeshRenderer, 0f);
                else if (SkinnedMeshRenderer != null)
                    SFX_ParticleSystemMeshAttacher.Attach(_trailPs, SkinnedMeshRenderer, 0f);
            }

            if (FinishMotionParticleSystem != null)
            {
                _finishGo = Instantiate(FinishMotionParticleSystem, Vector3.zero, Quaternion.identity);
                _finishPs = _finishGo.GetComponent<ParticleSystem>();
                _finishGo.SetActive(true);
                _finishGo.transform.parent = TargetGameObject.transform;
                if (MeshRenderer != null)
                    SFX_ParticleSystemMeshAttacher.Attach(_finishPs, MeshRenderer, 0f);
                else if (SkinnedMeshRenderer != null)
                    SFX_ParticleSystemMeshAttacher.Attach(_finishPs, SkinnedMeshRenderer, 0f);
            }
        }

        public override void Run()
        {
            if (IsRunning)
                return;

            Activate();

            base.Run();
        }

        public override void Stop()
        {
            base.Stop();
            DeActivate();
        }

        public void MakeClone()
        {
            if (_activateCloneGo != null && _activateClonePs != null)
            {
                _activateCloneGo.transform.position = transform.position;
                _activateClonePs.Play();
            }

            var clone = Instantiate(TargetGameObject, TargetGameObject.transform.position,
                TargetGameObject.transform.rotation);

            foreach (var comp in clone.GetComponentsInChildren<Component>())
                if (!(comp is Renderer) && !(comp is Transform) && !(comp is MeshFilter))
                    Destroy(comp);

            var cloneDestroyer = clone.AddComponent<SFX_SelfDestroyer>();
            cloneDestroyer.LifeTime = CloneLifeTime;
            cloneDestroyer.Run();

            if (CloneParticleSystem != null)
            {
                var go = Instantiate(CloneParticleSystem, TargetGameObject.transform.position,
                    TargetGameObject.transform.transform.rotation);
                var ps = go.GetComponent<ParticleSystem>();

                if (MeshRenderer != null)
                    SFX_ParticleSystemMeshAttacher.Attach(ps, MeshRenderer, 0f);
                else if (SkinnedMeshRenderer != null)
                    SFX_ParticleSystemMeshAttacher.Attach(ps, SkinnedMeshRenderer, 0f);

                ps.gameObject.SetActive(true);
                ps.Play();
            }

            Destroy(clone, CloneLifeTime);
        }

        private void Activate()
        {
            _time = 0;

            if (ReplaceMaterialInMotion)
            {
                foreach (var originalMaterial in _rendererToSharedMaterials.Keys)
                {
                    var newMaterials = new Material[originalMaterial.sharedMaterials.Length];
                    for (int i = 0; i < newMaterials.Length; i++)
                        newMaterials[i] = MotionMaterial;
                    originalMaterial.sharedMaterials = newMaterials;
                }
            }

            if (_trailPs != null)
                _trailPs.Play();

            MakeClone();
        }

        private void DeActivate()
        {
            if (_trailPs != null)
                _trailPs.Stop();

            foreach (var originalMaterial in _rendererToSharedMaterials)
                originalMaterial.Key.sharedMaterials = originalMaterial.Value;

            if (_finishPs != null)
                _finishPs.Play();
        }

        private void Update()
        {
            if (Input.GetMouseButtonDown(0))
                Run();
            else if (Input.GetMouseButtonUp(0))
                Stop();

            if (!IsRunning)
                return;

            _time += Time.deltaTime;

            if (_time >= CloneRate)
            {
                MakeClone();
                _time = 0;
            }
        }

        private void OnDestroy()
        {
            Destroy(_activateCloneGo);
            Destroy(_trailGo);
            Destroy(_finishGo);
        }
    }
}