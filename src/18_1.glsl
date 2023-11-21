// 坐标转换
vec2 fixUV(in vec2 c) {
  return 1.2* (2. * c - iResolution.xy) / min(iResolution.x, iResolution.y);
}

// 复数乘法
vec2 cmul(vec2 a, vec2 b) {
  return vec2(a.x * b.x - a.y * b.y, a.y * b.x + a.x * b.y);
}

// 复数除法
vec2 cdiv(vec2 a, vec2 b) {
  float d = dot(b, b);
  return vec2(dot(a, b), a.y * b.x - a.x * b.y) / d;
}

// 复数的幂
vec2 cpow(vec2 a, float n) {
  float l = length(a);
  float an = atan(a.y, a.x);
  return vec2(cos(an * n), sin(an * n) * pow(l, n));
}

//
vec2 integral(vec2 x) {
  x /= 2.;
  return floor(x) + max(2. * fract(x) - 1., 0.);
}


float checkerboard(vec2 p){
  vec2 fw = fwidth(p);
  vec2 i = integral(p + 0.5 * fw) - integral(p- 0.5 * fw);
  i /= fw;
  return i.x + i.y - 2. * i.x * i.y;
}

float grid(vec2 p){
  vec2 q = p * 16.;
  return .5 + .5 * checkerboard(q);
}


void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fixUV(fragCoord);

  vec3 col = vec3(1.);

  vec2 z = uv;
  vec2 c = vec2(0.28, -0.49);
  vec2 dz = vec2(1., 0.);
  float t = 1.;
  vec2 phi = z;

  for (; t < 512.; t++) {
    if (length(z) > 1024.) {
      break;
    }
    dz = cmul(z, dz) * 2.;
    z = cmul(z, z) + c;

    float n = pow(.5, t);
    vec2 c = cdiv(z, z - c);
    phi = cmul(phi,cpow(c, n));
  }

  if (t > 511.) {
    col = vec3(0.7, 0.4, 0.1);
  } else {
    float d = length(z) * log(length(z)) / length(dz);
    col *= grid(phi);
    col *= smoothstep(0., 0.01, d);
    col *= 0.7 + 0.2 * sin(120. * d);
  }

  fragColor = vec4(col, 1.);
}