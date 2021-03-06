                   0�      1�  �    #version 330 core
out vec4 fragColor;

in vec3 position;
in vec3 normal;
in vec2 uv0;
in vec2 uv1;
in vec4 vertexcolor;

uniform sampler2D Texture0;
uniform sampler2D Texture1;
uniform sampler2D Texture2;
uniform sampler2D Texture3;
uniform sampler2D Texture4;
uniform sampler2D Texture5;
uniform sampler2D Texture6;
uniform sampler2D Texture7;
uniform sampler2D Texture8;
uniform sampler2D Texture9;
uniform sampler2D Texture10;
uniform sampler2D Texture11;
uniform sampler2D Texture12;
uniform sampler2D Texture13;
uniform sampler2D Texture14;
uniform sampler2D Texture15;

void main()
{
    fragColor = texture(Texture0,uv1);
} #version 330 core
layout(location = 0) in vec3 iPosition;
layout(location = 1) in vec3 iNormal;
layout(location = 2) in vec2 iUV0;
layout(location = 3) in vec2 iUV1;
layout(location = 4) in vec4 VertexColor;
layout(location = 5) in vec4 iVertexWeight;
layout(location = 6) in ivec4 VertexWeightID;

layout(std140) uniform SceneBuffer
{
    mat4 CameraTransform;
};

layout(std140) uniform SkeletonBuffer
{
    mat4 NodeTransforms[300];
};

out vec3 position;
out vec3 normal;
out vec2 uv0;
out vec2 uv1;
out vec4 vertexcolor;

mat4 GetWeightedTransform()
{
    mat4 Out = mat4(0);

    for (int i = 0; i < 4; i++)
    {
        Out += NodeTransforms[VertexWeightID[i]] * iVertexWeight[i];
    }
    
    return Out;
};

vec3 TransformPoint(vec3 point,mat4 transform)
{
    return (transform * vec4(point,1)).xyz;
}

void main()
{
    mat4 Transform = GetWeightedTransform();

    position = TransformPoint(iPosition,Transform);
    normal  = iNormal;
    uv0 = iUV0;
    uv1  = iUV1;
    vertexcolor = VertexColor;

    mat4 dec = CameraTransform;

    gl_Position = vec4(position/15.0f,1);
} 