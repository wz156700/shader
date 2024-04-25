# 利用 uv 坐标画一个圆

## 前言

想必，大家都知道，在 shader 中 uv 是一个非常神奇的内容，它可以实现很多非常有意思的东西，堪称 shader 中的大触。今天我们就使用 uv 来画一个小圆，简单感受下它的神奇之处。

## 可视化 uv 坐标

我们可以通过不同的 uv 坐标，显示不同的颜色。来可视化的看一下 uv 坐标的规律。

### 什么是 uv 坐标

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;  `iResolution：内置变量，记录画布大小`
}

```

在这段函数中，我们知道：fragColor 为输出的颜色，fragCoord 为输入的坐标。`uv坐标便是fragCoord除以画布大小（进行归一化）之后得到的坐标`。

### 我们来看下 x 方向的分布情况：

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;  `iResolution：内置变量，记录画布大小`
    fragColor=vec4(uv.x,0.,0.,1.)
}
```

结果：
【图片】
我们可以看到，颜色从原点到[1,0]渐变。

### 我们来看下 y 方向的分布情况：

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;  `iResolution：内置变量，记录画布大小`
    fragColor=vec4(0.,uv.y,0.,1.)
}
```

结果：
【图片】
我们可以看到，颜色从原点到[0,1]渐变。

### 将 x,y 结合起来看下分布情况：

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;  `iResolution：内置变量，记录画布大小`
    fragColor=vec4(uv.x,uv.y,0.,1.)
}
```

结果：
【图片】
我们可以看到，颜色从原点到[1,0][0,1]渐变。

## 圆形的绘制

总体思路：`先计算出uv上距离原点的距离，根据距离的不同给不同的颜色`。

1. 得到渐变圆

`计算uv到原点的距离，我们可以使用glsl内置函数 length()`

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;  `iResolution：内置变量，记录画布大小`
    float d=length(uv);
    fragColor=vec4(vec3(d),1.);
}

```

我们可以得到一个渐变的 1/4 圆。如果我们想要得到一个完整的渐变圆，我们应该怎么处理呢？
`我们只需要将uv坐标轴的原点从原来的[0,0]移动到原来的[0.5,0.5]`

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;  `iResolution：内置变量，记录画布大小`
     uv=(uv*2.)-1.0; //uv居中
    float d=length(uv);
    fragColor=vec4(vec3(d),1.);
}
```

这样我们便可以得到一个完整的渐变圆了。

我们可以来看下 uv 居中前和居中后的对比：
【图片】

2. 得到实心圆
   思路：`我们定义一个中间变量c,当我们的d的大小在不同的范围时，c取不同的值`

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv =fragCoord/iResolution.xy; //坐标除以画布大小得到归一化uv坐标
   // uv 居中
   uv=(uv*2.)-1.0;
    uv.x*=iResolution.x/iResolution.y; // 修正uv坐标未自动适应画布比例的问题
    float d=length(uv)-0.5; // 取一段距离
    float c=0.; //存放值的变量
    if(d>0.){
        c=1.0;
    }else{
        c=0.0
    }
    fragColor=vec4(c,c,c,1.); // 输出
}
```

【图片】

注意：`在Shader的编写中，我们应当尽量避免使用if语句，为什么呢？因为GPU是并行处理结果的，而if语句会让处理器进行分支切换这一操作，处理多个分支会降低并行处理的性能。那么如何优化掉if语句呢？我们可以用GLSL其中的一个内置函数来代替它,这个函数便是：step。`

step 函数被称为 `阶梯函数`。它的图像是:

【图片】

它的语法是：`step(edge,x)`

- edge: 表示边界
- x: 代表坐标

`它的意思是：当x超过edge时，返回1；当x未超过edge时，返回0`
它的函数图像时：
【图片】

我们来改一下我们的代码：

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv =fragCoord/iResolution.xy; //坐标除以画布大小得到归一化uv坐标
   // uv 居中
   uv=(uv*2.)-1.0;
    uv.x*=iResolution.x/iResolution.y; // 修正uv坐标未自动适应画布比例的问题
    float d=length(uv)-0.5; // 取一段距离
    float c=0.; //存放值的变量
    c=step(0.,d ); //利用step函数得到值
    fragColor=vec4(c,c,c,1.); // 输出
}

```

【图片】

`我们仔细观察一下，我们画的这个圆有没有什么不对劲的地方？`
【图片】
我们是不是可以看到，圆的边缘有很多的锯齿。那我们应该怎样处理这个情况呢？
我们再来认识一个 GLSL 的内置函数——smoothstep 函数，它也被称作“平滑阶梯函数”，是因为它的函数图像是一个平滑过的阶梯的形状，如下图所示：
【图片】
它的代码表示形式是这样的：

```
smoothstep(edge1,edge2,x)

```

它有两个边界，小于 edge1,返回 0；大于 edge2，返回 1；介于 0-1 之间，返回 0-1 平滑过渡的值。
改一下我们的代码：

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv =fragCoord/iResolution.xy; //坐标除以画布大小得到归一化uv坐标
   // uv 居中
   uv=(uv*2.)-1.0;
    uv.x*=iResolution.x/iResolution.y; // 修正uv坐标未自动适应画布比例的问题
    float d=length(uv)-0.5; // 取一段距离
    float c=0.; //存放值的变量
    c=smoothstep(0.,0.02,d ); //利用step函数得到值
    fragColor=vec4(c,c,c,1.); // 输出
}

```

[图片]

## 总结

以上便是，我们利用 uv 坐标来画一个小圆的全部内容了，如有错误之处，欢迎大家留言指出，谢谢大家了。
