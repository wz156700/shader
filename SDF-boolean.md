# 利用 SDF 的布尔运算画出组合图形

## 前言

今天我们使用 SDF 的布尔运算来画一些组合图形。

## 现成的 SDF 应该到哪里去取

我们应该都发现了，很多时候 SDF 是非常考验大家的数学功底的。给大家推荐一个大神的博客——`iq的博客`，上面有很多现成的 SDF 函数，我们可以根据自己的需要去获取。还可以根据现有的图形，组合出新的图形。

## SDF 布尔运算

SDF 的布尔运算主要有 3 种：`并（Union）、交（Intersection）、差（Subtraction）`。
这些操作的公式 iq 也在博客文章上列举了出来，直接 CV 过来吧~

```
//并操作
float opUnion(float d1,float d2)
{
    return min(d1,d2);
}

//交集
float opIntersection(float d1,float d2)
{
    return max(d1,d2);
}

// 差
float opSubtraction(float d1,float d2)
{
    return max(-d1,d2);
}

```

## 利用布尔运算，得到组合图形

创建 2 个 SDF 图形（这里用的就是之前的圆形和长方形）

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;

    float d1=sdCircle(uv,.5);
    float d2=sdBox(uv,vec2(.6,.3));

    float d=d1;

    float c=smoothstep(0.,.02,d);
    fragColor=vec4(vec3(c),1.);
}

```

### 生硬版

1. "并"操作，它能取 2 个图形的所有部分，对应函数是 `opUnion`
   [图片]

```
d=opUnion(d1,d2);
```

2.  “交”操作：它能取 2 个图形的相交部分，对应函数是 `opIntersection`。
    【图片】

```
d=opIntersection(d1,d2);
```

3. “差”操作：它能取一个图形扣去另一个图形的部分，对应函数是 `opSubtraction`。注意这个函数的参数是讲究顺序的，是参数 2 的图形部分减去参数 1 的图形部分。

```
d=opSubtraction(d1,d2);

```

[图片]

```
d=opSubtraction(d2,d1);

```

[图片]

### 平滑版

```
float opSmoothUnion(float d1,float d2,float k){
    float h=clamp(.5+.5*(d2-d1)/k,0.,1.);
    return mix(d2,d1,h)-k*h*(1.-h);
}

float opSmoothSubtraction(float d1,float d2,float k){
    float h=clamp(.5-.5*(d2+d1)/k,0.,1.);
    return mix(d2,-d1,h)+k*h*(1.-h);
}

float opSmoothIntersection(float d1,float d2,float k){
    float h=clamp(.5-.5*(d2-d1)/k,0.,1.);
    return mix(d2,d1,h)+k*h*(1.-h);
}


```

平滑版主要是多了`平滑度参数K`,能够控制平滑程度。我们还是利用之前的形状来观察变化。

1. 平滑并，对应的函数是 `opSmoothUnion`。

```
d=opSmoothUnion(d1,d2,.1);

```

[图片] 2. 平滑交，对应的函数是 `opSmoothIntersection`。

```
d=opSmoothIntersection(d1,d2,.1);

```

[图片] 3. 平滑差，对应的函数是 `opSmoothSubtraction`，和普通版函数一样也讲究顺序，是参数 2 的图形部分减去参数 1 的图形部分

```
d=opSmoothSubtraction(d1,d2,.1);

```

[图片]

```
d=opSmoothSubtraction(d2,d1,.1);

```

[图片]

### 利用并操作来实现一个月亮和星星共存图案

1. 月亮的 SDF 函数：

```
float sdMoon(vec2 p, float d, float ra, float rb )
{
    p.y = abs(p.y);

    float a = (ra*ra - rb*rb + d*d)/(2.0*d);
    float b = sqrt(max(ra*ra-a*a,0.0));
    if( d*(p.x*b-p.y*a) > d*d*max(b-p.y,0.0) )
    {
        return length(p-vec2(a,b));
    }

    return max( (length(p          )-ra),
               -(length(p-vec2(d,0))-rb));
}
```

参数说明：

- vec2 p: 当前点的位置，通常是片段着色器中的坐标，经过一定的变换以适应 SDF 的计算。
- float d: 两个圆的圆心之间的距离，它决定了月牙的厚度和弯曲程度。
- float ra: 较大圆的半径，通常是月牙外侧的圆。
- float rb: 较小圆的半径，通常是月牙内侧的圆，它被较大圆部分遮挡。

2. 星星的 SDF 函数

```
float sdStar(in vec2 p, in float r, in int n, in float m) // m=[2,n]
{
    p.x-=0.2;
    // these 4 lines can be precomputed for a given shape
    float an = 3.141593/float(n);
    float en = 3.141593/m;
    vec2  acs = vec2(cos(an),sin(an));
    vec2  ecs = vec2(cos(en),sin(en)); // ecs=vec2(0,1) and simplify, for regular polygon,

    // symmetry (optional)
    p.x = abs(p.x);

    // reduce to first sector
    float bn = mod(atan(p.x,p.y),2.0*an) - an;
    p = length(p)*vec2(cos(bn),abs(sin(bn)));

    // line sdf
    p -= r*acs;
    p += ecs*clamp( -dot(p,ecs), 0.0, r*acs.y/ecs.y);
    return length(p)*sign(p.x);
}

```

参数说明：

- vec2 p: 当前点的位置，通常是片段着色器中的坐标，经过一定的变换以适应 SDF 的计算。
- float r: 星形的外半径，即星形顶点到中心的距离。
- int n: 星形的点数，即星形有多少个顶点。
- float m: 控制星形内凹部分深度的参数，必须在 2 到 n 之间。m 越大，星形的内凹部分越深。

3. 主函数：

```
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
	vec2 uv=fragCoord/iResolution.xy;
    uv=(uv-.5)*2.;      // angle divisor, between 2 and n

    // sdf
    float d1 = sdStar( uv, 0.6, int(5.), 3.);

    float d2 = sdMoon( uv, 0.2, 0.8, 0.7 );

    float d3=sdBox(uv,vec2(1.,0.8 ));

     float d=opUnion(d1,d2);


    float c=smoothstep(0.,.02,d);

	fragColor = vec4(vec3(c),1.0);

}

```

4. 图案：
   [图片]

## 总结

以上便是利用 SDF 的布尔运算得到组合图形的全部内容了。
如有错误之处，欢迎大家留言指出。谢谢大家了。
