//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------


using System;
using Nirvana.Editor;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

/// <summary>
/// The custom editor for shader: "Game/Standard".
/// </summary>
public class GameStandardShaderGUI : NirvanaShaderGUI
{
    private static readonly string[] BlendNames =
        Enum.GetNames(typeof(RenderingMode));

    private MaterialProperty renderingMode;
    private MaterialProperty cutoff;
	private MaterialProperty cullMode;
    private MaterialProperty alpha;

    private MaterialProperty mainTex;
    private MaterialProperty mainColor;
    private MaterialProperty emissionColor;

    private MaterialProperty normalTex;

    private MaterialProperty flowTex;
    private MaterialProperty flowSpeed;
    private MaterialProperty flowColor;

    private MaterialProperty specularPower;
    private MaterialProperty specularIntensity;
    private MaterialProperty specularColor;

    private MaterialProperty reflectionOpacity;
    private MaterialProperty reflectionIntensity;
    private MaterialProperty reflectionFresnel;
    private MaterialProperty reflectionMetallic;

    // private MaterialProperty maskControlTex;

    private MaterialProperty rimColor;
    private MaterialProperty rimIntensity;
    private MaterialProperty rimFresnel;

    private MaterialProperty rimLightColor;
    private MaterialProperty rimLightIntensity;
    private MaterialProperty rimLightFresnel;

    private bool specularEnabled;
    private bool reflectionEnabled;

    /// <summary>
    /// The rendering mode enumeration.
    /// </summary>
    private enum RenderingMode
    {
        /// <summary>
        /// Render the opaque solid object.
        /// </summary>
        Opaque,

        /// <summary>
        /// The transparent object without semi-transparent areas.
        /// </summary>
        // Cutout,

        /// <summary>
        /// The soft edge material for transparent.
        /// </summary>
        SoftEdge,

        /// <summary>
        /// The transparent object like glass, the diffuse color will fade out
        /// but the specular will maintain.
        /// </summary>
        Transparent,

        /// <summary>
        /// Totally fade out an object, include diffuse and specular, make it
        /// completely fade out.
        /// </summary>
        Fade,

        RoleTransparent,
    }

    /// <inheritdoc/>
    protected override void FindProperties(MaterialProperty[] props)
    {
        this.renderingMode = ShaderGUI.FindProperty("_RenderingMode", props);
		this.cullMode = ShaderGUI.FindProperty("_CullMode", props);
        this.cutoff = ShaderGUI.FindProperty("_Cutoff", props);
        this.alpha = ShaderGUI.FindProperty("_Alpha", props);

        this.mainTex = ShaderGUI.FindProperty("_MainTex", props);
        this.mainColor = ShaderGUI.FindProperty("_MainColor", props);
        this.emissionColor = ShaderGUI.FindProperty("_EmissionColor", props);

        this.normalTex = ShaderGUI.FindProperty("_NormalTex", props);

        this.flowTex = ShaderGUI.FindProperty("_FlowTex", props);
        this.flowSpeed = ShaderGUI.FindProperty("_FlowSpeed", props);
        this.flowColor = ShaderGUI.FindProperty("_FlowColor", props);

        this.specularPower = ShaderGUI.FindProperty("_SpecularPower", props);
        this.specularIntensity = ShaderGUI.FindProperty("_SpecularIntensity", props);
        this.specularColor = ShaderGUI.FindProperty("_SpecularColor", props);

        this.reflectionOpacity = ShaderGUI.FindProperty("_ReflectionOpacity", props);
        this.reflectionIntensity = ShaderGUI.FindProperty("_ReflectionIntensity", props);
        this.reflectionFresnel = ShaderGUI.FindProperty("_ReflectionFresnel", props);
        this.reflectionMetallic = ShaderGUI.FindProperty("_ReflectionMetallic", props);

        /*this.maskControlTex = ShaderGUI.FindProperty("_MaskControlTex", props);*/

        this.rimColor = ShaderGUI.FindProperty("_RimColor", props);
        this.rimIntensity = ShaderGUI.FindProperty("_RimIntensity", props);
        this.rimFresnel = ShaderGUI.FindProperty("_RimFresnel", props);


        this.rimLightColor = ShaderGUI.FindProperty("_RimLightColor", props);
        this.rimLightIntensity = ShaderGUI.FindProperty("_RimLightIntensity", props);
        this.rimLightFresnel = ShaderGUI.FindProperty("_RimLightFresnel", props);
    }

    /// <inheritdoc/>
    protected override void OnShaderGUI(
        MaterialEditor materialEditor, Material[] materials)
    {

        this.BlendModeGUI(materialEditor, materials);
        this.ColorGUI(materialEditor, materials);
        this.NormalGUI(materialEditor, materials);
        this.FlowGUI(materialEditor, materials);
        this.ReflectionGUI(materialEditor, materials);
        this.AlphaMetallicGUI(materialEditor, materials);
        // this.MaskControlGUI(materialEditor, materials);
        this.RimGUI(materialEditor, materials);
    }

    /// <inheritdoc/>
    /*protected override void MaterialChanged(Material material)
    {
        if (this.renderingMode != null)
        {
            var renderingMode = (RenderingMode)this.renderingMode.floatValue;
            this.UpdateRenderingMode(renderingMode, material);
        }
    }*/

    private void UpdateRenderingMode(
        RenderingMode renderingMode, Material material)
    {
        switch (renderingMode)
        {
        case RenderingMode.Opaque:
            material.SetInt("_SrcBlend", (int)BlendMode.One);
            material.SetInt("_DstBlend", (int)BlendMode.Zero);
            material.SetInt("_ZWrite", 1);
            material.DisableKeyword("_ALPHA_TEST");
            material.DisableKeyword("_ALPHA_BLEND");
            material.DisableKeyword("_ALPHA_PREMULTIPLY");
            material.SetOverrideTag("RenderType", "Opaque");
            material.renderQueue = -1;
            break;
        /*case RenderingMode.Cutout:
            material.SetInt("_SrcBlend", (int)BlendMode.One);
            material.SetInt("_DstBlend", (int)BlendMode.Zero);
            material.SetInt("_ZWrite", 1);
            material.EnableKeyword("_ALPHA_TEST");
            material.DisableKeyword("_ALPHA_BLEND");
            material.DisableKeyword("_ALPHA_PREMULTIPLY");
            material.SetOverrideTag("RenderType", "TransparentCutout");
            material.renderQueue = -1;
            break;*/
        case RenderingMode.SoftEdge:
            material.SetInt("_SrcBlend", (int)BlendMode.SrcAlpha);
            material.SetInt("_DstBlend", (int)BlendMode.OneMinusSrcAlpha);
            material.SetInt("_ZWrite", 1);
            material.EnableKeyword("_ALPHA_TEST");
            material.EnableKeyword("_ALPHA_BLEND");
            material.DisableKeyword("_ALPHA_PREMULTIPLY");
            material.SetOverrideTag("RenderType", "TransparentCutout");
            material.renderQueue = 2500;
            break;
        case RenderingMode.Transparent:
            material.SetInt("_SrcBlend", (int)BlendMode.One);
            material.SetInt("_DstBlend", (int)BlendMode.OneMinusSrcAlpha);
            material.SetInt("_ZWrite", 1);
            material.DisableKeyword("_ALPHA_TEST");
            material.DisableKeyword("_ALPHA_BLEND");
            material.EnableKeyword("_ALPHA_PREMULTIPLY");
            material.SetOverrideTag("RenderType", "Transparent");
            material.renderQueue = 3000;
            break;
        case RenderingMode.Fade:
            material.SetInt("_SrcBlend", (int)BlendMode.SrcAlpha);
            material.SetInt("_DstBlend", (int)BlendMode.OneMinusSrcAlpha);
            material.SetInt("_ZWrite", 0);
            material.DisableKeyword("_ALPHA_TEST");
            material.EnableKeyword("_ALPHA_BLEND");
            material.DisableKeyword("_ALPHA_PREMULTIPLY");
            material.SetOverrideTag("RenderType", "Transparent");
            material.renderQueue = 3000;
            break;
        case RenderingMode.RoleTransparent:
            material.SetInt("_SrcBlend", (int)BlendMode.SrcAlpha);
            material.SetInt("_DstBlend", (int)BlendMode.OneMinusSrcAlpha);
            material.SetInt("_ZWrite", 1);
            material.DisableKeyword("_ALPHA_TEST");
            material.EnableKeyword("_ALPHA_BLEND");
            material.DisableKeyword("_ALPHA_PREMULTIPLY");
            material.SetOverrideTag("RenderType", "Transparent");
            material.renderQueue = 2005;
            break;
        }
    }

    private void BlendModeGUI(
        MaterialEditor materialEditor, Material[] materials)
    {
        EditorGUI.showMixedValue = this.renderingMode.hasMixedValue;
        var renderingMode = (RenderingMode)this.renderingMode.floatValue;
        EditorGUI.BeginChangeCheck();
        renderingMode = (RenderingMode)EditorGUILayout.Popup(
            "Rendering Mode", (int)renderingMode, BlendNames);
        if (EditorGUI.EndChangeCheck())
        {
            materialEditor.RegisterPropertyChangeUndo("Rendering Mode");
            this.renderingMode.floatValue = (float)renderingMode;
            foreach (var mat in materials)
            {
                this.UpdateRenderingMode(renderingMode, mat);
            }
        }

        EditorGUI.showMixedValue = false;

        if (renderingMode != RenderingMode.Opaque && 
            renderingMode != RenderingMode.Transparent && 
            renderingMode != RenderingMode.Fade &&
            renderingMode != RenderingMode.RoleTransparent)
        {
            materialEditor.RangeProperty(this.cutoff, "Cutoff");
        }

        if (renderingMode == RenderingMode.RoleTransparent)
        {
            materialEditor.RangeProperty(this.alpha, "Alpha");
        }
        else
        {
            this.alpha.floatValue = 0f;
        }

        EditorGUI.BeginChangeCheck();

		int cullMode = (int)this.cullMode.floatValue;
		var cullEnum = (CullMode)EditorGUILayout.EnumPopup(
			"Cull Mode", (CullMode)cullMode);

		if (EditorGUI.EndChangeCheck())
		{
			this.cullMode.floatValue = (float)cullEnum;
		}
    }

    private void ColorGUI(
        MaterialEditor materialEditor, Material[] materials)
    {
        materialEditor.TextureProperty(this.mainTex, "Main Texture");
        materialEditor.ColorProperty(this.mainColor, "Main Color");

        /*if (this.CheckOption(
                materials,
                "Enable Main Color",
                "ENABLE_MAIN_COLOR"))
        {
            EditorGUI.indentLevel = 1;
            materialEditor.ColorProperty(this.mainColor, "Main Color");
            EditorGUI.indentLevel = 0;
        }*/

        /*if (this.CheckOption(
                materials,
                "Enable Emission",
                "ENABLE_EMISSION"))
        {
            EditorGUI.indentLevel = 1;
            materialEditor.ColorProperty(this.emissionColor, "Emission Color");
            if (this.mainTex.textureValue != null)
            {
                this.CheckOption(
                    materials,
                    "Alpha Control",
                    "ENABLE_EMISSION_ALPHA_CONTROL");
            }

            EditorGUI.indentLevel = 0;
        }*/

        var specularOptions = new GUIContent[] {
            new GUIContent("No Specular"),
            new GUIContent("Specular"),
            // new GUIContent("Specular Dir")
        };
        var specularKeys = new string[] {
            "_",
            "ENABLE_SEPCULAR",
            // "ENABLE_SEPCULAR_DIR"
        };

        if (this.ListOptions(materials, specularOptions, specularKeys) > 0)
        {
            this.specularEnabled = true;
            EditorGUI.indentLevel = 1;

            materialEditor.FloatProperty(
                this.specularPower, "Specular Power");
            materialEditor.FloatProperty(
                this.specularIntensity, "Specular Intensity");
            materialEditor.ColorProperty(
                this.specularColor, "Specular Color");

            EditorGUI.indentLevel = 0;
        }
        else
        {
            this.specularEnabled = false;
        }
    }

    private void NormalGUI(MaterialEditor materialEditor, Material[] materials)
    {
        if(this.CheckOption(
            materials,
            "Enable Normal",
            "ENABLE_NORMAL"))
        {
            materialEditor.TextureProperty(this.normalTex, "Normal");
        }
        else
        {
            this.normalTex.textureValue = null;
        }
    }

    private void FlowGUI(MaterialEditor materialEditor, Material[] materials)
    {
        var options = new GUIContent[] {
            new GUIContent("None"),
            new GUIContent("ADD"),
            new GUIContent("MUL"),
        };
        var keys = new string[] {
            "_",
            "ENABLE_FLOW_ADD",
            "ENABLE_FLOW_MUL",
        };
        var index = this.ListOptions(materials, options, keys);
        if (index > 0)
        {
            EditorGUI.indentLevel = 1;
            materialEditor.TextureProperty(this.flowTex, "Flow Texture", false);
            materialEditor.VectorProperty(this.flowSpeed, "Flow Speed & Tile");
            materialEditor.ColorProperty(this.flowColor, "Flow Color");
            this.CheckOption(materials, "Smooth Flow", "ENABLE_FLOW_SMOOTH");

            EditorGUI.indentLevel = 0;
        }
        else
        {
            this.flowTex.textureValue = null;
            this.DisableKeyword(materials, "ENABLE_FLOW_SMOOTH");
        }
    }

    private void ReflectionGUI(
        MaterialEditor materialEditor, Material[] materials)
    {
        this.reflectionEnabled = this.CheckOption(
            materials,
            "Enable Reflection",
            "ENABLE_REFLECTION");

        if (!this.reflectionEnabled)
        {
            return;
        }

        EditorGUI.indentLevel = 1;

        materialEditor.RangeProperty(this.reflectionOpacity, "Opacity");
        materialEditor.RangeProperty(this.reflectionIntensity, "Intensity");
        materialEditor.RangeProperty(this.reflectionFresnel, "Fresnel");
        materialEditor.RangeProperty(this.reflectionMetallic, "Metallic");

        EditorGUI.indentLevel = 0;
    }

    private void AlphaMetallicGUI(
        MaterialEditor materialEditor, Material[] materials)
    {
        const string DEFINE = "ALPHA_IS_METALLIC";

        this.CheckOption(
            materials,
            "Alpha Is Metallic",
            DEFINE);
    }

    /*private void MaskControlGUI(
        MaterialEditor materialEditor, Material[] materials)
    {
        if (!this.CheckOption(
                materials,
                "Enable Mask Control",
                "ENABLE_MASK_CONTROL"))
        {
            return;
        }

        EditorGUI.indentLevel = 1;
        materialEditor.TextureProperty(this.maskControlTex, "Mask Control Tex");
        EditorGUI.indentLevel = 0;
    }*/

    private bool AlphaMetallicPreCheck()
    {
        if (this.specularEnabled)
        {
            return true;
        }

        if (this.reflectionEnabled)
        {
            return true;
        }

        return false;
    }

    private void RimGUI(
        MaterialEditor materialEditor, Material[] materials)
    {
        if (this.CheckOption(
                materials,
                "Enable Rim",
                "ENABLE_RIM"))
        {
            EditorGUI.indentLevel = 1;
            materialEditor.ColorProperty(this.rimColor, "Color");
            materialEditor.RangeProperty(this.rimIntensity, "Intensity");
            materialEditor.RangeProperty(this.rimFresnel, "Fresnel");
            EditorGUI.indentLevel = 0;
        }

        if (this.CheckOption(
                materials,
                "Enable Rim Light",
                "ENABLE_RIM_LIGHT"))
        {
            EditorGUI.indentLevel = 1;
            materialEditor.ColorProperty(this.rimLightColor, "Color");
            materialEditor.RangeProperty(this.rimLightIntensity, "Intensity");
            materialEditor.RangeProperty(this.rimLightFresnel, "Fresnel");
            EditorGUI.indentLevel = 0;
        }
    }

    private void DisableKeyword(Material[] materials, string keyword)
    {
        foreach (var mat in materials)
        {
            mat.DisableKeyword(keyword);
        }
    }
}

