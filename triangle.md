# shader 实现一个翻转旋转的三角形

## 前言

在前面，我们通过 shader 去实现了圆，发光圆，矩形这几种效果，今天，我们将来实现一个翻转旋转的三角形。话不多说，直接开始吧。

## 实现过程

### 画一个三角形

我们首先先来画一个三角形。跟之前画矩形的流程是一样的，唯一不同的点，在于我们的 SDF 函数不同。

等边三角形的 SDF 函数：

```
float sdEquilateralTriangle(in vec2 p,in float r)
{
    const float k=sqrt(3.);
    p.x=abs(p.x)-r;
    p.y=p.y+r/k;
    if(p.x+k*p.y>0.)p=vec2(p.x-k*p.y,-k*p.x-p.y)/2.;
    p.x-=clamp(p.x,-2.*r,0.);
    return-length(p)*sign(p.y);
}

```

[图片]

### 翻转三角形

```
 uv.y*=-1.0; // 修正y轴方向

```

[图片]

### 旋转

1. 先定义好旋转的函数

```

mat2 rotation2d(float angle){
    float s=sin(angle);
    float c=cos(angle);

    return mat2(
        c,-s,
        s,c
    );
}

vec2 rotate(vec2 v,float angle){
    return rotation2d(angle)*v;
}

```

2. 定义好 PI

```
const float PI=3.14159265359;

```

3. 调用旋转函数

```
uv=rotate(uv,PI/2.);
```

[图片]

4. 完整代码：

```
const float PI=3.14159265359;
float sdEquilateralTriangle(in vec2 p,in float r)
{
    const float k=sqrt(3.);
    p.x=abs(p.x)-r;
    p.y=p.y+r/k;
    if(p.x+k*p.y>0.)p=vec2(p.x-k*p.y,-k*p.x-p.y)/2.;
    p.x-=clamp(p.x,-2.*r,0.);
    return-length(p)*sign(p.y);
}


mat2 rotation2d(float angle){
    float s=sin(angle);
    float c=cos(angle);

    return mat2(
        c,-s,
        s,c
    );
}

vec2 rotate(vec2 v,float angle){
    return rotation2d(angle)*v;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv =fragCoord/iResolution.xy; //坐标除以画布大小得到归一化uv坐标
    // uv 居中
    uv=(uv*2.)-1.0;
    uv.x*=iResolution.x/iResolution.y; // 修正uv坐标未自动适应画布比例的问题
    uv.y*=-1.0; // 修正y轴方向
    uv=rotate(uv,PI/2.); // 旋转
    //应用SDF函数的圆形
    float d=sdEquilateralTriangle(uv,0.5); // 取一段距离

    float c=0.; //存放值的变量
    c=smoothstep(0.,0.02,d ); //利用step函数得到值
    fragColor=vec4(c,c,c,1.); // 输出
}

```

5. 利用 Itime 时间变量，让三角形动起来

```
uv=rotate(uv,iTime);

```

[图片]

## 总结

以上便是制作旋转三角形的全部过程了，如有错误之处，欢迎大家留言指出。谢谢大家了。
