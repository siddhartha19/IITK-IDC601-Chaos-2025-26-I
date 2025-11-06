#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform vec2 uResolution;
uniform float uZoom;
uniform vec2 uOffset;
uniform float uTime;

void main() {
  //-- Map pixel to complex plane
  vec2 c = (gl_FragCoord.xy - 0.5*uResolution) / uResolution.y;
  c = c / uZoom + uOffset;

  vec2 z = vec2(0.0);
  int maxIter = 200;
  int i;
  for (i = 0; i < maxIter; i++) {
    if (dot(z, z) > 4.0) break;
    z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
  }

  //-- Smooth coloring
  float color = float(i) - log2(log(length(z)));
  vec3 col = 0.5 + 0.5*cos(3.0 + color*0.15 + vec3(0.0, 0.6, 1.0)); //-- Colouring trick by Inigo Quilez!
  gl_FragColor = vec4(col, 1.0);

}
