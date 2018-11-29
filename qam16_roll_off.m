clear
batch = 100e3;
symbols = 128;
sps = 16;
sym_rate = 1e6;

for esno=10:2:20
    esno
    sprintf('0.3')
    [~, qam16] = generate_signal_roll_off('QAM', 4, batch, symbols, sps, sym_rate, esno, 0.3);
    roff_3 = single(qam16);

    sprintf('0.4')
    [~, qam16] = generate_signal_roll_off('QAM', 4, batch, symbols, sps, sym_rate, esno, 0.4);
    roff_4 = single(qam16);

    sprintf('0.5')
    [~, qam16] = generate_signal_roll_off('QAM', 4, batch, symbols, sps, sym_rate, esno, 0.5);
    roff_5 = single(qam16);

    sprintf('0.6')
    [~, qam16] = generate_signal_roll_off('QAM', 4, batch, symbols, sps, sym_rate, esno, 0.6);
    roff_6 = single(qam16);

    save(sprintf('qam16_awgn_sym%d_sps%d_esno%d.dat', symbols, sps, esno))
end