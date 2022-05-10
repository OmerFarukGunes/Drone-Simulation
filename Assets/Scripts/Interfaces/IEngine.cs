using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace OmerFG
{
    public interface IEngine
    {
        void InitEngine();
        void UpdateEngine(Rigidbody rb, DroneInputs input);

    }
}
