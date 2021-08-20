//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

using Nirvana.Editor;
using UnityEditor;
using UnityEngine;

/// <summary>
/// The custom editor for shader: "Game/Terrain".
/// </summary>
public class GameTerrain3ShaderGUI : NirvanaShaderGUI
{
    private MaterialProperty mainColor;

    private MaterialProperty splat0;
    private MaterialProperty splat1;
    private MaterialProperty splat2;
    private MaterialProperty control;

    private MaterialProperty specularPower;
    private MaterialProperty specularIntensity;
    private MaterialProperty specularColor;

    private MaterialProperty reflectionOpacity;
    private MaterialProperty reflectionIntensity;
    private MaterialProperty reflectionFresnel;
    private MaterialProperty reflectionMetallic;

    /// <inheritdoc/>
    protected override void FindProperties(MaterialProperty[] props)
    {
        this.mainColor = ShaderGUI.FindProperty("_MainColor", props);

        this.splat0 = ShaderGUI.FindProperty("_Splat0", props);
        this.splat1 = ShaderGUI.FindProperty("_Splat1", props);
        this.splat2 = ShaderGUI.FindProperty("_Splat2", props);
        this.control = ShaderGUI.FindProperty("_Control", props);

        this.specularPower = ShaderGUI.FindProperty("_SpecularPower", props);
        this.specularIntensity = ShaderGUI.FindProperty("_SpecularIntensity", props);
        this.specularColor = ShaderGUI.FindProperty("_SpecularColor", props);

        this.reflectionOpacity = ShaderGUI.FindProperty("_ReflectionOpacity", props);
        this.reflectionIntensity = ShaderGUI.FindProperty("_ReflectionIntensity", props);
        this.reflectionFresnel = ShaderGUI.FindProperty("_ReflectionFresnel", props);
        this.reflectionMetallic = ShaderGUI.FindProperty("_ReflectionMetallic", props);
    }

    /// <inheritdoc/>
    protected override void OnShaderGUI(
        MaterialEditor materialEditor, Material[] materials)
    {
        this.ColorGUI(materialEditor, materials);
        this.ReflectionGUI(materialEditor, materials);
    }

    private void ColorGUI(
        MaterialEditor materialEditor, Material[] materials)
    {
        if (this.CheckOption(
                materials,
                "Enable Main Color",
                "ENABLE_MAIN_COLOR"))
        {
            EditorGUI.indentLevel = 1;
            materialEditor.ColorProperty(this.mainColor, "Main Color");
            EditorGUI.indentLevel = 0;
        }

        materialEditor.TextureProperty(this.splat0, "Layer 0");
        materialEditor.TextureProperty(this.splat1, "Layer 1");
        materialEditor.TextureProperty(this.splat2, "Layer 2");
        materialEditor.TextureProperty(this.control, "Control");

        if (this.CheckOption(
                materials,
                "Enable Specular",
                "ENABLE_SEPCULAR"))
        {
            EditorGUI.indentLevel = 1;

            materialEditor.FloatProperty(this.specularPower, "Specular Power");
            materialEditor.FloatProperty(this.specularIntensity, "Specular Intensity");
            materialEditor.ColorProperty(this.specularColor, "Specular Color");

            EditorGUI.indentLevel = 0;
        }
    }

    private void ReflectionGUI(
        MaterialEditor materialEditor, Material[] materials)
    {
        if (this.CheckOption(
            materials,
            "Enable Reflection",
            "ENABLE_REFLECTION"))
        {
            EditorGUI.indentLevel = 1;

            materialEditor.RangeProperty(this.reflectionOpacity, "Opacity");
            materialEditor.RangeProperty(this.reflectionIntensity, "Intensity");
            materialEditor.RangeProperty(this.reflectionFresnel, "Fresnel");
            materialEditor.RangeProperty(this.reflectionMetallic, "Metallic");

            EditorGUI.indentLevel = 0;
        }
    }
}
