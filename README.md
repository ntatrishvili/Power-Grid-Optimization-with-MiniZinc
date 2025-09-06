# Power Grid Optimization with MiniZinc  

This project models and solves the Energy Production Optimization Problem using [MiniZinc](https://www.minizinc.org/).  
The goal is to minimize operational costs of a power grid while:  

- Meeting energy demand across time periods  
- Respecting plant operational limits (min/max output, ramp rates)  
- Enforcing transmission and emission constraints  
- Prioritizing renewable energy sources  

The solver used is COIN-BC, included by default in the MiniZinc distribution.  

For a full analysis and experimental results, see the [project report](./report_minizinc.pdf).  

---

## Model Highlights  
- Decision Variables: Energy generation per plant per time period  
- Constraints:  
  - Demand fulfillment  
  - Transmission capacity  
  - Emission limits  
  - Ramp-up / ramp-down stability  
  - Renewable availability bounds  
  - Plant-specific min/max output  
- Objective: Minimize total fuel and fixed operational costs  

---

## Usage  

### Requirements  
- [MiniZinc IDE](https://www.minizinc.org/software.html) or MiniZinc CLI  
- COIN-BC solver (bundled with MiniZinc)  

### Running a Dataset  

Replace `power_grid_model_0.dzn` with any dataset file from the `data/` folder.  

---

## Datasets  
The `data/` folder contains multiple dataset instances of varying size and complexity.  
- Small instances: test basic constraint satisfaction  
- Medium instances: include daily demand cycles and ramp rate constraints  
- Large instances: feature multiple fossil, nuclear, and renewable plants  
- Extra-large instances: test scalability under multi-day, seasonal variations  

---

## Results  
- Small and medium models solved optimally within seconds.  
- Larger instances required advanced search strategies (variable/value ordering, restarts).  
- Very large instances may not reach provable optimality within 15 minutes.  

For detailed results and solver performance tables, see the [report](./report_minizinc.pdf).  

---

## Acknowledgements  
This project was developed as part of an [ATHENS](https://athensnetwork.eu/athens-programme.html) project at Universidad Politécnica de Madrid in March 2025.  

Author: Nia Tatrishvili  

---

## License  
This repository is provided for academic and educational purposes only.  
