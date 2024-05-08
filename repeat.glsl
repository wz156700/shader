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
	vec2 uv=fragCoord/iResolution.xy;
    uv=(uv-.5)*2.; 
    uv.x*=iResolution.x/iResolution.y;
    // uv.y+=atan(uv.x);
    // uv.y+=sin(uv.x*6.)*.4;

    // uv=fract(uv*16.);
 
    
    // float d1=step(.5,uv.x);
    // float d2=step(.5,uv.y);
    // float d=opUnion(d1,d2);

    // fragColor=vec4(vec3(d),1.);
    float d=sdCircle(uv,.5);
    d=fract(d*40.); 
    float mask=smoothstep(0.,.02,d);
    vec3 c=vec3(mask);
    fragColor=vec4(c,1.);


    
}



