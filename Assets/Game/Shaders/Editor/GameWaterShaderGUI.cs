//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

using Nirvana.Editor;
using UnityEditor;
using UnityEngine;

/// <summary>
/// The custom editor for shader: "Game/Particle".
/// </summary>
public class GameWaterShaderGUI : NirvanaShaderGUI
{
    private MaterialProperty mainTex;
    private MaterialProperty normalMap;
    private MaterialProperty heightMap;

    private MaterialProperty waterSpeed;
    private MaterialProperty wavex1y1x2y2;
    private MaterialProperty waveSmallx1y1x2y2;

    private MaterialProperty waterColor1;
    private MaterialProperty waterColor2;

    private MaterialProperty ambianceColor;
    private MaterialProperty diffuseColor;
    private MaterialProperty specularColor;

    private MaterialProperty refractionDistort;
    private MaterialProperty refractionOpacity;

    private MaterialProperty reflection;
    private MaterialProperty reflectionSpace;
    private MaterialProperty reflectPower;

    /// <inheritdoc/>
    protected override void FindProperties(MaterialProperty[] props)
    {
        this.mainTex = ShaderGUI.FindProperty("_MainTex", props);
        this.normalMap = ShaderGUI.FindProperty("_NormalMap", props);
        this.heightMap = ShaderGUI.FindProperty("_HeightMap", props);

        this.waterSpeed = ShaderGUI.FindProperty("_WaterSpeed", props);
        this.wavex1y1x2y2 = ShaderGUI.FindProperty("_Wavex1y1x2y2", props);
        this.waveSmallx1y1x2y2 = ShaderGUI.FindProperty("_WaveSmallx1y1x2y2", props);

        this.waterColor1 = ShaderGUI.FindProperty("_WaterColor1", props);
        this.waterColor2 = ShaderGUI.FindProperty("_WaterColor2", props);

        this.ambianceColor = ShaderGUI.FindProperty("_AmbianceColor", props);
        this.diffuseColor = ShaderGUI.FindProperty("_DiffuseColor", props);
        this.specularColor = ShaderGUI.FindProperty("_SpecularColor", props);

        this.refractionDistort = ShaderGUI.FindProperty("_RefractionDistort", props);
        this.refractionOpacity = ShaderGUI.FindProperty("_RefractionOpacity", props);

        this.reflection = ShaderGUI.FindProperty("_Reflection", props);
        this.reflectionSpace = ShaderGUI.FindProperty("_ReflectionSpace", props);
        this.reflectPower = ShaderGUI.FindProperty("_ReflectPower", props);
    }

    /// <inheritdoc/>
    protected override void OnShaderGUI(
        MaterialEditor materialEditor, Material[] materials)
    {
        if (this.CheckOption(
            materials,
            "Enable Main",
            "ENABLE_MAIN"))
        {
            GUILayoutEx.BeginContents();
            materialEditor.TextureProperty(
                this.mainTex, this.mainTex.displayName);
            GUILayoutEx.EndContents();
        }

        if (this.CheckOption(
            materials,
            "Enable Normal",
            "ENABLE_NORMAL"))
        {
            GUILayoutEx.BeginContents();
            materialEditor.TextureProperty(
                this.normalMap, this.normalMap.displayName);
            GUILayoutEx.EndContents();
        }

        if (this.CheckOption(
            materials,
            "Enable Height",
            "ENABLE_HEIGHT"))
        {
            GUILayoutEx.BeginContents();
            materialEditor.TextureProperty(
                this.heightMap, this.heightMap.displayName);
            materialEditor.ColorProperty(
                this.waterColor1, this.waterColor1.displayName);
            materialEditor.ColorProperty(
                this.waterColor2, this.waterColor2.displayName);
            GUILayoutEx.EndContents();
        }

        if (this.HasKeyword(materials, "ENABLE_NORMAL") || 
            this.HasKeyword(materials, "ENABLE_HEIGHT"))
        {
            GUILayout.Label("Wave Parameter:");
            GUILayoutEx.BeginContents();
            materialEditor.VectorProperty(
                this.wavex1y1x2y2, 
                this.wavex1y1x2y2.displayName);
            materialEditor.VectorProperty(
                this.waveSmallx1y1x2y2, 
                this.waveSmallx1y1x2y2.displayName);

            if (this.CheckOption(
                materials,
                "Enable Wave Animation",
                "ENABLE_WAVE_ANIMATION"))
            {
                materialEditor.RangeProperty(
                    this.waterSpeed, this.waterSpeed.displayName);
            }

            GUILayoutEx.EndContents();
        }

        if (this.CheckOption(
            materials,
            "Enable Ambiance",
            "ENABLE_AMBIANCE"))
        {
            EditorGUI.indentLevel = 1;
            materialEditor.ColorProperty(
                this.ambianceColor, this.ambianceColor.displayName);
            EditorGUI.indentLevel = 0;
        }

        if (this.CheckOption(
            materials,
            "Enable Diffuse",
            "ENABLE_DIFFUSE"))
        {
            EditorGUI.indentLevel = 1;
            materialEditor.ColorProperty(
                this.diffuseColor, this.diffuseColor.displayName);
            EditorGUI.indentLevel = 0;
        }

        if (this.CheckOption(
            materials,
            "Enable Specular",
            "ENABLE_SPECULAR"))
        {
            EditorGUI.indentLevel = 1;
            materialEditor.ColorProperty(
                this.specularColor, this.specularColor.displayName);
            EditorGUI.indentLevel = 0;
        }

        if (this.CheckOption(
            materials,
            "Enable Refraction",
            "ENABLE_REFRACTION"))
        {
            EditorGUI.indentLevel = 1;
            materialEditor.RangeProperty(
                this.refractionDistort, this.refractionDistort.displayName);
            materialEditor.RangeProperty(
                this.refractionOpacity, this.refractionOpacity.displayName);
            EditorGUI.indentLevel = 0;
        }

        if (this.CheckOption(
            materials,
            "Enable Reflection",
            "ENABLE_REFLECTION"))
        {
            EditorGUI.indentLevel = 1;
            materialEditor.TexturePropertySingleLine(
                new GUIContent(this.reflection.displayName), this.reflection);
            materialEditor.RangeProperty(
                this.reflectionSpace, this.reflectionSpace.displayName);
            materialEditor.RangeProperty(
                this.reflectPower, this.reflectPower.displayName);
            EditorGUI.indentLevel = 0;
        }
    }
}
