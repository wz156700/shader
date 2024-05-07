
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


// 重复三角形
// void mainImage(out vec4 fragColor,in vec2 fragCoord){
//     vec2 uv=fragCoord/iResolution.xy;

//     uv=fract(uv*vec2(2.,2.));

//     uv=(uv-.5)*2.;
//     uv.x*=iResolution.x/iResolution.y;

//     float d=sdEquilateralTriangle(uv,0.5);
//     float c=smoothstep(0.,.02,d);
//     fragColor=vec4(vec3(c),1.);
//     // fragColor=vec4(uv,0.,1.);
// }

// 重复发光圆

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

