#define PI 3.1415926535
#define TMIN 0.1
#define TMAX 20.0
#define RAYMARCH_TIME 128
#define PRECISION .001

// -1 1
vec2 fixUV(in vec2 c) {
  return (2. * c - iResolution.xy) / min(iResolution.x, iResolution.y);
}

// 球体的符号距离函数
float sdfSphere(in vec3 p) { return length(p) - .5; }

// 立方体的符号距离函数
float sdfCube(in vec3 p, in vec3 b) {
  vec3 d = abs(p) - b;
  return length(max(d, 0.)) + min(max(d.x, max(d.y, d.z)), 0.);
}

// 光线步进
float rayMarch(in vec3 ro, in vec3 rd) {
  float t = TMIN;
  for (int i = 0; i < RAYMARCH_TIME && t < TMAX; i++) {
    vec3 p = ro + t * rd; // 步进
    float d = sdfCube(p, vec3(.5, .5, .5));
    if (d < PRECISION) {
      break;
    }
    t += d;
  }
  return t;
}

vec3 calcNormal(in vec3 p) {
  const float h = 0.0001;
  const vec2 k = vec2(1, -1);
  return normalize(
      k.xyy * sdfSphere(p + k.xyy * h) + k.yyx * sdfSphere(p + k.yyx * h) +
      k.yxy * sdfSphere(p + k.yxy * h) + k.xxx * sdfSphere(p + k.xxx * h));
}

// 摄像机

mat3 setCamera(vec3 ta, vec3 ro, float cr) {
  vec3 z = normalize(ta - ro);
  vec3 cp = vec3(sin(cr), cos(cr), 0.);
  vec3 x = normalize(cross(z, cp));
  vec3 y = cross(x, z);
  return mat3(x, y, z);
}

// 渲染 计算颜色
vec3 render(in vec2 uv) {
  vec3 color = vec3(0.);
  // 相机位置跟随时间变化
  vec3 ro = vec3(2. * cos(iTime), 1., 2. * sin(iTime));
  if (iMouse.z > 0.01) {
    // 相机位置跟随鼠标位置变化
    float theta = iMouse.x * 2. * PI / iResolution.x;
    ro = vec3(2. * cos(theta), 1., 2. * sin(theta));
  }
  vec3 light = vec3(1., 2., 0.); // 光源
  vec3 ta = vec3(0.);
  mat3 cam = setCamera(ta, ro, 0.);
  vec3 rd = normalize(cam * vec3(uv, 1.));
  float t = rayMarch(ro, rd);
  if (t < TMAX) {
    vec3 p = ro + t * rd;   // 当前位置
    vec3 n = calcNormal(p); // 法向量
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
