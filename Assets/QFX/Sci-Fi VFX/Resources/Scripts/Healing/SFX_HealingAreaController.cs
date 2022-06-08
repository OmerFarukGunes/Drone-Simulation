using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_HealingAreaController : SFX_ControlledObject
    {
        public GameObject HealingAreaFx;
        public GameObject HealingFx;
        public SFX_ObjectFinder ObjectsFinder;

        private readonly Dictionary<GameObject, ParticleSystem>
            _healableObjectsInArea = new Dictionary<GameObject, ParticleSystem>();

        public override void Run()
        {
            base.Run();

            var healingAreaGo = Instantiate(HealingAreaFx, transform.position, transform.rotation);
            healingAreaGo.transform.parent = transform;
        }

        private void FixedUpdate()
        {
            if (!IsRunning)
                return;

            var healableObjects = ObjectsFinder.FindObjects(transform.position);

            foreach (var healable in healableObjects)
            {
                var healableGo = healable.gameObject;

                if (!_healableObjectsInArea.ContainsKey(healableGo))
                {
                    var offset = new Vector3(0, healable.bounds.center.y, 0);
                    var targetPosition = healable.transform.position + offset;
                    var healingGo = Instantiate(HealingFx, targetPosition, Quaternion.identity);
                    healingGo.transform.parent = healable.transform;

                    var healingPs = healingGo.GetComponent<ParticleSystem>();

                    _healableObjectsInArea[healableGo] = healingPs;

                    SFX_InvokeUtil.RunLater(this, delegate
                    {
                        healingPs.Stop();
                        Destroy(healingPs.gameObject, 1f);
                        _healableObjectsInArea.Remove(healableGo);
                    }, healingPs.main.duration);
                }
            }
        }
    }
}
