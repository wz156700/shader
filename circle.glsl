// void mainImage(out vec4 fragColor,in vec2 fragCoord){
//     vec2 uv =fragCoord/iResolution.xy; //坐标除以画布大小得到归一化uv坐标
//     // uv 居中
//     uv=(uv*2.)-1.0;
//     uv.x*=iResolution.x/iResolution.y; // 修正uv坐标未自动适应画布比例的问题
//     float d=length(uv)-0.5; // 取一段距离
//     float c=0.; //存放值的变量
//     if(d>0.){
//         c=1.0;
//     }else{
//         c=0.0;
//     }
//     fragColor=vec4(c,c,c,1.); // 输出
// }

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv =fragCoord/iResolution.xy; //坐标除以画布大小得到归一化uv坐标
    // fragColor=vec4(uv.x,0,0.,1.0);
    //  fragColor=vec4(0.,uv.y,0.,1.0);
    // fragColor=vec4(uv.x,uv.y,0.,1.0);
    // float d=length(uv);
    // fragColor=vec4(vec3(d),1.);
    // uv 居中
    uv=(uv*2.)-1.0;
    // float d=length(uv);
    // fragColor=vec4(vec3(d),1.);
    uv.x*=iResolution.x/iResolution.y; // 修正uv坐标未自动适应画布比例的问题
    float d=length(uv)-0.5; // 取一段距离
    float c=0.; //存放值的变量
    c=smoothstep(0.,0.02,d ); //利用step函数得到值
    fragColor=vec4(c,c,c,1.); // 输出
}