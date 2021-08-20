﻿using UnityEngine;
using UnityEditor;
using Nirvana;
using System.Text;

namespace AssetsCheck
{
    class UIEffectAttachChecker : BaseChecker
    {
        // 指定要检查的文件夹
        private string[] checkDirs = { "Assets/Game/UIs/Views" };

        // 获得错误描述
        override public string GetErrorDesc()
        {
            return "UI上使用粒子特效必须使用GameObjectAttach实现";
        }

        override protected void OnCheck()
        {
            string[] guids = AssetDatabase.FindAssets("t:prefab", checkDirs);
            foreach (var guid in guids)
            {
                string path = AssetDatabase.GUIDToAssetPath(guid);
                GameObject gameobj = AssetDatabase.LoadAssetAtPath<GameObject>(path);
                ParticleSystem[] particle_systems = gameobj.GetComponentsInChildren<ParticleSystem>(true);
                for (int i = 0; i < particle_systems.Length; i++)
                {
                    if (!this.HasAttacherInParent(particle_systems[i].transform))
                    {
                        CheckItem item = new CheckItem();
                        item.asset = path;
                        this.outputList.Add(item);
                    }
                }
            }
        }

        private bool HasAttacherInParent(Transform transform)
        {
            Transform temp_transform = transform.parent;

            while(temp_transform)
            {
                if (null != temp_transform.GetComponent<Game.GameObjectAttach>())
                {
                    return true;
                }

                temp_transform = temp_transform.parent;
            }

            return false;
        }

        struct CheckItem : ICheckItem
        {
            public string asset;
            public int width;
            public int height;

            public string MainKey
            {
                get { return string.Format("{0}", asset); }
            }

            public StringBuilder Output()
            {
                StringBuilder builder = new StringBuilder();
                builder.Append(this.asset);
                return builder;
            }
        }
    }
}
