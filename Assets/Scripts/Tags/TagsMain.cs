using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

[ExecuteInEditMode]

public class TagsMain : MonoBehaviour {

	// Create multiple choice variable
	public enum TextureSize
	{
		_None,
		_32,
		_64,
		_128,
		_256,
		_512,
		_1024,
		_2048,
		_4096,
		_8K,
		_16k
	}

	// Create array with all prefabs information
	[System.Serializable]
	public class Prefab
	{
		[Header("Asset Info")]
		public string PrefabOrder;
		public string Name;
		public GameObject TagInfo;
		public GameObject ReferenceGO;
		public GameObject AssetPrefab;
//		[HideInInspector]
		public GameObject Category;
		public float Lod0Tricount;
		public float Lod1Tricount;
		public float Lod2Tricount;
		public TextureSize MainMaps;
		public TextureSize SecondaryMaps;
		[Multiline]
		public string AdditionalInfo;
		[Header("Lookup Settings")]
		public bool ShowCirce;
		public bool TargetCompass = false;
		public bool TagsInPosition = true;
		public bool TagOrderNum = true;
		public string TagNotes;
	};

	[Header("[Prefab List]")]

	public List<Prefab> PrefabList;

	// General Variables
	[Header("[General Settings]")]
	public string AssetPackName;
	public bool CheckOnUpdate = false;
	public bool SceneGOTags;
	public bool ShowTargetTags = true;

	[Header("[Lookup Settings]")]
	public Texture PackIcon;
	public bool UseIcon = true;
	public Color MainColor = new Color (69, 69, 69);
	public Color SecondaryColor = new Color (255, 255, 255);
	[Range(0, 10)]
	public float EmissionLevel = 2f;
	public Material TagMaterial;
	public Material GlowMaterial;
	public Material IconMaterial;


	// Polycounter Colors
	[Header("[PolyCount Colors]")]
	public Color32 _1k = new Color32 (190, 200, 250, 1);
	public Color32 _3k = new Color32 (25, 250, 150, 1);
	public Color32 _5k = new Color32 (90, 220, 30, 1);
	public Color32 _10k = new Color32 (250, 230, 100, 1);
	public Color32 _20k = new Color32 (255, 150, 30, 1);
	public Color32 _30k = new Color32 (250, 0, 0, 1);
	public Color32 _50k = new Color32 (170, 0, 0, 1);
	public Color32 _more = new Color32 (170, 30, 230, 1);

	// Save Original Values
	private Color32 _tagmat;
	private Color32 _glowmat;
	private Texture _oldicon;

	void Start() {

		_tagmat = TagMaterial.color;
		_glowmat = GlowMaterial.color;
		_oldicon = IconMaterial.mainTexture;
	}

	/// APPLY VALUES ON Awake---------------------
	void Update() {
	
		// Apply General Settings-----
		TagMaterial.color = MainColor;
		GlowMaterial.SetColor("_EmissionColor", (SecondaryColor*EmissionLevel));

		if ((PackIcon != null) && UseIcon)
		IconMaterial.mainTexture = PackIcon;



	// apply to all elements in list------
	foreach (Prefab pf in PrefabList)
		{
			// Ensure the gameobject is linked
			if (pf.TagInfo != null)
			{
				// Get Component Text in TAG
				TagInfo _info = pf.TagInfo.GetComponent<TagInfo>();
				// Get Compass Rotator script
				Compass _comp = _info.CompassRotator.GetComponent<Compass>();
				// Get Compass Target Label
				TextMesh _lab = _info.CompassTargetTag.GetComponent<TextMesh>();
				// Get Tag Parent
				//string _tagPar = (pf.TagInfo.GetComponentInParent<GameObject>()).name;

				// Create proxy strings for LODs
				string _lod0 = "N/A";
				string _lod1 = "N/A";
				string _lod2 = "N/A";
				int _lodlevels = 3;


				// SET GENERAL VALUES
				_info.AssetName.text = pf.Name;
				_info.AssetName.color = SecondaryColor;
				_info.MainMapSize.text = pf.MainMaps.ToString().Remove(0,1);
				_info.Number.text = "# "+ pf.PrefabOrder;
				_info.Number.color = SecondaryColor;
				_info.Comments.text = pf.AdditionalInfo;
				_info.gameObject.name = ("TAG#" + pf.PrefabOrder+ " " + pf.Name);

				// CATEGORY CHECK
				if (pf.Category != null)
				{
					_info.Location.gameObject.SetActive(true);
					_info.Location.text = pf.Category.name;
				}
				else
					_info.Location.gameObject.SetActive(false);

				//SECONDARY MAPS CHECK
				if (pf.SecondaryMaps != TextureSize._None)
					{
					_info.SecondMapSize.gameObject.SetActive(true);
					_info.SecondMapSize.text = pf.SecondaryMaps.ToString().Remove(0,1);
					}
				else
					_info.SecondMapSize.gameObject.SetActive(false);

				//PREFAB NAME
				if ((SceneGOTags) & (pf.ReferenceGO != null))
					_info.PrefabName.text = pf.ReferenceGO.name;
					else
					if (pf.AssetPrefab != null)
						_info.PrefabName.text = pf.AssetPrefab.name;
						else
						_info.PrefabName.text = ("Asset Number" + pf.PrefabOrder + " (Not Assigned)");


				//COMPASS TARGET
				if ((pf.ReferenceGO != null) && pf.TargetCompass)
					_comp.Target = pf.ReferenceGO;
				else

					_comp.Target = _info.CompassTargetTag;

				//COMPASS TARGET TAG
				if ((SceneGOTags) && (pf.ReferenceGO != null) && (ShowTargetTags))
					_lab.text =  "# "+ pf.PrefabOrder+ " ["+ pf.ReferenceGO.name+ "] "+ pf.TagNotes;
				else
				{
				if ((pf.TagOrderNum) && ShowTargetTags)
					{
					_lab.gameObject.SetActive(true);
						_lab.text = "# "+ pf.PrefabOrder+" "+ pf.TagNotes;
					}
				else
				{
				if (ShowTargetTags)
					{
					_lab.gameObject.SetActive(true);
							_lab.text = "# "+ pf.PrefabOrder+ " ["+ pf.AssetPrefab.name+  "] "+ pf.TagNotes;
					}
					else
						_lab.gameObject.SetActive(false);
				}
				}

				// ENABLE-DISABLE PIECES
				if (pf.ShowCirce)
				{
				_info.CircleLod0.SetActive(true);
				_info.CircleLod1.SetActive(true);
				}
				else
				{
					_info.CircleLod0.SetActive(false);
					_info.CircleLod1.SetActive(false);
				}

				// MOVE TARGET TAG TO GO LOCATION

				if ((pf.TagsInPosition) && (pf.ReferenceGO != null))
					_info.CompassTargetTag.gameObject.transform.position = pf.ReferenceGO.transform.position;
				else
					if(pf.ReferenceGO == null)
						Debug.LogWarning("Can't move "+ pf.PrefabOrder + " [" + pf.Name +"] to Reference GO position because there is no GameObject selected");



				/// SET VALUES FOR LOD 0
				// Change tricount up to 1k
				if (pf.Lod0Tricount > 1000f)
				{
					_lod0 = (Mathf.RoundToInt(pf.Lod0Tricount/1000f)).ToString() + "k";

					// Change Text Color depending on triangle count
					if (pf.Lod0Tricount > 50000f)
						_info.LOD0.color = _more;
					else
						if (pf.Lod0Tricount > 30000f)
							_info.LOD0.color = _50k;
					else
						if (pf.Lod0Tricount > 10000f)
							_info.LOD0.color = _30k;
					else
						if (pf.Lod0Tricount > 5000f)
							_info.LOD0.color = _10k;
					else
						if (pf.Lod0Tricount > 3000f)
							_info.LOD0.color = _5k;
					else
						if (pf.Lod0Tricount > 1000f)
							_info.LOD0.color = _3k;

				}

				// Set under 1k values
				else
					if (pf.Lod0Tricount == 0f)
						_lodlevels = 0;
					else
				{
					_lod0 = pf.Lod0Tricount.ToString();
					_info.LOD0.color = _1k;
				}


				/// SET VALUES FOR LOD 1
				// Change tricount up to 1k
				if ((pf.Lod1Tricount > 1000f) && (_lodlevels != 0))
				{
					_lod1 = (Mathf.RoundToInt(pf.Lod1Tricount/1000f)).ToString() + "k";
					
					// Change Text Color depending on triangle count
					if (pf.Lod1Tricount > 50000f)
						_info.LOD1.color = _more;
					else
						if (pf.Lod1Tricount > 30000f)
							_info.LOD1.color = _50k;
					else
						if (pf.Lod1Tricount > 10000f)
							_info.LOD1.color = _30k;
					else
						if (pf.Lod1Tricount > 5000f)
							_info.LOD1.color = _10k;
					else
						if (pf.Lod1Tricount > 3000f)
							_info.LOD1.color = _5k;
					else
						if (pf.Lod1Tricount > 1000f)
							_info.LOD1.color = _3k;
				}
				
				// Set under 1k values
				else
					if (pf.Lod1Tricount == 0f)
						_lodlevels = 1;
					else
				{
					_lod1 = (pf.Lod1Tricount).ToString();
					_info.LOD1.color = _1k;
				}

				/// SET VALUES FOR LOD 2
				// Change tricount up to 1k
				if ((pf.Lod2Tricount > 1000f) && (_lodlevels > 1))
				{
					_lod2 = (Mathf.RoundToInt(pf.Lod2Tricount/1000f)).ToString() + "k";
					
					// Change Text Color depending on triangle count
					if (pf.Lod2Tricount > 50000f)
						_info.LOD2.color = _more;
					else
						if (pf.Lod2Tricount > 30000f)
							_info.LOD2.color = _50k;
					else
						if (pf.Lod2Tricount > 10000f)
							_info.LOD2.color = _30k;
					else
						if (pf.Lod2Tricount > 5000f)
							_info.LOD2.color = _10k;
					else
						if (pf.Lod2Tricount > 3000f)
							_info.LOD2.color = _5k;
					else
						if (pf.Lod2Tricount > 1000f)
							_info.LOD2.color = _3k;
				}
				// Set under 1k values
				else
					if (pf.Lod2Tricount == 0f)
						_lodlevels = 2;
					else
					{
						_lod2 = (pf.Lod2Tricount).ToString();
						_info.LOD2.color = _1k;
					}

				// Check Values On Play DEBUG
				if (CheckOnUpdate)
				{
			//		Debug.Log("# " + pf.PrefabOrder + pf.Name + " has " + _lodlevels + " LOD Levels");
					if (_lodlevels == 3)
						Debug.Log("Prefab #" + pf.PrefabOrder + " " + pf.Name + " LOD Triangle Count: LOD0[" + _lod0 + "] - LOD1[" + _lod1 + "] - LOD2[" + _lod2 + "]");
					else
						if (_lodlevels == 2)
							Debug.Log("Prefab #" + pf.PrefabOrder + " " + pf.Name + " LOD Triangle Count: LOD0[" + _lod0 + "] - LOD1[" + _lod1 + "]");
						else
							if (_lodlevels == 1)
							Debug.Log("Prefab #" + pf.PrefabOrder + " " + pf.Name + " Mesh Triangle Count: [" + _lod0 + "]");
							else
								if (_lodlevels == 0)
									Debug.Log("Prefab #" + pf.PrefabOrder + " " + pf.Name + " has no mesh info alocated");
					if (pf.ReferenceGO == null)
						Debug.LogWarning("Reference object for PrefabTag#" + pf.PrefabOrder + " " + pf.Name + " has not been asigned.");
					if (pf.AssetPrefab == null)
						Debug.LogWarning("Asset Prefab for PrefabTag#" + pf.PrefabOrder + " " + pf.Name + " has not been asigned.");

				}

				// Set Values in TextMesh (WRITE LOD IN TEXT)
				_info.LOD0.text = _lod0;
				_info.LOD1.text = _lod1;
				_info.LOD2.text = _lod2;

				// Deactive unused LODs TextMesh
				if (_lodlevels <= 1)
					{
					_info.LOD0.gameObject.SetActive(true);
					_info.LOD1.gameObject.SetActive(false);
					_info.LOD2.gameObject.SetActive(false);
					}
				else
					if (_lodlevels == 2)
				{
					_info.LOD0.gameObject.SetActive(true);
					_info.LOD1.gameObject.SetActive(true);
					_info.LOD2.gameObject.SetActive(false);
				}
				else
					if (_lodlevels == 3)
				{
					_info.LOD0.gameObject.SetActive(true);
					_info.LOD1.gameObject.SetActive(true);
					_info.LOD2.gameObject.SetActive(true);
				}
				else
					if (_lodlevels == 0)
				{
					_info.LOD0.text = "Not Available";
					_info.LOD1.gameObject.SetActive(false);
					_info.LOD2.gameObject.SetActive(false);
				}
				
			}
		}
	}
	

	// Restore Original Values
	void Exit() {
		TagMaterial.color = _tagmat;
		GlowMaterial.color = _glowmat;
		IconMaterial.mainTexture = _oldicon;
	
	}
}
