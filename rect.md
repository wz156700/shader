# 利用 SDF 函数实现一个矩形

## 前言

今天我们将学习下 SDF 函数的相关概念，并使用 SDF 完成一个矩形。

## 什么是 SDF

概念：`SDF`，全称 Signed Distance Function（有符号距离函数），是一个在计算机图形学中非常有用的数学概念。简单来说，`它的作用是对于空间中的任何一点，告诉我们在那个点到某个形状表面的最短距离，并且指出这个点是在形状内部还是外部`。这里的“有符号”意味着它不仅能告诉你距离有多远，还能通过正负号区分：

- 如果得到的值是正数，说明该点在形状的外部；
- 如果是负数，说明该点在形状的内部；
- 如果是 0，说明该点正好在形状的表面上。

想象一下，你手里有一个神奇的标尺，无论你站在一个物体的哪个位置，这个标尺不仅能测量出你到这个物体表面的直线距离，还能立刻告诉你是不是已经碰到了物体或者是不是在物体里面。这就是 SDF 的基本思想。在图形编程中，它被用来做各种酷炫的效果，比如实时的阴影计算、复杂形状的碰撞检测等，非常高效且灵活。

在我们之前的画圆的案例中，我们可以将代码改为：

```
float sdCircle(vec2 p, float r) {
    return length(p) - r;
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv =fragCoord/iResolution.xy; //坐标除以画布大小得到归一化uv坐标
    // uv 居中
    uv=(uv*2.)-1.0;
    uv.x*=iResolution.x/iResolution.y; // 修正uv坐标未自动适应画布比例的问题
    //应用SDF函数的圆形
    float d=sdCircle(uv,0.5); // 取一段距离

    float c=0.; //存放值的变量
    c=smoothstep(0.,0.02,d ); //利用step函数得到值
    fragColor=vec4(c,c,c,1.); // 输出
}
```

[图片]
在这段代码中，我们将获取圆的范围的代码抽离出来成了 `sdCircle `函数，这个 `sdCircle `函数便是我们说的——`SDF 函数`。

## 使用 SDF 函数实现一个矩形

思路：

1. `mainImage` 函数中的操作同之前画圆的是基本一样的，不一样的只有调用的` SDF 函数`.
2. 如何实现矩形的 sdf 函数呢？

- 首先我们肯定是要传入 uv 坐标，和矩形的长宽信息
- 其次我们需要利用数学知识去计算 uv 上的点到我们目标矩形的距离

3. sdf 函数的内容：

```
float sdBox(in vec2 p,in vec2 b)
{
    vec2 d=abs(p)-b;
    return length(max(d,0.))+min(max(d.x,d.y),0.);
}

```

函数解析：

- `p:uv 坐标,b:矩形的高度和宽度的一半`
- `abs(p)：得到点p相对于矩形中心点（0，0）的距离`
- `d=abs(p)-b:算出p距离边界的向量，如果在矩形内部，那么d的其中一个或者两个分量会是负数。如果在外部，那d的两个分量都会是正数`
- `max(d,0.): 得到新向量，如果在内部，那么新向量对应的值为0.否则新向量对应的便是d的分量。`
- `length(max(d,0.)):得到p距离边界的距离，>0:外部，=0:内部或者边界`
- `max(d.x,d.y):寻找d的最大分量`
- `min(max(d.x,d.y),0.):将最大分量同0做对比，在外部和边界上的为0，在内部为负数`
- `length(max(d,0.))+min(max(d.x,d.y),0.)：得到有符号距离，正数：代表外部，负数或者0代表矩形内部`

4. 完整代码

```
float sdBox(in vec2 p,in vec2 b)
{
    vec2 d=abs(p)-b;
    return length(max(d,0.))+min(max(d.x,d.y),0.);
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;

    // 绘制矩形
    float d=sdBox(uv,vec2(.6,.3));
    float c=smoothstep(0.,.02,d);
    fragColor=vec4(vec3(c),1.);
}
```

【图片】

## 总结

以上便是使用 shader 的 SDF 函数绘制一个矩形的全部内容了，如有错误之处，欢迎大家留言指出，谢谢大家了。
