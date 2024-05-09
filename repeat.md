# 使用 shader 实现重复图案

## 前言

之前，我们通过内置函数——`fract`实现过一些简单的重复图案。今天我们来尝试写一些其他的重复图案。话不多说，直接开始吧。

## 条纹

### 生成一条线

```
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
	vec2 uv=fragCoord/iResolution.xy;
    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;
    //线
    vec3 c=vec3(step(.5,uv.x));
    fragColor=vec4(c,1.);
}
```

[图片]
我们可以看到，uv.x 大于 0.5 的地方是白色的，小于 0.5 的地方是黑色的。这看起来，就像是一条白色的线一样。

### 重复这条线

我们可以利用`fract`函数重复 uv ，来达到我们想要的效果。

```
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
	vec2 uv=fragCoord/iResolution.xy;
    uv=fract(uv*16.);
    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;
    //线
    vec3 c=vec3(step(.5,uv.x));
    fragColor=vec4(c,1.);
}

```

[图片]

## 波浪

### 生成 y 轴的条纹

```
    vec2 uv=fragCoord/iResolution.xy;
    uv=fract(uv*16.);
    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;
    //y轴
    vec3 c=vec3(step(.5,uv.y));
    fragColor=vec4(c,1.);
```

[图片]

### 让条纹变得弯曲——即有规律的重复的改变 y 轴坐标

`sin 函数或者 cos 函数`能够帮助我们得到规律的波纹。
注意：`我们需要在 fract 函数调用之前使用 sin 或者 cos 改变 uv.y 的坐标。`

```
 //波浪

    vec2 uv=fragCoord/iResolution.xy;
    uv.y+=sin(uv.x*6.)*.4;;
    uv=fract(uv*16.);

    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;

    vec3 c=vec3(step(.5,uv.y));
    fragColor=vec4(c,1.);

```

[图片]

## 网格

### 生成横向的条纹

```
    vec2 uv=fragCoord/iResolution.xy;
    uv=fract(uv*16.);

    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;

    vec3 c=vec3(step(.5,uv.x));
    fragColor=vec4(c,1.);

```

### 生成竖向的网格

```
    vec2 uv=fragCoord/iResolution.xy;
    uv=fract(uv*16.);

    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;

    vec3 c=vec3(step(.5,uv.y));
    fragColor=vec4(c,1.);

```

### 将横向竖向组合起来

利用`opUnion`将横向竖向组合起来。

```
    vec2 uv=fragCoord/iResolution.xy;
    uv=fract(uv*16.);

    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;

    vec3 c=vec3(opUnion(step(.5,uv.y),step(.5,uv.x)));
    fragColor=vec4(c,1.);

```

[图片]

## 波纹

### 先画一个圆

```
    vec2 uv=fragCoord/iResolution.xy;
    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;
    float d=sdCircle(uv,.5);
    float mask=smoothstep(0.,.02,d);
    vec3 c=vec3(mask);
    fragColor=vec4(c,1.);

```

### 利用 sin 或者 cos 函数达到重复的效果

```
    vec2 uv=fragCoord/iResolution.xy;
    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;
    float d=sdCircle(uv,.5);
    //利用sin函数的重复特征得到波纹效果
    d=sin(d*40.);
    float mask=smoothstep(0.,.02,d);
    vec3 c=vec3(mask);
    fragColor=vec4(c,1.);

```

[图片]

## 总结

我们还可以利用不同的函数做出很多不同的效果。如有兴趣，下来可以深入研究。上文如有错误之处，欢迎大家留言指出。谢谢大家了。
