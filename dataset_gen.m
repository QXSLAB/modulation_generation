clear
symbols = 256;
sps = 8;
sym_rate = 1e6;
snr = 50;
batch = 1e6;
[s, qam16] = generate_signal('QAM', 4, batch, symbols, sps, sym_rate, snr);