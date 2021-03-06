﻿using OpenTK.Graphics.OpenGL;
using SimpleGameEngine.Graphics.Assets;
using SimpleGameEngine.IO;
using System;

namespace SimpleGameEngine.Graphics
{
    public class UBOTrash : Garbage
    {
        public int UBO;

        public override void Dispose()
        {
            GL.DeleteBuffer(UBO);
        }
    }

    public unsafe class UniformBufferObject 
    {
        public string Name { get; private set; }
        public byte[] Data { get; set; }
        public int Handler { get; private set; } = -1;
        public bool SetUp => Handler != -1;
        public byte* Location => CrossFileReader.GetArrayPointer(Data);
        public UniformBufferObject(string name,int Size)
        {
            Name = name;
            Data = new byte[Size];
        }

        public void GenBuffer()
        {
            Handler = GL.GenBuffer();
        }

        public void UpdateBuffer()
        {
            if (!SetUp)
            {
                GenBuffer();
            }

            GL.BindBuffer(BufferTarget.UniformBuffer, Handler);
            GL.BufferData(BufferTarget.UniformBuffer, Data.Length, Data, BufferUsageHint.StaticDraw);
        }

        public void BindToMaterial(RenderMaterial material)
        {
            if (material == null)
                return;

            if (material.RenderShader == null)
                return;

            int blockindex = material.GetUniformBlockIndex(Name);

            if (blockindex == -1)
                return;

            GL.BindBufferBase(BufferRangeTarget.UniformBuffer, blockindex, Handler);
            GL.UniformBlockBinding(material.RenderShader.Handler,blockindex, blockindex);
        }

        ~UniformBufferObject()
        {
            if (Window.Active && Handler != -1)
            {
                new UBOTrash()
                {
                    UBO = Handler
                };
            }
        }
    }
}
