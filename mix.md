# 使用 shader 内置函数 mix 给图案上色

## 前言

之前，我们使用 shader 画的图形都是黑白配色的，太单调了。今天，我们来使用内置函数——`mix`来给我们的图案上色。话不多说，直接开始吧。

## mix 函数介绍

mix(x,y,t):

- x：颜色 1
- y: 颜色 2
- t: 混合度，，如果 t 为 0，则值就等于 x；如果 t 为 1，则值就等于 y，如果 t 为 0 到 1 内的值，则值就等于 x 与 y 之间逐渐变化的值。

### 使用 mix 创建渐变色

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    // 渐变色
    vec3 col1=vec3(1.,0.,0.);
    vec3 col2=vec3(0.,1.,0.);
    vec3 col=mix(col1,col2,uv.x);
    fragColor=vec4(col,1.);
}

```

[图片]

我们可以看到，根据 uv 变换，我们得到了一个红色到绿色的渐变色。

### 使用 mix 给图案上色

这里的图案，我们采用之前的五角星和月亮

1. 给图案统一上色

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;

    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;

    float d1 = sdStar( uv, 0.6, int(5.), 3.);
    float d2 = sdMoon( uv, 0.2, 0.8, 0.7 );
    float d=opUnion(d1,d2);

    float c=smoothstep(0.,.02,d);
    vec3 colInner=vec3(1.,0.,0.);
    vec3 colOuter=vec3(1.);
    vec3 col=mix(colInner,colOuter,c);
    fragColor=vec4(col,1.);

}
```

[图片]

2. 有多个图案时，每个图案对应不同的颜色

```
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord/iResolution.xy;
    uv = (uv - 0.5) * 2.0;

    // SDFs
    float d1 = sdStar(uv, 0.6, 5, 3.0);
    float d2 = sdMoon(uv, 0.2, 0.8, 0.7);

    // Check if the current pixel is inside the star or the moon
    if (d1 < 0.02) // Inside the star
    {
        fragColor = vec4(1.0, 0.0, 0.0, 1.0); // Red color for the star
    }
    else if (d2 < 0.02) // Inside the moon
    {
         fragColor = vec4(0.0, 0.0, 1.0, 1.0); // Blue color for the moon
    }
    else // Outside both the star and the moon
    {
    fragColor = vec4(0.0, 0.0, 0.0, 1.0); // Black color for the background
    }
}

```

[图片]

### 利用 mix 函数实现图形变换效果

```

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;

    // 图形变换
    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;

    // float d1=sdCircle(uv,.5);
    // float d2=sdBox(uv,vec2(.6,.3));
    float d1 = sdStar( uv, 0.6, int(5.), 3.);
    float d2 = sdCircle( uv, 0.8);
    float d=mix(d1,d2,abs(cos(iTime)));
    float c=smoothstep(0.,.02,d);
    fragColor=vec4(vec3(c),1.);
}

```

[图片]

## 总结

以上便是今天 shader 内置函数的介绍，以及一些小效果的实现。如有错误之处，欢迎大家浏览指出。谢谢大家了。
