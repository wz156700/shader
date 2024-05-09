//主函数
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
	vec2 uv=fragCoord/iResolution.xy;
    uv=(uv-.5)*2.; 
    uv.x*=iResolution.x/iResolution.y;
    float phi=atan(uv.y,uv.x);
    float r=length(uv);
    uv=vec2(phi,r);

    // 动态参数，随时间变化
    float time = iGlobalTime;

    //可视化极坐标系
    // fragColor=vec4(uv,0.,1.);

    // // 放射光线
    float c1=sin(uv.x*12.+uv.y*8.);
    // float c=sin(uv.x*8.);

    //螺旋光线
    float c2=cos(uv.y*20.+uv.x);

    // 利用时间变量来混合这两种图案
    float mixFactor =  sin(time);
    float pattern = mix(c1, c2, mixFactor);
    fragColor=vec4(vec3(pattern),1.);
    
}

// void mainImage( out vec4 fragColor, in vec2 fragCoord )
// {
//     vec2 uv = fragCoord / iResolution.xy - 0.5;
//     uv.x *= iResolution.x / iResolution.y;

//     // 转换到极坐标
//     float angle = atan(uv.y, uv.x);
//     float radius = length(uv);

//     // 创建放射形图案
//     float stripes = 0.5 + 0.5 * sin(10.0 * angle);
//     float circle = smoothstep(0.02, 0.03, radius);

//     // 结合放射形图案和圆形图案
//     float pattern = mix(stripes, circle, circle);

//     // 输出颜色
//     fragColor = vec4(vec3(pattern), 1.0);
// }

// void mainImage( out vec4 fragColor, in vec2 fragCoord )
// {
//     // 将屏幕坐标转换为[-1, 1]范围内的UV坐标
//     vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    
//     // 计算中心点到当前像素点的距离
//     float dist = length(uv);
    
//     // 使用距离和一个数学函数来创建放射形图案
//     // 这里使用了sin函数和距离乘以一个系数来创建周期性的放射效果
//     float pattern = sin(dist * 20.0+20.);
    
//     // 使用计算出的pattern值来设置颜色
//     fragColor = vec4(pattern, pattern, pattern, 1.0);
// }

// void mainImage( out vec4 fragColor, in vec2 fragCoord )
// {
//     vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
//     float angle = atan(uv.y, uv.x) * 10.0;
//     float pattern = abs(mod(angle, 1.0) - 0.5);
//     fragColor = vec4(vec3(pattern), 1.0);
// }