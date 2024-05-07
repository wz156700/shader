# 利用 shader 中的 fract 函数实现重复效果

## 前言

今天，我们来学习下 shader 中另外的一个内置函数——`fract`。我们今天将利用它来实现`重复效果`。话不多说，直接开始吧。

## fract 函数介绍

`fract`—— 它的作用是获取一个数的小数部分，例如：比如 fract(25.14)，返回的值就是 0.14。

## 重复效果

我们先直接上代码，看下我们的重复效果：

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;

    uv=fract(uv*vec2(3.,2.));
    fragColor=vec4(uv,0.,1.);
}

```

[图片]

为什么我们这样做就可以得到重复效果了呢？

- 我们的 uv 坐标经过`uv*vec2(3.,2.)`变成了下面这样
  [图片]

- 然后我们通过`fract`函数取了它的小数，我们的 uv 坐标便变成了这样：

[图片]

- 然后我们通过颜色去输出，便得到了上面的效果。

重复效果有了，我们可以去输出重复的三角形：

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


// 重复
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;

    uv=fract(uv*vec2(3.,2.));

    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;

    float d=sdEquilateralTriangle(uv,0.5);
    float c=smoothstep(0.,.02,d);
    fragColor=vec4(vec3(c),1.);
}

```

[图片]

还可以输出重复的发光圆：

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
      vec2 uv =fragCoord/iResolution.xy; //坐标除以画布大小得到归一化uv坐标
       uv=fract(uv*vec2(2.,2.));
    // uv 居中
    uv=(uv*2.)-1.0;
    uv.x*=iResolution.x/iResolution.y; // 修正uv坐标未自动适应画布比例的问题
    float d=(length(uv)); // 取uv坐标长度（这里不需要减去一段距离，因为减去一段距离之后便存在负数了）
    float c=0.2/d; //存放值的变量
    // 发光效果
    fragColor=vec4(vec3(c),1.); // 输出
}
```

[图片]

## 总结

以上便是我们利用 fract 函数得到重复效果的全部内容了，如有错误之处，欢迎大家留言指出，谢谢大家了。
