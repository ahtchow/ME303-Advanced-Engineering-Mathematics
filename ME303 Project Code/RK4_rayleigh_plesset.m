function [R_fwd, V_fwd] = RK4_rayleigh_plesset(R_cur, V_cur, rho, sigma, mu, P_o, Reversal, dt)

% RK2: y_i+1 = y_i + Δt * (( f(t,y)* + f(t,y)) / 2 )

% (1): R_i+1 = Ri + Δt * R_i'
% (2): V_i+1 = Vi + Δt * V_i'

V_slope=@(R, V)(( -P_o - ((4*mu*V)/R) - ((2*sigma)/R) - (1.5*V*V*rho) ) / (R*rho));

% R at t_i+1 using i values
R1 = R_cur + (dt) * V_cur;
V1_slope =  V_slope(R_cur, V_cur);
V1 = V_cur + (dt) * V1_slope;

% R at t_i+1/2 using i+1/2* values
R2_slope = V1; 
R2 = R_cur + (dt/2) * R2_slope; 
V2_slope =  V_slope(R1, V1);
V2 = V_cur + (dt/2) * V2_slope;

% R at t_i+1/2 using i+1/2** values
R3_slope = V2;
R3 = R_cur + (dt/2) * R3_slope;
V3_slope = V_slope(R2, V2);
V3 = V_cur + (dt/2) * V3_slope;

% R at t_i+1 using i+1/2** values
V4_slope = V_slope(R3, V3);
V4 =  V_cur + (dt) * V4_slope;

% Modified Slopes
R_slope = (1/6) *((V1+V4) + 2*(V2+V3));
V_slope = (1/6) *((V1_slope+V4_slope) + 2*(V2_slope+V3_slope));

%fprintf('\n slope = %d', R_slope);

% RK4
R_fwd = R_cur + dt * R_slope;
V_fwd = V_cur + dt * V_slope;

if R_fwd < Reversal
    V_fwd = -V_fwd;
end

end

