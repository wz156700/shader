#iChannel0 "https://cdn.pixabay.com/photo/2017/09/25/13/12/puppy-2785074_1280.jpg"
#iChannel1 "https://cdn.pixabay.com/photo/2019/07/23/13/51/shepherd-dog-4357790_960_720.jpg"
#iChannel2 "https://s2.loli.net/2023/07/17/3GDlwcvehqQjTPH.jpg"


vec2 distort(vec2 p){
    p.x+=sin(p.y*10.0+iTime)/50.0;
    return p;
}

vec4 getFromColor(vec2 uv){
    return texture(iChannel0,uv);
}

vec4 getToColor(vec2 uv){
    return texture(iChannel1,uv);
}

float sdCircle(vec2 p,float r)
{
    return length(p)-r;
}

// vec4 transition(vec2 uv){
//     //转场
//     // float progress=iMouse.x/iResolution.x;
//     // return mix(getFromColor(uv),getToColor(uv),progress);

//     // //滑动转场
//     float progress=iMouse.x/iResolution.x;
//     return mix(getFromColor(uv),getToColor(uv),1.-step(progress,uv.x));
// }

// 遮罩转场
// vec4 transition(vec2 uv){
//     float progress=iMouse.x/iResolution.x;
//     float ratio=iResolution.x/iResolution.y;

//     vec2 p=uv;
//     p-=.5;
//     p.x*=ratio;
//     float d=sdCircle(p,progress*sqrt(2.));
//     float c=smoothstep(0.,.02,d);
//     return mix(getFromColor(uv),getToColor(uv),1.-c);
// }

// 混合转场
vec4 transition(vec2 uv){
    float progress=iMouse.x/iResolution.x;

    vec2 dispVec=texture(iChannel2,uv).xy;
    vec2 uv1=vec2(uv.x-dispVec.x*progress,uv.y);
    vec2 uv2=vec2(uv.x+dispVec.x*(1.-progress),uv.y);
    return mix(getFromColor(uv1),getToColor(uv2),progress);
}


void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=fragCoord/iResolution.xy;
    // uv=(uv*2.)-1.0;
    // uv.x*=iResolution.x/iResolution.y;
    // fragColor=vec4(uv,0.,1.);
    //纹理采样
    // uv=distort(uv);
    // vec3 tex=texture(iChannel0,uv).xyz;
    // fragColor=vec4(tex,1.);

    //转场
    vec4 col=transition(uv);
    fragColor=col;

    //滑动转场
    // vec4 col=transition(uv);
    // fragColor=col;
}

//纹理采样
// void mainImage(out vec4 fragColor,in vec2 fragCoord){
//     vec2 uv=fragCoord/iResolution.xy;
//     vec3 tex=texture(iChannel0,uv).xyz;
//     fragColor=vec4(tex,1.);
// }
