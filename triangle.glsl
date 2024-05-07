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
    uv=rotate(uv,iTime);
    //应用SDF函数的圆形
    float d=sdEquilateralTriangle(uv,0.5); // 取一段距离
    
    float c=0.; //存放值的变量
    c=smoothstep(0.,0.02,d ); //利用step函数得到值
    fragColor=vec4(c,c,c,1.); // 输出
}


