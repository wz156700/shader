//并操作
float opUnion(float d1,float d2)
{
    return min(d1,d2);
}

//交集
float opIntersection(float d1,float d2)
{
    return max(d1,d2);
}

// 差
float opSubtraction(float d1,float d2)
{
    return max(-d1,d2);
}

float opSmoothUnion(float d1,float d2,float k){
    float h=clamp(.5+.5*(d2-d1)/k,0.,1.);
    return mix(d2,d1,h)-k*h*(1.-h);
}

float opSmoothSubtraction(float d1,float d2,float k){
    float h=clamp(.5-.5*(d2+d1)/k,0.,1.);
    return mix(d2,-d1,h)+k*h*(1.-h);
}

float opSmoothIntersection(float d1,float d2,float k){
    float h=clamp(.5-.5*(d2-d1)/k,0.,1.);
    return mix(d2,d1,h)+k*h*(1.-h);
}


float sdCircle(vec2 p, float r) {
    return length(p) - r;
}

float sdBox(in vec2 p,in vec2 b)
{
    vec2 d=abs(p)-b;
    return length(max(d,0.))+min(max(d.x,d.y),0.);
}

//星星
// signed distance to a n-star polygon with external angle en
float sdStar(in vec2 p, in float r, in int n, in float m) // m=[2,n]
{
    p.x-=0.2;
    // these 4 lines can be precomputed for a given shape
    float an = 3.141593/float(n);
    float en = 3.141593/m;
    vec2  acs = vec2(cos(an),sin(an));
    vec2  ecs = vec2(cos(en),sin(en)); // ecs=vec2(0,1) and simplify, for regular polygon,

    // symmetry (optional)
    p.x = abs(p.x);
    
    // reduce to first sector
    float bn = mod(atan(p.x,p.y),2.0*an) - an;
    p = length(p)*vec2(cos(bn),abs(sin(bn)));

    // line sdf
    p -= r*acs;
    p += ecs*clamp( -dot(p,ecs), 0.0, r*acs.y/ecs.y);
    return length(p)*sign(p.x);
}

//月亮
float sdMoon(vec2 p, float d, float ra, float rb )
{
    p.y = abs(p.y);

    float a = (ra*ra - rb*rb + d*d)/(2.0*d);
    float b = sqrt(max(ra*ra-a*a,0.0));
    if( d*(p.x*b-p.y*a) > d*d*max(b-p.y,0.0) )
    {
        return length(p-vec2(a,b));
    }

    return max( (length(p          )-ra),
               -(length(p-vec2(d,0))-rb));
}

//主函数
// void mainImage(out vec4 fragColor, in vec2 fragCoord)
// {
// 	vec2 uv=fragCoord/iResolution.xy;
//     uv=(uv-.5)*2.; 
    
//     // sdf
//     float d1 = sdStar( uv, 0.6, int(5.), 3.);

//     float d2 = sdMoon( uv, 0.2, 0.8, 0.7 );

//     float d3=sdBox(uv,vec2(1.,0.8 ));

//     float d=opUnion(d1,d2);

//     float c=smoothstep(0.,.02,d);
//     //渲染上相同的颜色
//     vec3 colInner=vec3(1.,0.,0.);
//     vec3 colOuter=vec3(1.);
//     vec3 col=mix(colInner,colOuter,c);
//     //给不同的图形渲染不同的颜色
    
//     fragColor=vec4(col,1.);
    
// }

//给星星和月亮上色
// void mainImage(out vec4 fragColor, in vec2 fragCoord)
// {
//     vec2 uv = fragCoord/iResolution.xy;
//     uv = (uv - 0.5) * 2.0; 

//     // SDFs
//     float d1 = sdStar(uv, 0.6, 5, 3.0);
//     float d2 = sdMoon(uv, 0.2, 0.8, 0.7);

//     // Check if the current pixel is inside the star or the moon
//     if (d1 < 0.02) // Inside the star
//     {
//         fragColor = vec4(1.0, 0.0, 0.0, 1.0); // Red color for the star
//     }
//     else if (d2 < 0.02) // Inside the moon
//     {       
//          fragColor = vec4(0.0, 0.0, 1.0, 1.0); // Blue color for the moon
//     }
//     else // Outside both the star and the moon
//     {
//     fragColor = vec4(0.0, 0.0, 0.0, 1.0); // Black color for the background
//     }
// }

// mix 渐变色验证
void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;

    // 渐变色
    // vec3 col1=vec3(1.,0.,0.);
    // vec3 col2=vec3(0.,1.,0.);
    // vec3 col=mix(col1,col2,uv.x);
    // fragColor=vec4(col,1.);

    //给图形上色
    // uv=(uv-.5)*2.;
    // uv.x*=iResolution.x/iResolution.y;

    // float d1=sdBox(uv,vec2(.6,.3));
    // float d2=sdCircle(uv,.5);
    // float d=opUnion(d1,d2);
    // float c=smoothstep(0.,.02,d);
    // vec3 colInner=vec3(1.,0.,0.);
    // vec3 colOuter=vec3(1.);
    // vec3 col=mix(colInner,colOuter,c);
    // fragColor=vec4(col,1.);


    // 图形变换
    uv=(uv-.5)*2.;
    uv.x*=iResolution.x/iResolution.y;

    // float d1=sdCircle(uv,.5);
    // float d2=sdBox(uv,vec2(.6,.3));
    float d1 = sdStar( uv, 0.6, int(5.), 3.);
    float d2 = sdCircle( uv, 0.8);
    float d=mix(d1,d2,abs(cos(iTime)));
    float c=smoothstep(0.,.02,d);
    fragColor=vec4(vec3(c),1.);


}



