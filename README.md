# shadertoy-tutorials

## 坐标操作

```cpp
void mainImage( out vec4 fragColor, in vec2 fragCoord ){
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord / iResolution.xy;
    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(uv.xyx+vec3(0,2,4));
    // Output to screen
    fragColor = vec4(col,1.0);
}
```

![](https://static.gausszhou.top/data/image/learn/shader-toy/shadertoy_00_1.png)

```cpp
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord / iResolution.xy;
  fragColor = vec4(uv, 0, 1.); // rgba
}
```

![](https://static.gausszhou.top/data/image/learn/shader-toy/shadertoy_01_1.png)


```cpp
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord / iResolution.xy - vec2(.5);
  float c = 0.0;
  float r = 0.3;
  if (length(uv) < r) {
    c = 1.0;
  }
  fragColor = vec4(vec3(c), 1.0); // rgba
}
```

![](https://static.gausszhou.top/data/image/learn/shader-toy/shadertoy_01_2.png)


```cpp
// -0.5 .5
void mainImage (out vec4 fragColor, in vec2 fragCoord){
    vec2 uv = (fragCoord - 0.5 * iResolution.xy)/min(iResolution.x,iResolution.y);
    float c = 0.0;
    float r = 0.3;
    if(length(uv) < r){
      c = 1.0;
    }
    fragColor = vec4(vec3(c),1.0); // rgba
}
```

![](https://static.gausszhou.top/data/image/learn/shader-toy/shadertoy_01_3.png)

## 坐标绘制

```cpp
vec3 NumberPlane(vec2 uv){
vec3 color = vec3(0.0);
  vec2 cell = fract(uv);

  if(cell.x <= fwidth(uv.x)){
    color += vec3(1.0);
  }
  if(cell.y <= fwidth(uv.y)){
    color += vec3(1.0);
  }
  if(abs(uv.y) < 2. * fwidth(uv.y)){
    color = vec3(1., 0., 0.);
  }  
  if(abs(uv.x) < 2. * fwidth(uv.x)){
    color = vec3(0., 1., 0.);
  }  
  return color;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord){
  vec2 uv = 3.0 * (2.0 * fragCoord - iResolution.xy) / min(iResolution.x,iResolution.y) ;
  vec3 color = NumberPlane(uv);
  fragColor = vec4(color, 1.0);
}

```

![](https://static.gausszhou.top/data/image/learn/shader-toy/shadertoy_02_1.png)

```cpp
vec3 Grid(in vec2 uv){
  vec3 color = vec3(0.);
  vec2 fraction = fract(uv);
  if(abs(uv.x) <= 2. * fwidth(uv.x)){
    color.g = 1.;
  }else if (abs(uv.y) <= 2. * fwidth(uv.y)){
    color.r = 1.;
  } else if (fraction.x < 2. * fwidth(uv.x) || fraction.y < 2. * fwidth(uv.y)){
    color = vec3(1.);
  }
  return color;
}

vec2 fixUV(in vec2 c){
  return 3. * ( 2. * c - iResolution.xy) / min (iResolution.x, iResolution.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord){
  vec2 uv = fixUV(fragCoord);
  vec3 color = Grid(uv);
  fragColor = vec4(color, 1.0);
}
```

![](https://static.gausszhou.top/data/image/learn/shader-toy/shadertoy_02_2.png)


## 线段绘制

```cpp
vec3 Grid(in vec2 uv){
  vec3 color = vec3(0.);
  vec2 fraction = fract(uv);
  if(abs(uv.x) <= 2. * fwidth(uv.x)){
    color.g = 1.;
  }else if (abs(uv.y) <= 2.* fwidth(uv.y)){
    color.r = 1.;
  } else if (fraction.x < 2. * fwidth(uv.x) || fraction.y < 2. * fwidth(uv.y)){
    color = vec3(1.);
  }
  return color;
}

vec2 fixUV(in vec2 c){
  return 3. * ( 2. * c - iResolution.xy) / min (iResolution.x, iResolution.y);
}

float segment(in vec2 p, in vec2 a, in vec2 b, in float w){
  float f = 0.;
  vec2 ba = b - a;
  vec2 pa = p - a;
  float proj = clamp(dot(pa, ba) / dot(ba, ba), 0., 1.);
  float d = length(proj * ba - pa);
  if(d <= w){
    f = 1.;
  } 
  return f;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord){
  vec2 uv = fixUV(fragCoord);
  vec3 color = Grid(uv);
  color = mix(color, vec3(1., 1., 0.), segment(uv,vec2(-2., -2.),vec2(2., 1.),fwidth(uv.x))) ;
  fragColor = vec4(color, 1.0);
}
```


![](https://static.gausszhou.top/data/image/learn/shader-toy/shadertoy_03_1.png)


```cpp
#define PI 3.14159265

vec3 Grid(in vec2 uv){
  vec3 color = vec3(0.);
  vec2 fraction = fract(uv);
  if(abs(uv.x) <=  2. * fwidth(uv.x)){
    color.g = 1.;
  }else if (abs(uv.y) <= 2. * fwidth(uv.y)){
    color.r = 1.;
  } else if (fraction.x < 2. * fwidth(uv.x) || fraction.y < 2. * fwidth(uv.y)){
    color = vec3(1.);
  }
  return color;
}

vec2 fixUV(in vec2 c){
  return 3. * ( 2. * c - iResolution.xy) / min (iResolution.x, iResolution.y);
}

float segment(in vec2 p, in vec2 a, in vec2 b, in float w){
  float f = 0.;
  vec2 ba = b - a;
  vec2 pa = p - a;
  float proj = clamp(dot(pa, ba) / dot(ba, ba), 0., 1.);
  float d = length(proj * ba - pa);
  if(d <= w){
    f = 1.;
  } 
  return f;
}

float func(in float x){
  float T = 3.;
  return sin( 2. * PI / T * x);
}

float funcPlot(in vec2 uv){
  float f = 0.;
  for(float x = 0. ; x <= iResolution.x; x += 1.){
    float fx = fixUV(vec2(x, 0.)).x;
    float nfx = fixUV(vec2(x + 1., 0.)).x;
    f += segment(uv, vec2(fx, func(fx)),vec2(nfx,func(nfx)), fwidth(uv.x));
  }
  return clamp(f, 0., 1.);
}
void mainImage(out vec4 fragColor, in vec2 fragCoord){
  vec2 uv = fixUV(fragCoord);
  vec3 color = Grid(uv);
  color = mix(color, vec3(1., 1., 0.), funcPlot(uv)) ;
  fragColor = vec4(color, 1.0);
}
```

![](https://static.gausszhou.top/data/image/learn/shader-toy/shadertoy_03_2.png)


## 平滑函数

```cpp
#define PI 3.14159265

vec3 Grid(in vec2 uv){
  vec3 color = vec3(0.);
  vec2 fraction = fract(uv);
  color = vec3(smoothstep(4.0 * fwidth(uv.x),3.9 * fwidth(uv.x),fraction.x));
  color += vec3(smoothstep(4.0 * fwidth(uv.y),3.9 * fwidth(uv.y),fraction.y));
  color.rb *= 1. - smoothstep(4. * fwidth(uv.x), 3.9 * fwidth(uv.x), abs(uv.x));
  color.gb *= 1. - smoothstep(4. * fwidth(uv.y), 3.9 * fwidth(uv.y), abs(uv.y));
  return color;
}

vec2 fixUV(in vec2 c){
  return 3. * ( 2. * c - iResolution.xy) / min (iResolution.x, iResolution.y);
}

float segment(in vec2 p, in vec2 a, in vec2 b, in float w){
  float f = 0.;
  vec2 ba = b - a;
  vec2 pa = p - a;
  float proj = clamp(dot(pa, ba) / dot(ba, ba), 0., 1.);
  float d = length(proj * ba - pa);
  if(d <= w){
    f = 1.;
  } 
  f = smoothstep(w, 0.95 * w, d);
  return f;
}

float func(in float x){
  return smoothstep(.5, 0., x);
}

float funcPlot(in vec2 uv){
  float f = 0.;
  for(float x = 0. ; x <= iResolution.x; x += 1.){
    float fx = fixUV(vec2(x, 0.)).x;
    float nfx = fixUV(vec2(x + 1., 0.)).x;
    f += segment(uv, vec2(fx, func(fx)),vec2(nfx,func(nfx)), 2. * fwidth(uv.x));
  }
  return clamp(f, 0., 1.);
}
void mainImage(out vec4 fragColor, in vec2 fragCoord){
  vec2 uv = fixUV(fragCoord);
  vec3 color = Grid(uv);
  color = mix(color, vec3(1., 1., 0.), funcPlot(uv)) ;
  fragColor = vec4(color, 1.0);
}
```

![](https://static.gausszhou.top/data/image/learn/shader-toy/shadertoy_04_1.png)


```cpp
vec2 fixUV(in vec2 c){
  return 3. * ( 2. * c - iResolution.xy) / min (iResolution.x, iResolution.y);
}

void mainImage (out vec4 fragColor, in vec2 fragCoord){
    vec2 uv = fixUV(fragCoord);
    vec3 color = vec3(0.);
    color = vec3(smoothstep(1., .95, length(uv)));
    fragColor = vec4(vec3(color),1.0); // rgba
}
```
![](https://static.gausszhou.top/data/image/learn/shader-toy/shadertoy_04_2.png)


## 2D 分形的绘制

```cpp
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
```

![](https://static.gausszhou.top/data/image/learn/shader-toy/shadertoy_18_1.png)