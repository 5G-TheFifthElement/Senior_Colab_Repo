% Parameters
total_bits = 10000000;       % Total number of bits to simulate    
power = 1e-7;                 % Signal power at the receiver
voltage = sqrt(power);        % Voltage for signal mapping
threshold = 0;                % Detection threshold for BPSK

% SNR values
SNR_dB_values = 0:2:20;       % SNR from 0 to 20 dB in steps of 2

% Initialize BER for BPSK
ber_BPSK = [];                     

% Loop for SNR values to compute BER for BPSK
for snr_db = SNR_dB_values
    disp(['Processing SNR: ', num2str(snr_db), ' dB']); % Debugging SNR iteration
    
    % Convert SNR from dB to linear scale
    snr_linear = 10^(snr_db / 10);
    
    % Compute noise variance
    noise_variance = power / snr_linear;
    
    % Generate random bits (0's and 1's)
    bits = randi([0, 1], 1, total_bits);
    
    %% BPSK Mapping Simulation
    transmitted_signal_BPSK = -(voltage * (2 * bits - 1));
    
    % Generate AWGN noise for BPSK
    noise_real = (1 / sqrt(2)) * sqrt(noise_variance) * randn(1, total_bits);
    noise_imag = (1 / sqrt(2)) * sqrt(noise_variance) * randn(1, total_bits);
    noise = noise_real + 1j * noise_imag;  % Complex Gaussian noise

    % Generate Channel Coefficant 
    chan_coeff = sqrt(noise_variance) * randn(1, total_bits);
    chan_coeff_noise = sqrt(noise_variance) * randn(1, total_bits);
    estimated_coeff = (chan_coeff) + 1j * (chan_coeff_noise);

    % Received signal for BPSK mapping
    received_signal_BPSK = transmitted_signal_BPSK + noise;
    
    % Decode received bits
    received_signal_real = real(received_signal_BPSK / estimated_coeff);
    decoded_bits_BPSK = double(received_signal_real < 0);
    
    % Compute BER
    current_ber = sum(decoded_bits_BPSK ~= bits) / total_bits;
    ber_BPSK = [ber_BPSK, current_ber];
    
    % Display BER value for debugging
    disp(['SNR = ', num2str(snr_db), ' dB, BER = ', num2str(current_ber)]);
end

% Plot BER vs. SNR for BPSK
figure;
semilogy(SNR_dB_values, ber_BPSK, 'o-', 'DisplayName', 'Simulated BER for BPSK');     
ylim([1e-7, 1]);   % Ensure all BER values are visible
xlim([0, 20]);     % Explicitly set x-axis to full range
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title(['BER vs SNR for ', num2str(total_bits), ' bits']);
grid on;
legend;
