%-----------------------------------------------------------------------------%
% Energy Production Optimization Model
% 
% Purpose: Minimize operational costs of a power grid while meeting demand,
%          respecting emission limits, and maintaining grid stability
%
% Author: Nia Tatrishvili
% Date: 06.04.2025
% Version: 1.0
%-----------------------------------------------------------------------------%

% Variables

int: P;  % Number of power plants
set of int: PLANTS = 1..P;
enum PLANT_TYPE = {Fossil, Nuclear, Renewable};

int: T;  % Number of time periods (e.g., 24 hours)
set of int: TIME = 1..T;
set of int: SIZE = 0..300000;

array[PLANTS] of PLANT_TYPE: plant_type;
array[PLANTS] of SIZE: cost_per_unit;
array[PLANTS] of SIZE: fixed_cost;
array[PLANTS] of SIZE: min_output;
array[PLANTS] of SIZE: max_output;
array[PLANTS] of SIZE: ramp_rate;
array[PLANTS] of SIZE: emissions;
array[PLANTS] of SIZE: emission_limit;

array[TIME] of SIZE: demand;
array[TIME] of SIZE: transmission_cap;
array[PLANTS, TIME] of float: renewable_availability;

array[PLANTS, TIME] of var SIZE: generation;

% Constraints
% Demand fulfillment
constraint forall(t in TIME) (
    sum(p in PLANTS)(generation[p, t]) >= demand[t]
);

% Transmission capacity
constraint forall(t in TIME) (
    sum(p in PLANTS)(generation[p, t]) <= transmission_cap[t]
);

% Emission limits
constraint forall(p in PLANTS) (
    sum(t in TIME)(generation[p, t] * emissions[p]) <= emission_limit[p]
);

% Ramp-up/down constraints
constraint forall(p in PLANTS, t in 2..T) (
    abs(generation[p, t] - generation[p, t-1]) <= ramp_rate[p]
);

% Min/max output constraints
constraint forall(p in PLANTS, t in TIME) (
    generation[p, t] >= min_output[p] * (exists(t2 in TIME)(generation[p, t2] > 0)) \/ generation[p, t] == 0
);
constraint forall(p in PLANTS, t in TIME) (
    generation[p, t] <= max_output[p]
);

% Renewable availability (only for renewable plants)
constraint forall(p in PLANTS where plant_type[p] == Renewable, t in TIME) (
    generation[p, t] <= renewable_availability[p, t]
);

% Objective: Minimize total cost
var SIZE: total_cost = sum(p in PLANTS, t in TIME)(
    generation[p, t] * cost_per_unit[p]
) + sum(p in PLANTS)(fixed_cost[p] * exists(t in TIME)(generation[p, t] > 0));

solve :: 
    int_search(generation, smallest, indomain_min, complete)
minimize total_cost;

% Output
output [
    "Total Cost = " ++ show(total_cost) ++ "\n" ++
    "Generation Schedule:\n" ++
    concat([
        "Time " ++ show(t) ++ ": " ++ 
        concat([show(generation[p, t]) ++ " (P" ++ show(p) ++ ") " | p in PLANTS]) ++ "\n"
    | t in TIME
])];