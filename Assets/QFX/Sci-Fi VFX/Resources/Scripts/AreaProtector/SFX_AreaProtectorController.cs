using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Serialization;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_AreaProtectorController : SFX_ControlledObject
    {
        public GameObject Weapon;
        public Transform WeaponPosition;

        public float AllowedTimeInProtectionRadius;

        public float LaserMaxDistance;
        public LayerMask LaserLayerMask;
        public float LaserContactOffset;
        public ParticleSystem LaserImpact;
        public LineRenderer LaserLine;
        public int LasersCount;

        public SFX_AnimationModule ForceOverLifeTime;
        public SFX_AnimationModule LaserRotationOverLifeTime;
        public SFX_AnimationModule LaserRadiusOverLifeTime;

        public SFX_ObjectFinder ObjectFinder;

        private float _enemyEnteredRadiusTime;

        private bool _isLasersActive;

        private float _forceTime;
        private float _radiusTime;
        private float _rotationTime;

        private GameObject _target;

        private readonly List<LaserInstance> _lineInstances = new List<LaserInstance>();

        private SFX_ControlledObject _weapon;

        public override void Setup()
        {
            base.Setup();

            var weaponGo = Instantiate(Weapon);
            weaponGo.transform.position = WeaponPosition.position;
            weaponGo.transform.rotation = WeaponPosition.rotation;
            _weapon = weaponGo.GetComponent<SFX_ControlledObject>();
            _weapon.Setup();
        }

        public override void Run()
        {
            base.Run();
            _forceTime = Time.time;
        }

        private void OnEnable()
        {
            if (RunAtStart)
            {
                SFX_InvokeUtil.RunLater(this, delegate
                {
                    Setup();
                    Run();
                }, Delay);
            }
        }

        private void Update()
        {
            if (!IsRunning)
                return;

            var foundObjects = ObjectFinder.FindObjects(transform.position);

            if (_target != null)
                _weapon.transform.LookAt(_target.transform);

            _weapon.transform.position = WeaponPosition.position;

            if (!foundObjects.Any())
            {
                if (_isLasersActive)
                    DeactivateLasers();

                if (_weapon.IsRunning)
                    _weapon.Stop();
            }
            else
            {
                _target = foundObjects[0].gameObject;

                if (_isLasersActive && Time.time - _enemyEnteredRadiusTime > AllowedTimeInProtectionRadius)
                {
                    if (!_weapon.IsRunning)
                        _weapon.Run();

                    if (_isLasersActive)
                        DeactivateLasers();
                }

                if (!_isLasersActive && !_weapon.IsRunning)
                {
                    _enemyEnteredRadiusTime = Time.time;
                    ActivateLasers(_target.gameObject);
                }
            }

            var force = ForceOverLifeTime.Evaluate(Time.time - _forceTime);
            var newPos = transform.position;
            newPos.y += force;
            transform.position = newPos;

            if (_isLasersActive)
            {
                foreach (var lineInstance in _lineInstances)
                {
                    lineInstance.Angle +=
                        LaserRotationOverLifeTime.Evaluate(Time.time - _rotationTime) * Time.deltaTime;
                    var lr = lineInstance.LineRenderer;
                    var circlePos = GetPosOnCircle(_target.transform.position, lineInstance.Center.y,
                        lineInstance.Angle,
                        LaserRadiusOverLifeTime.Evaluate(Time.time - _radiusTime));
                    lr.SetPosition(0, transform.position);
                    lr.SetPosition(1, circlePos);
                    lineInstance.Impact.transform.position = circlePos;
                    lineInstance.Impact.transform.LookAt(transform);
                }
            }
        }

        private void ActivateLasers(GameObject target)
        {
            RaycastHit raycastHit;

            var raycast = Physics.Raycast(transform.position, Vector3.down, out raycastHit, LaserMaxDistance,
                LaserLayerMask);

            if (raycast)
            {
                for (int i = 0; i < LasersCount; i++)
                {
                    var angle = Random.value * 360;

                    var lr = Instantiate(LaserLine);
                    var randomCircle = GetPosOnCircle(target.transform.position, raycastHit.point.y, angle,
                        LaserRadiusOverLifeTime.Evaluate(0));

                    lr.SetPosition(0, transform.position);
                    lr.SetPosition(1, randomCircle);

                    var laserImpact = Instantiate(LaserImpact);
                    laserImpact.transform.position = randomCircle;
                    laserImpact.transform.LookAt(transform);

                    var lineInstance = new LaserInstance
                    {
                        Angle = angle,
                        LineRenderer = lr,
                        Center = raycastHit.point,
                        Impact = laserImpact
                    };

                    _lineInstances.Add(lineInstance);
                }
            }

            _rotationTime = Time.time;
            _radiusTime = Time.time;
            _isLasersActive = true;
        }

        private void DeactivateLasers()
        {
            _isLasersActive = false;
            foreach (var lineInstance in _lineInstances)
            {
                Destroy(lineInstance.LineRenderer.gameObject);
                lineInstance.Impact.Stop(true);
                Destroy(lineInstance.Impact.gameObject, 1f);
            }

            _lineInstances.Clear();
        }

        private Vector3 GetPosOnCircle(Vector3 center, float posY, float angle, float radius)
        {
            Vector3 pos;
            pos.x = center.x + radius * Mathf.Sin(angle * Mathf.Deg2Rad);
            pos.y = posY + LaserContactOffset;
            pos.z = center.z + radius * Mathf.Cos(angle * Mathf.Deg2Rad);
            return pos;
        }

        private void OnDestroy()
        {
            Destroy(_weapon.gameObject);
            foreach (var lineInstance in _lineInstances)
            {
                Destroy(lineInstance.LineRenderer.gameObject);
                Destroy(lineInstance.Impact.gameObject);
            }
        }

        private class LaserInstance
        {
            public float Angle;
            public ParticleSystem Impact;
            public LineRenderer LineRenderer;
            public Vector3 Center;
        }
    }
}