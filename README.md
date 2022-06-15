# TII_HIRUL_OPF

# Key words

Battery energy storage system, Remaining useful life, Feasible operation domain, Health condition, Circular
economy, Sustainability

# Code and simulation description

Here we mainly present the constant current (CC) operation mode code for data generation, as for constant current - constant voltage (CCCV) the code can be developed similarly. We will update full version of code on GitHub recently. To run each code, the simulink model within the same folder should be opened properly. And for Simulink, the models apply to Matlab version R2020b and above. Below we introduce how the code corresponds to numerical results in the manuscript. The explanations of main code are listed and for auxiliary functions, the explanations are attached in the code files.

1. RUL\_SOCrange: obtain relationship between RUL and SOC bounds.

    CCCV\_RUL\_SOCrange.m: obtain RUL under different SOC ranges in CCCV mode.
    
2. CC\_RUL\_Id\_Ic: obtain relationship between RUL and charging/discharging current, the derived voltage region and the estimation of confidence interval.

    CC\_RUL\_Id\_Ic.m: obtain RUL data under different SOC ranges/scenarios and charging/discharging current in CC mode.

    VI\_region\_A.m: obtain voltage region based on current region $\mathcal{A}$ under different SOC ranges/scenarios in CC mode.

    CC\_CI.m: obtain RUL data under different SOC ranges/scenarios and currents around the feasible region upper right boundaries to facilitate the construction of confidence interval in CC mode.

3. CC\_HIs: obtain the shrinkage of feasible operation region as battery degrades.

    critical\_F1.m: get the boundary point for feasible region $\mathcal{F}_1$.

    VI\_region\_A.m: get voltage region based on current region $\mathcal{A}$ under different SOC ranges/scenarios in CC mode.

4. CC\_validation: obtain verification part 1 and part 2 based on the simulation settings.

    fixed\_SOC.m: obtain RUL when SOC is fixed in each scenario. Currents are sampled from feasible region (change SOC range 5 times at different HIs); correspond to part 1 simulation in the manuscript.

    change\_SOC.m: obtain RUL when SOC changes in each scenario (change SOC range 3 times, forming 6 cases at different HIs). Currents are sampled from feasible region; correspond to part 2 simulation in the manuscript.
    
5. OPF: obtain battery operational constraints and the simulation on power system optimal power flow (OPF).

    main.m: obtain OPF results with \& without RUL constraint to compare power system operation.

    CC\_validation: verify battery RUL with RUL-constrained OPF results in CC mode.


# Citation

If the simulation or code is used in your paper/experiments, please cite the following paper.

```
@ARTICLE{9783055,
  author={Xie, Jiahang and Weng, Yu and Nguyen, Hung D.},
  journal={IEEE Transactions on Industrial Informatics}, 
  title={Health-informed Lifespan-oriented Circular Economic Operation of Li-ion Batteries}, 
  year={2022},
  volume={},
  number={},
  pages={1-1},
  doi={10.1109/TII.2022.3178375}}
```
