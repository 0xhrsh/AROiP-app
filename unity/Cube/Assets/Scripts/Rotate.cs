using System;
// using System.Collections.Generic;
using UnityEngine;
// using UnityEngine.EventSystems;

public class Rotate : MonoBehaviour
{
    
    float val;

    // Start is called before the first frame update
    void Start()
    {
        val = 0f;
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(val/10,0,val/10);

        // for (int i = 0; i < Input.touchCount; ++i)
        // {
        //     if (Input.GetTouch(i).phase.Equals(TouchPhase.Began))
        //     {
        //         var hit = new RaycastHit();

        //         Ray ray = Camera.main.ScreenPointToRay(Input.GetTouch(i).position);

        //         if (Physics.Raycast(ray, out hit))
        //         {
        //             // This method is used to send data to Flutter
        //             //UnityMessageManager.Instance.SendMessageToFlutter("The cube feels touched.");
        //         }
        //     }
        // }
    }

    // This method is called from Flutter
    public void SetRotationSpeed(String message)
    {
        val = float.Parse(message);
    }
}
