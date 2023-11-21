#define TMIN 0.1
#define TMAX 20.0
#define RAYMARCH_TIME 128
#define PRECISION .001

vec2 fixUV(in vec2 c) {
  return (2. * c - iResolution.xy) / min(iResolution.x, iResolution.y);
}

// 球体的符号距离函数
float sdfSphere(in vec3 p) { return length(p - vec3(0., 0., 2.)) - 1.5; }

// 光线步进
float rayMarch(in vec3 ro, in vec3 rd) {
  float t = TMIN;
  for (int i = 0; i < RAYMARCH_TIME && t < TMAX; i++) {
    vec3 p = ro + t * rd; // 步进
    float d = sdfSphere(p);
    if (d < PRECISION) {
      break;
    }
    t += d;
  }
  return t;
}

// 计算法向量
vec3 calcNormal(in vec3 p) {
  const float h = 0.0001;
  const vec2 k = vec2(1, -1);
  return normalize(
      k.xyy * sdfSphere(p + k.xyy * h) + k.yyx * sdfSphere(p + k.yyx * h) +
      k.yxy * sdfSphere(p + k.yxy * h) + k.xxx * sdfSphere(p + k.xxx * h));
}

vec3 render(in vec2 uv) {
  vec3 color = vec3(0.);
  vec3 ro = vec3(0., 0., -2.); // 相机位置
  vec3 rd = normalize(vec3(uv, 0.) - ro);
  vec3 light = vec3(1., 2., 0.); // 光源
  float t = rayMarch(ro, rd);
  if (t < TMAX) {
    vec3 p = ro + t * rd;          // 当前位置
    vec3 n = calcNormal(p);        // 法向量
    float dif = clamp(dot(normalize(light - p), n), 0., 1.);
    float amb = .5 + .5 * dot(n, vec3(0., 1., 0.));     // 环境光
    color = amb * vec3(.25, .25, .25) + dif * vec3(1.); // 叠加
  }
  return color;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fixUV(fragCoord);
  vec3 color = render(uv);
  fragColor = vec4(color, 1.); // rgba
}
