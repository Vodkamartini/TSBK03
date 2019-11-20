using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClippingPlane : MonoBehaviour
{
    // Material we pass all the values to
    public Material material;

    void Update()
    {
        // Define plane
        Plane plane = new Plane(transform.up, transform.position);
        // Transfer plane values to vec4
        Vector4 planeRepresentation = new Vector4(plane.normal.x, plane.normal.y, plane.normal.z, plane.distance);
        // Pass vector to shader
        material.SetVector("_Plane", planeRepresentation);
    }
}
