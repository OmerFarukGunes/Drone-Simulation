using UnityEngine;
using System.Collections;

public class TagControl : MonoBehaviour {


	[Header("LookUp Settings")]
	public Color GlowColor = Color.white;
	public Color WaitColor = Color.cyan;
	public float WaitIntensity = 1f;
	public float SelectIntensity = 2f;
	public bool GlowFadeIn = true;
	public bool GlowFadeOut = true;
	public bool TrackCamera = true;
	public bool SmoothFollow = true;
	
	[Header("General Settings")]
	public bool WaitStartAnim = true;
	public float TimeDelay;
	public bool CheckOnUpdate;

	[Header("Source Variables")]
	public Animation TargetAnimation;
	public AnimationClip StartAnim;
	public AnimationClip EndAnim;
	public Renderer GlowMesh1;
	public Renderer GlowMesh2;
	public Material MaterialGlow1;
	public Material MaterialGlow2;
	public GameObject EnabledParts;
	public Collider TargetCollider;
	public Collider PlayerCollider;


	// Private variables

	private float timer;
	private float timerstart;
	private Material mat1;
	private Material mat2;
	private bool colliding = false;
	private bool waiting = false;
	private bool ready = false;
	private float glowint;
	private Quaternion rotor;


	void Start ()
	{
		// Get values
		mat1 = GlowMesh1.material;
		mat2 = GlowMesh2.material;
		rotor = gameObject.transform.rotation;
		EnabledParts.SetActive (false);
		// Set values
		MaterialGlow2.SetColor("_EmissionColor", (WaitColor*WaitIntensity));
	}

	void	OnTriggerEnter(Collider col)
	{
		//// ACTIVATE OBJECT
		// Check collision with camera or player
		if(col.GetComponent<Collider>() == PlayerCollider) 
		{
			GlowMesh2.material = MaterialGlow2;

			if (!waiting)
			{
			// Restart to false your waiting check
			waiting = true;
			colliding = true;
			timer = 0f;

			// Check on player enter
			if (CheckOnUpdate)
			Debug.Log(PlayerCollider.gameObject.name + " has entered the " + TargetCollider.gameObject.name + " area.");

			// Start animation
				TargetAnimation.Play(StartAnim.name);

			// Change material
			GlowMesh1.material = MaterialGlow1;

			// Change glow color if required
			if (!GlowFadeIn)
				MaterialGlow2.SetColor("_EmissionColor", (GlowColor*SelectIntensity));
			}
			else
			{
				// Restart to false your waiting check
				waiting = true;
				colliding = true;
				timer = 0f;
			}
		}
	}

	// Check if player left the area
	void	OnTriggerExit(Collider col)
	{ 
		if (col == PlayerCollider) {
			colliding = false;
			ready = false;
			timerstart = 0f;
			timer = 0f;
		}
	}

	void Update ()
	{
		//// CLOSE OBJECT
		// Check if collision is active and is waiting for exit delay
		if (!colliding && waiting)

		{
		// Track time
			timer = timer + Time.deltaTime;

		// Keep time tracking DEBUG
			if (CheckOnUpdate)
			{
				if (timer < TimeDelay)
					Debug.Log("["+ (TimeDelay - timer) + "] Seconds Delay Left");
				else
					Debug.Log("["+ (TimeDelay + EndAnim.length - timer) + "] ExitAnim Left");
			}
		// Start End Animation
			if (timer > TimeDelay)
			{
				TargetAnimation.Play(EndAnim.name);
		// Warn animation start DEBUG
				if (CheckOnUpdate)
					Debug.Log(gameObject.name + "is playing "+ EndAnim.name + " animation clip");
			}
		// FADE OUT GLOW
			if ((GlowFadeOut) && (timer < TimeDelay))
			{
				glowint = ((TimeDelay-timer)/TimeDelay);
				MaterialGlow2.SetColor("_EmissionColor", (GlowColor*(SelectIntensity*glowint)));
		// Check GlowInt DEBUG
				if (CheckOnUpdate)
					Debug.Log( MaterialGlow2.name + " HDR:[" + (SelectIntensity*glowint) + "], glowint value:[" + glowint + "], time:[" + (timer) + "]");
			}

		}


			if (timer > (TimeDelay+EndAnim.length))
			{
				// Back original material
				GlowMesh1.material = mat1;
				
				// Activate End Timer
				waiting = false;
				ready = false;
				timer = 0f;
				// Check player is out DEBUG
				if (CheckOnUpdate)
				Debug.Log(PlayerCollider.gameObject.name + " has left the " + TargetCollider.GetComponent<Collider>().name + " area.");
				// Disable Parts
				EnabledParts.gameObject.SetActive(false);
				// Reset Glow values
				MaterialGlow2.SetColor("_EmissionColor", (WaitColor*WaitIntensity));
				GlowMesh2.material = mat2;
				glowint = 0f;
			}


		//// WAIT DELAY AT START
		if (WaitStartAnim)
		{
			// Wait While StartAnim
			if (colliding && (!ready))
			{
				timerstart = timerstart + Time.deltaTime;
				if (timerstart > StartAnim.length)
					ready = true;
				// Update Glow Materials
				if (GlowFadeIn)
				{
					glowint = (timerstart / StartAnim.length);
					MaterialGlow2.SetColor("_EmissionColor", (GlowColor*(SelectIntensity*glowint)));
				}
				// Keep time tracking DEBUG
				if (CheckOnUpdate)
				Debug.Log ((StartAnim.length - timerstart) + " seconds to go");
			}
			// Enable Parts
			if (ready)
			{
				EnabledParts.gameObject.SetActive(true);
				timerstart = 0f;
			}
		}
		else
			EnabledParts.gameObject.SetActive(true);

		// FollowCamera

		if ((TrackCamera) && (glowint > 0)) {
			gameObject.transform.LookAt (PlayerCollider.gameObject.transform.position);
			if (glowint >= 1)
				gameObject.transform.eulerAngles = new Vector3 (0f, gameObject.transform.eulerAngles.y, 0f);
			else {
				if (SmoothFollow)
					gameObject.transform.eulerAngles = new Vector3 (0f, ((gameObject.transform.eulerAngles.y * glowint) + (rotor.eulerAngles.y * (1f - glowint))), 0f);
				else
					gameObject.transform.eulerAngles = new Vector3 (0f, gameObject.transform.eulerAngles.y, 0f);
			}

		} else
			gameObject.transform.rotation = rotor;
	}
}
