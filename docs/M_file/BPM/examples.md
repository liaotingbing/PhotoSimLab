---
sidebar_position: 2
---


# Y波导示例

## 代码
```
lx = 20;
ly = 10;
lz = 100;
dx = 0.1;
dy = 0.1;
dz = 1;
lambda = 1;
input_mode_select = 1;
pade_order = 6;
alpha = 0.5;
plot_incident_field = 0;
plot_structure = 0;
dynamic_neff = 1;
load_neff = 1;
```

## 结构

![alt text](matlab/st.png)
<!-- ![alt text](matlab/eps_xy.gif) -->


## 入射电场
![alt text](matlab/incident_eletric_field.png)

## 参考折射率

![alt text](matlab/effective_neff.png)

<!-- ## PEC边界结果

![text](matlab/Pade_1_pec_Et.gif) 
![text](matlab/Pade_3_pec_Et.gif) 
![text](matlab/Pade_6_pec_Et.gif) -->

## PML边界结果

### Pade(1,0)
![alt text](matlab/Pade_1_pml_Et.gif)
![alt text](matlab/Y=0_Pade_1_pml_Et.gif)


### Pade(2,2)
![alt text](matlab/Pade_3_pml_Et.gif)
![alt text](matlab/Y=0_Pade_3_pml_Et.gif)

### Pade(5,5)
![alt text](matlab/Pade_6_pml_Et.gif)
![alt text](matlab/Y=0_Pade_6_pml_Et.gif)