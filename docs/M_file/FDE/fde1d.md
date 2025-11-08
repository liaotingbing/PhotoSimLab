---
sidebar_position: 2
---

# FDE 1D 案例

## 矩形波导

计算的分量：Ex Ey Ez Hx Hy Hz

对对角介电常数和对角磁导率

#### 矩形波导参数
```matlab
%% 全局参数
lx = 8;
ly = 0;
dx = 0.1;
dy = 0.1;
lambda = 1.55;
w = 3;
h = 2;
index = 1.8;
backIndex = 1.1;
nmodes = 20;
nmodes_max = 100;
toler = 1e-6;
search_index = 1.8;
```

### 结构
![alt text](matlab/images/fde1d/structure.png)


### 有效折射率

```matlab
   1.7860318116219271e+00
   1.7836316756322448e+00
   1.7436937072801406e+00
   1.7339479645797709e+00
   1.6716135889358676e+00
   1.6491488103086023e+00
   1.5672636969685523e+00
   1.5261552087588375e+00
   1.4266928729016972e+00
   1.3618391181841094e+00
   1.2457437064098031e+00
   1.1690671850945771e+00
   1.0933024030191449e+00
   1.0870339516400054e+00
   1.0716269403478587e+00
   1.0528882797927837e+00
   1.0397126751040013e+00
   1.0077052729328424e+00
   9.9817990482246655e-01
   9.1956044078316490e-01

```

### 模场分布

 ![alt text](matlab/images/fde1d/Mode1.png) ![alt text](matlab/images/fde1d/Mode2.png) ![alt text](matlab/images/fde1d/Mode3.png) ![alt text](matlab/images/fde1d/Mode4.png) ![alt text](matlab/images/fde1d/Mode5.png) ![alt text](matlab/images/fde1d/Mode6.png) ![alt text](matlab/images/fde1d/Mode7.png) ![alt text](matlab/images/fde1d/Mode8.png) ![alt text](matlab/images/fde1d/Mode9.png) ![alt text](matlab/images/fde1d/Mode10.png) ![alt text](matlab/images/fde1d/Mode11.png) ![alt text](matlab/images/fde1d/Mode12.png) ![alt text](matlab/images/fde1d/Mode13.png) ![alt text](matlab/images/fde1d/Mode14.png) ![alt text](matlab/images/fde1d/Mode15.png) ![alt text](matlab/images/fde1d/Mode16.png) ![alt text](matlab/images/fde1d/Mode17.png) ![alt text](matlab/images/fde1d/Mode18.png) ![alt text](matlab/images/fde1d/Mode19.png) ![alt text](matlab/images/fde1d/Mode20.png) [alt text](fde1d.md)