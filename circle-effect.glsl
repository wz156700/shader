// 模糊效果
// void mainImage(out vec4 fragColor,in vec2 fragCoord){
//     vec2 uv =fragCoord/iResolution.xy; //坐标除以画布大小得到归一化uv坐标
//     // uv 居中
//     uv=(uv*2.)-1.0;
//     uv.x*=iResolution.x/iResolution.y; // 修正uv坐标未自动适应画布比例的问题
//     float d=(length(uv)-0.5); // 取一段距离
//     float c=0.; //存放值的变量
//     //模糊效果
//     c=smoothstep(0.,0.2,d ); //利用step函数得到值
//     fragColor=vec4(vec3(c),1.); // 输出
    
// }


// 白色圆
// void mainImage(out vec4 fragColor,in vec2 fragCoord){
//     vec2 uv =fragCoord/iResolution.xy; //坐标除以画布大小得到归一化uv坐标
//     // uv 居中
//     uv=(uv*2.)-1.0;
//     uv.x*=iResolution.x/iResolution.y; // 修正uv坐标未自动适应画布比例的问题
//     float d=-1./(length(uv)-0.5); // 取一段距离
//     float c=0.; //存放值的变量
//     //模糊效果
//     c=smoothstep(0.,0.5,d ); //利用step函数得到值
//     // 发光效果
//     fragColor=vec4(vec3(c),1.); // 输出
// }


//发光效果
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv =fragCoord/iResolution.xy; //坐标除以画布大小得到归一化uv坐标
    // uv 居中
    uv=(uv*2.)-1.0;
    uv.x*=iResolution.x/iResolution.y; // 修正uv坐标未自动适应画布比例的问题
    float d=(length(uv)); // 取uv坐标长度（这里不需要减去一段距离，因为减去一段距离之后便存在负数了）
    float c=0.2/d; //存放值的变量
    // 发光效果
    fragColor=vec4(vec3(c),1.); // 输出
    
}