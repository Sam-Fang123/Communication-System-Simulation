

function [data_hat_dec data_hat_bit]=SE_MMSE(sys_par,tx_par,rx_par,H,Y,noise_pwr,data)

data_hat_dec = data.dec_data;
data_hat_bit = data.bit_data;
