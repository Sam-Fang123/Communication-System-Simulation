
clear all
clc
u=[1 1 0 0 1 0 1 0 1 1 1 0 0 1 0 1 0 1 1 1 0 0 0 0 0 0 0 0 0];
v=[1 1 1 0 1 0 0 0 1 0 1 0 0 1 1 1 0 0 1 1 1 1 0 1 0 1 1 0 0 1 0 0 0 0 0 0 1 1 1 1 0 1 0 1 0 1 0 0 0 0 1 0 1 0 1 1 0 0];
v_error=[1 1 1 0 1 0 0 1 1 0 1 0 0 1 1 1 0 0 1 1 1 1 1 1 0 1 1 0 0 1 0 0 0 0 0 1 1 1 1 1 0 1 0 1 0 1 0 0 0 1 1 0 1 0 1 1 0 0];
v_decode=[1 1 1 0 1 0 0 0 1 0 1 0 0 1 1 1 0 0 1 1 1 1 0 1 0 1 1 0 0 1 0 0 0 0 0 0 1 1 1 1 0 1 0 1 0 1 0 0 0 0 1 0 1 0 1 1 0 0];
u_decode=[1 1 0 0 1 0 1 0 1 1 1 0 0 1 0 1 0 1 1 1 0 0 0 0 0 0 0 0 0];

v_channel_error=v~=v_error;
v_c_num=sum(v_channel_error)
u_diff=u~=u_decode;
u_diff_num=sum(u_diff)
v_diff=v~=v_decode;
v_diff_num=sum(v_diff)