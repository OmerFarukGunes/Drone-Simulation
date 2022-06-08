using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.SFX
{
    public class SFX_ControlledObject : MonoBehaviour
    {
        public bool RunAtStart = true;
        public float Delay;

        public bool IsRunning { get; private set; }

        private void OnEnable()
        {
            Setup();

            if (RunAtStart)
                SFX_InvokeUtil.RunLater(this, Run, Delay);
        }

        public virtual void Setup()
        {
        }

        public virtual void Run()
        {
            IsRunning = true;
        }

        public virtual void Stop()
        {
            IsRunning = false;
        }
    }
}