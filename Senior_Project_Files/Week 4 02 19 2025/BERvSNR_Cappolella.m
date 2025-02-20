% Parameters
total_bits = 1000000;         % Total bits to simulate    
power = 1e-7;                  % Signal power at the receiver
voltage = sqrt(power);         % Voltage for signal mapping 0,1
threshold = voltage / 2;  % Detection threshold for the signal

% SNR values
SNR_dB_values = 10:2:20; % SNR from 10 to 20 dB in steps of 2

% Initialize BER and BER_BPSK
ber = [];                     
ber_BPSK = [];                     

% Loop for SNR value to compute BER including BPSK
for snr_db = SNR_dB_values
    
    % Convert SNR from dB to linear scale
    snr_linear = 10^(snr_db / 10);
    
    % Compute noise variance
    noise_variance = power / snr_linear;
    
    % Generate random bits (0's and 1's)
    bits = randi([0, 1], 1, total_bits);
    
    % 0,1 Mapping Simulation
    transmitted_signal = bits * voltage;
    
    % Generate AWGN noise
    noise = normrnd(0, sqrt(noise_variance), 1, total_bits);
    
    % Received signal for 0,1 mapping
    received_signal = transmitted_signal + noise;
    
    % Decode received bits using the defined threshold
    decoded_bits = double(received_signal >= threshold);
    
    % Compute BER for 0,1 mapping
    ber = [ber, sum(decoded_bits ~= bits) / total_bits];
    

   %% BPSK Mapping Simulation
    % Map bits: 0 -> +1, 1 -> -1
    transmitted_signal_BPSK = -(voltage * (2*bits - 1));
    
    % Generate AWGN noise for BPSK
    noise_BPSK = normrnd(0, sqrt(noise_variance), 1, total_bits);
    
    % Received signal for BPSK mapping
    received_signal_BPSK = transmitted_signal_BPSK + noise_BPSK;
    
    % Decode received bits using the 0 threshold
    decoded_bits_BPSK = double(received_signal_BPSK < 0);
    
    % Compute BER for BPSK mapping
    ber_BPSK = [ber_BPSK, sum(decoded_bits_BPSK ~= bits) / total_bits];
    
end

% Plot results. First figure is SNR vs. BER. 
% Second figure is SNR vs. BER_BPSK
figure;
semilogy(SNR_dB_values, ber, 'o-', 'DisplayName', 'BER vs. SNR');     
ylim([1e-7, 1]);
xlim([10, 20]);
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title(['BER vs SNR for ', num2str(total_bits), ' bits']);
grid on;
legend;


figure;
semilogy(SNR_dB_values, ber_BPSK, 'o-', 'DisplayName', 'BPSK Mapping (0 -> +1, 1 -> -1)');
xlim([10, 20]);
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title(['BPSK BER vs SNR for ', num2str(total_bits), ' bits']);
grid on;
legend;
