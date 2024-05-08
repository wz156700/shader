//主函数
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
	vec2 uv=fragCoord/iResolution.xy;
    uv=(uv-.5)*2.; 
    uv.x*=iResolution.x/iResolution.y;
    float phi=atan(uv.y,uv.x);
    float r=length(uv);
    uv=vec2(phi,r);

    //可视化极坐标系
    // fragColor=vec4(uv,0.,1.);

    // 放射光线
    float c=sin(uv.x*12.);
    fragColor=vec4(vec3(c),1.);
    
}