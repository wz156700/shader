# 利用 shader 极坐标生成图案

## 前言

目前我们 Shader 的默认坐标系是笛卡尔坐标系（也就是直角坐标系），除了这种坐标系外，还有另一种坐标系，叫做极坐标系，用这种坐标系能够画出一些基于圆的图案来。话不多说，直接开始吧。

## 什么是极坐标系

[图片]

如图所示，极坐标系的坐标由 2 个维度组成：极角 φ 和半径 r。

- 第一个维度极角 φ，用 atan 函数计算直角坐标的反正切值即可算出。`float phi=atan(uv.y,uv.x);`
- 第二个维度半径 r，用 length 函数计算直角坐标到原点的距离即可算出。 `float r=length(uv);`

将转换后的结果赋给 uv:

```
uv=vec2(phi,r);
fragColor=vec4(uv,0.,1.);

```

完整代码：

```
    vec2 uv=fragCoord/iResolution.xy;
    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;
    float phi=atan(uv.y,uv.x);
    float r=length(uv);
    uv=vec2(phi,r);
    fragColor=vec4(uv,0.,1.);
```

[图片]

## 利用极坐标系生成放射性光线

直接使用`sin`函数即可

```
 float c=sin(uv.x*8.);
 fragColor=vec4(vec3(c),1.);
```

[图片]

我们这个放射光线太僵硬了，我们给它增加一点弧度。

`float c=sin(uv.x*12.+uv.y*8.);`

[图片]

其实使用`cos`函数也行

`float c=cos(uv.x*12.+uv.y*8.);`

[图片]

其实使用`tan`函数也行
`float c=tan(uv.x*12.+uv.y*8.);`

哈哈哈，其实作用域为 R，周期为 T 的函数都可以实现放射性光线效果。基于函数之间的区别，具体效果可能会不一样。

## 利用极坐标系生成螺旋形光线

还是利用`sin`函数即可

`float c=sin(uv.y*20.+uv.x);`
[图片]

思考：螺旋形我们可以使用`cos`和`tan`函数吗？

我们直接尝试一下：

1. `tan` 函数

```
float c=tan(uv.y*20.+uv.x);
```

[图片]

2. `cos`函数

```
float c=cos(uv.y*20.+uv.x);
```

[图片]

结论还是跟我们上面说的一样。

## 放射形和螺旋形不停切换的效果

要实现不停切换的效果，我们需要引入`iGlobalTime`,并且利用`mix`函数实现图形切换效果。直接看代码：

```
//主函数
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
	vec2 uv=fragCoord/iResolution.xy;
    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;
    float phi=atan(uv.y,uv.x);
    float r=length(uv);
    uv=vec2(phi,r);

    // 动态参数，随时间变化
    float time = iGlobalTime;

    // 放射光线
    float c1=sin(uv.x*12.+uv.y*8.);

    //螺旋光线
    float c2=cos(uv.y*20.+uv.x);

    // 利用时间变量来混合这两种图案
    float mixFactor = 0.5 + 0.5 * sin(time);
    float pattern = mix(c1, c2, mixFactor);
    fragColor=vec4(vec3(pattern),1.);

}

```

[图片]

## 总结

以上便是今天分享的 shader 极坐标的全部内容了，极坐标还可以帮助我们做出很多很有意思的图形。有兴趣的小伙伴下来可以深入研究。上文如有错误之处，欢迎大家留言指出，谢谢大家了。
