# shader 中的 img——纹理

## 前言

在前端中，我们经常接触到各种图片，我们也可以通过图片去做很多很好看的效果。那在 shader 中，我们有没有图片的概念呢？答案是：没有。在 shader 中我们没有图片，但我们有纹理（跟图片概念相同，只是换了个名字而已）。话不多说，我们直接开始吧。

注意： 以下代码全部是在 shaderToy 环境中编写的，如需运行，请在 shaderToy 环境中。

## uv 模板

我们后续代码都是在这个模板上进行的。

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    uv=(uv*2.)-1.0;
    uv.x*=iResolution.x/iResolution.y;
    fragColor=vec4(uv,0.,1.);
}

```

[图片]

## 纹理

### 引入纹理

#### 在 shaderToy 环境的编辑器中引入

```
#iChannel0 "https://cdn.pixabay.com/photo/2017/09/25/13/12/puppy-2785074_1280.jpg"
```

#### 在 shaderToy 网站上引入

1. [图片]
2. [图片]

### 纹理采样

我们已经引入了纹理，现在，我们需要对纹理进行采样处理。

GLSL 内置了一个`采样函数 texture`，我们直接用它将纹理给采样出来。

`texture(纹理对象，采样坐标)`

texture 接受 2 个参数：第一个是我们的纹理 iChannel0，第二个是 UV 坐标变量 uv。

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    vec3 tex=texture(iChannel0,uv).xyz;
    fragColor=vec4(tex,1.);
}
```

[图片]
我们可以看到，我们的纹理已经显示出来了。

## 纹理效果

### 扭曲纹理

第一种效果是扭曲，通过改变纹理的 UV 坐标来扭曲整个图片的形状。

先创建一个扭曲函数：

```
vec2 distort(vec2 p){
    return p;
}

```

然后再主函数中调用它：

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    //纹理采样
    uv=distort(uv);
    vec3 tex=texture(iChannel0,uv).xyz;
    fragColor=vec4(tex,1.);
}
```

[图片]

我们可以看到图片没有任何改变，应为我们的`distort`函数中没有改变 uv 的值。

下面我们来改变以下 uv 的值：

```
vec2 distort(vec2 p){
    p.x+=sin(p.y*10.0);
    return p;
}
```

[图片]

我们可以看到图片已经扭曲了，但扭曲效果太夸张，所以我们需要调整下 distort 函数。

```
vec2 distort(vec2 p){
    p.x+=sin(p.y*10.0)/50.0;
    return p;
}

```

[图片]

我们可以看到效果已经好多了，但现在是静态的。我们利用 iTime 使它动起来。

```
vec2 distort(vec2 p){
    p.x+=sin(p.y*10.+iTime)/50.;
    return p;
}


```

[图片]

### 纹理转场

纹理转场就是从一张图片变为另外一张图片，例如：
[tupian]

我们需要两张图片，通过`mix函数`让它们根据`鼠标的滑动`实现转场效果。

1. 引入纹理 2 的图片

```
#iChannel1 "https://cdn.pixabay.com/photo/2019/07/23/13/51/shepherd-dog-4357790_960_720.jpg"

```

2. 给两个纹理分别创建采样函数

```
vec4 getFromColor(vec2 uv){
    return texture(iChannel0,uv);
}

vec4 getToColor(vec2 uv){
    return texture(iChannel1,uv);
}

```

3. 创建转场动画函数

```

vec4 transition(vec2 uv){
    //转场
    float progress=iMouse.x/iResolution.x;
    return mix(getFromColor(uv),getToColor(uv),progress);
}

```

4. 在主函数中调用转场动画函数

```
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;

    //转场
    vec4 col=transition(uv);
    fragColor=col;
}

```

[图片]

### 滑动转场

跟上面的转场相比，我们只改动了转场动画函数：

```
vec4 transition(vec2 uv){
    //滑动转场
    float progress=iMouse.x/iResolution.x;
    return mix(getFromColor(uv),getToColor(uv),1.-step(progress,uv.x));
}

```

我们将 mix 函数的混合度从[0,1]变为了只有两个选择：0 或者 1，从而实现我们想要的效果。

[图片]

### 遮罩转场

我们需要一个形状去遮住另外的部分，实现我们的遮罩转场。这里我们创建的是一个圆形遮罩。

[图片]

跟滑动转场相比，我们依旧是只改变了我们的转场动画函数：

```
vec4 transition(vec2 uv){
    float progress=iMouse.x/iResolution.x;
    float ratio=iResolution.x/iResolution.y;

    vec2 p=uv;
    p-=.5;
    p.x*=ratio;
    float d=sdCircle(p,progress*sqrt(2.));
    float c=smoothstep(0.,.02,d);
    return mix(getFromColor(uv),getToColor(uv),1.-c);
}

```

我们来分析一下：

1. 我们需要计算我们的鼠标的位置和画布宽度的比值，并将该值作为进度值

2. 我们需要去修正我们的 uv 坐标系，并使它居中

3. 我们需要以我们画一个以坐标原点为中心，以以鼠标位置距离画布边缘的距离的相应倍数为半径来画一个圆

4. 处理好边界，并混合颜色(颜色为两张纹理图片的采样)

### 置换转场

我们还可以用纹理本身来扭曲纹理的 UV 坐标，这样的操作称为“置换”（displacement），用来扭曲的纹理称为“置换纹理”。

1. 引入置换纹理

```
#iChannel2 "https://s2.loli.net/2023/07/17/3GDlwcvehqQjTPH.jpg"

```

2. 转场函数‘

```
vec4 transition(vec2 uv){
    float progress=iMouse.x/iResolution.x;
    float ratio=iResolution.x/iResolution.y;

    vec2 dispVec=texture(iChannel2,uv).xy;
    vec2 uv1=vec2(uv.x-dispVec.x*progress,uv.y);
    vec2 uv2=vec2(uv.x+dispVec.x*(1.-progress),uv.y);
    return mix(getFromColor(uv1),getToColor(uv2),progress);
}

```

3. 主函数调用

```
    vec4 col=transition(uv);
    fragColor=col;
```

[图片]

## 总结

以上便是 shader 中纹理的全部内容了，如有错误之处，欢饮大家留言指出。谢谢大家了。
