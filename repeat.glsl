//并操作
float opUnion(float d1,float d2)
{
    return min(d1,d2);
}

float sdCircle(vec2 p, float r) {
    return length(p) - r;
}

//主函数
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    //线
	// vec2 uv=fragCoord/iResolution.xy;
    // uv=(uv-.5)*2.; 
    // uv.x*=iResolution.x/iResolution.y;
  
    // vec3 c=vec3(step(.5,uv.y));
    // fragColor=vec4(c,1.);

    // 条纹
    // vec2 uv=fragCoord/iResolution.xy;
    // uv=fract(uv*16.);
    // uv=(uv-.5)*2.; 
    // uv.x*=iResolution.x/iResolution.y;
  
    // //x轴
    // // vec3 c=vec3(step(.5,uv.x));
    // //y轴
    // vec3 c=vec3(step(.5,uv.y));
    // fragColor=vec4(c,1.);

    //波浪
    // vec2 uv=fragCoord/iResolution.xy;
    // uv.y+=tan(uv.x*6.)*.4;
    // uv=fract(uv*16.);
     
    // uv=(uv-.5)*2.; 
    // uv.x*=iResolution.x/iResolution.y;
  
    // vec3 c=vec3(step(.5,uv.y));
    // fragColor=vec4(c,1.);

    //网格

    // vec2 uv=fragCoord/iResolution.xy;
    // uv=fract(uv*16.);
     
    // uv=(uv-.5)*2.; 
    // uv.x*=iResolution.x/iResolution.y;
  
    // vec3 c=vec3(opUnion(step(.5,uv.y),step(.5,uv.x)));
    // fragColor=vec4(c,1.);


    // 波纹
    // vec2 uv=fragCoord/iResolution.xy;
    // uv=(uv-.5)*2.;
    // uv.x*=iResolution.x/iResolution.y;
    // float d=sdCircle(uv,.5);
    // //利用sin函数的重复特征得到波纹效果
    // d=sin(d*40.);
    // float mask=smoothstep(0.,.02,d);
    // vec3 c=vec3(mask);
    // fragColor=vec4(c,1.);

    //放射光束

    vec2 uv=fragCoord/iResolution.xy;
    uv.y+=sin(uv.x*4.);
    uv=fract(uv*16.);
    uv=(uv-.5)*2.; 
    uv.x*=iResolution.x/iResolution.y;
    vec3 c=vec3(step(.5,uv.y));
    fragColor=vec4(c,1.);
    
}



