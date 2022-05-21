using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class TagInfo : MonoBehaviour {

	[Header("Tag Text Source")]
	public TextMesh AssetName;
	public TextMesh PrefabName;
	public TextMesh Location;
	public TextMesh LOD0;
	public TextMesh LOD1;
	public TextMesh LOD2;
	public TextMesh MainMapSize;
	public TextMesh SecondMapSize;
	public TextMesh Number;
	public TextMesh Comments;
	[Header("Compass Info")]
	public GameObject CompassRotator;
	public GameObject CompassTargetTag;
	[Header("Round Circle Info")]
	public GameObject CircleLod0;
	public GameObject CircleLod1;
}
