#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform vec3 color;
uniform vec3 otherColor;
uniform float stripe_density;
uniform float angle;

out vec4 fragColor;

void main() {    
    vec2 st = FlutterFragCoord().xy / u_resolution;
        
    float locationFactor = floor(0.5 * sin((st.x * cos(angle) + st.y * sin(angle)) * stripe_density) + 1.0);

    vec3 stripe = vec3(
        otherColor.x + locationFactor * (color.x - otherColor.x),
        otherColor.y + locationFactor * (color.y - otherColor.y),
        otherColor.z + locationFactor * (color.z - otherColor.z)
    );

    fragColor = vec4(stripe,1.0);
}