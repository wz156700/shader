void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv =fragCoord/iResolution.xy;
    // fragColor=vec4(uv.x,0.,0.,1.);
    // fragColor=vec4(0.,uv.y,0.,1.);
    // fragColor=vec4(uv,0.,1.);
    uv=(uv-0.5)*2.0;
    uv.x*=iResolution.x/iResolution.y;
    float d=length(uv)-0.5;
    // fragColor=vec4(d,d,d,1.);
    float c=0.;
    // if(d>0.){
    //     c=1.;
    // }else{
    //     c=0.;
    // }
    c=step(0.,d );
    fragColor=vec4(c,c,c,1.);
}