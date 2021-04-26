using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Vuforia;

public class VuforiaInit : MonoBehaviour
{
public Camera ARCamera;
int index = 0;
private float timeLeft = 0.0f;

void Update()
{
    timeLeft+=Time.deltaTime;
    if (timeLeft>=3.0)
    {
        VuforiaRuntime.Instance.InitVuforia();
        ARCamera.GetComponent<VuforiaBehaviour>().enabled = true;
        print(timeLeft.ToString());
    }
}
}