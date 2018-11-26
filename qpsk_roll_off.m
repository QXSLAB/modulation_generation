clear
batch = 100e3;
symbols = 128;
sps = 8;
sym_rate = 1e6;
snr = 10;

% sprintf('0.25')
% [~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, snr, 0.25);
% roff_25 = single(QPSK);

sprintf('0.3')
[~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, snr, 0.3);
roff_3 = single(QPSK);

% sprintf('0.35')
% [~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, snr, 0.35);
% roff_35 = single(QPSK);
% 
sprintf('0.4')
[~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, snr, 0.4);
roff_4 = single(QPSK);
% 
% sprintf('0.45')
% [~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, snr, 0.45);
% roff_45 = single(QPSK);

sprintf('0.5')
[~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, snr, 0.5);
roff_5 = single(QPSK);

% sprintf('0.55')
% [~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, snr, 0.55);
% roff_55 = single(QPSK);
% 
sprintf('0.6')
[~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, snr, 0.6);
roff_6 = single(QPSK);
% 
% sprintf('0.65')
% [~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, snr, 0.65);
% roff_65 = single(QPSK);

% sprintf('0.7')
% [~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, snr, 0.7);
% roff_7 = single(QPSK);

save(sprintf('qpsk_butter_3_4_5_6_snr%d.dat', snr))