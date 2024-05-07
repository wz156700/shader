# 使用 shader 的 abs 函数实现兑成效果

## 前言

前面，我们学习了内置函数`fract`,今天我们再来学习另外一个内置函数`abs`。废话不多说，直接开始吧。

## abs 函数说明

1. ` 它的作用是获取一个数的绝对值`。比如 abs(2.)，返回的值是 2.，abs(-2.)，返回的值也是 。

2. 图像：
   【图片】

## 对称效果

```

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    //uv居中
    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;
    //对称
    uv.y=abs(uv.y);
    // 渲染颜色
    fragColor=vec4(uv,0.,1.);
}

```

【图片】

实现一个对称的三角想

```

// 画一个三角形
float sdEquilateralTriangle(in vec2 p,in float r)
{
    const float k=sqrt(3.);
    p.x=abs(p.x)-r;
    p.y=p.y+r/k;
    if(p.x+k*p.y>0.)p=vec2(p.x-k*p.y,-k*p.x-p.y)/2.;
    p.x-=clamp(p.x,-2.*r,0.);
    return-length(p)*sign(p.y);
}


// 对称效果
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;
    uv.y=abs(uv.y);

    float d=sdEquilateralTriangle(uv,0.5);
    float c=smoothstep(0.,.02,d);
    fragColor=vec4(vec3(c),1.);
}

```

[图片]

## 总结

以上便是 abs 函数实现对称效果的全部内容了，如有错误之处，欢迎大家留言指出，谢谢大家了。
