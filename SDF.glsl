
float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    // The 'p' value would typically be the position of the fragment in some space (e.g., camera space)
    // Here we map the 2D UV to 3D space for the SDF calculation
    vec3 p = vec3(4.0*(uv.x-0.5), 4.0*(uv.y-0.5), 0.0);
    vec2 t = vec2(1.0, 0.2); // Torus parameters: Radius, Tube Radius

    // Call the SDF function
    float d = sdTorus(p, t);

    // Render the torus based on the distance
    if (d < 0.1)
        fragColor = vec4(col,1.0);
    else
        fragColor = vec4(0.0, 0.0, 0.0, 1.0); // Background color
}
