#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform vec2 uResolution;
uniform float uZoom;
uniform vec2 uOffset;
uniform float uTime;
uniform float uxv;
uniform float uyv;

void main() {
  //-- Map pixel to complex plane
  vec2 z = (gl_FragCoord.xy - uResolution) / uResolution.y; //-- Use if pixelDensity(2)
  //vec2 z = (gl_FragCoord.xy - 0.5*uResolution) / uResolution.y; //-- Use if usual
  z = z / uZoom + uOffset;

  vec2 c = vec2(uxv, uyv);
  int maxIter = 200; //-- Number of iterations - higher for finer details but will slow down code
  int i;
  for (i = 0; i < maxIter; i++) {
    if (dot(z, z) > 4.0) break;
    z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
  }

  //-- Smooth coloring
  float color = float(i) - log2(log(length(z)));
  vec3 col = 0.3 + 0.5*cos(3.0 + color*0.05 + vec3(1.0, 0.6, 0.1)); //-- Colouring trick by Inigo Quilez!
  gl_FragColor = vec4(col, 1.0);

}
