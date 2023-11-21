#define PI 3.1415926535
#define TMIN 0.1
#define TMAX 20.
#define RAYMARCH_TIME 128
#define PRECISION .001
#define AA 3

vec2 fixUV(in vec2 c) {
  return (2. * c - iResolution.xy) / min(iResolution.x, iResolution.y);
}

// 球体的符号距离函数
float sdfSphere(in vec3 p) { return length(p) - 1.; }

float sdfPlane(in vec3 p) { return p.y; }

float map(in vec3 p) {
  float d = sdfSphere(p);
  d = min(d, sdfPlane(p + vec3(0., 1., 0.)));
  return d;
}

// 光线步进
float rayMarch(in vec3 ro, in vec3 rd) {
  float t = TMIN;
  for (int i = 0; i < RAYMARCH_TIME && t < TMAX; i++) {
    vec3 p = ro + t * rd;
    float d = map(p);
    if (d < PRECISION)
      break;
    t += d;
  }
  return t;
}

// 计算法向量

// https://iquilezles.org/articles/normalsSDF
vec3 calcNormal(in vec3 p) {
  const float h = 0.0001;
  const vec2 k = vec2(1, -1);
  return normalize(k.xyy * map(p + k.xyy * h) + k.yyx * map(p + k.yyx * h) +
                   k.yxy * map(p + k.yxy * h) + k.xxx * map(p + k.xxx * h));
}

mat3 setCamera(vec3 ta, vec3 ro, float cr) {
  vec3 z = normalize(ta - ro);
  vec3 cp = vec3(sin(cr), cos(cr), 0.);
  vec3 x = normalize(cross(z, cp));
  vec3 y = cross(x, z);
  return mat3(x, y, z);
}

// https://iquilezles.org/articles/rmshadows
float softShadow(in vec3 ro, in vec3 rd, float k) {
  float res = 1.0;
  float ph = 1e20;
  for (float t = TMIN; t < TMAX;) {
    float h = map(ro + rd * t);
    if (h < 0.001)
      return 0.0;
    float y = h * h / (2.0 * ph);
    float d = sqrt(h * h - y * y);
    res = min(res, k * d / max(0.0, t - y));
    ph = h;
    t += h;
  }
  return res;
}

vec3 render(vec2 uv) {
  vec3 color = vec3(0.);
  vec3 ro = vec3(4. * cos(iTime), 1., 4. * sin(iTime));
  if (iMouse.z > 0.01) {
    float theta = iMouse.x / iResolution.x * 2. * PI;
    ro = vec3(4. * cos(theta), 1., 4. * sin(theta));
  }
  vec3 ta = vec3(0.);
  mat3 cam = setCamera(ta, ro, 0.);
  vec3 rd = normalize(cam * vec3(uv, 1.));
  float t = rayMarch(ro, rd);
  if (t < TMAX) {
    vec3 p = ro + t * rd;
    vec3 n = calcNormal(p);
    vec3 light = vec3(2., 3., 0.);
    float dif = clamp(dot(normalize(light - p), n), 0., 1.);
    float st = rayMarch(p,normalize(light - p));
    if(st < TMAX){
      dif *= .1;
    }
    // p += PRECISION * n;
    // dif *= softShadow(p, normalize(light - p), 10.);
    float amb = 0.5 + 0.5 * dot(n, vec3(0., 1., 0.));
    color = amb * vec3(0.23) + dif * vec3(1.);
  }
  return sqrt(color);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec3 color = vec3(0.);
  for (int m = 0; m < AA; m++) {
    for (int n = 0; n < AA; n++) {
      vec2 offset = 2. * (vec2(float(m), float(n)) / float(AA) - .5);
      vec2 uv = fixUV(fragCoord + offset);
      color += render(uv);
    }
  }
  fragColor = vec4(color / float(AA * AA), 1.);
}