clear
batch = 100e3;
symbols = 64;
sps = 8;
sym_rate = 1e6;

for esno=10:2:20
    esno
    sprintf('0.3')
    [~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, esno, 0.3);
    roff_3 = single(QPSK);

    sprintf('0.4')
    [~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, esno, 0.4);
    roff_4 = single(QPSK);

    sprintf('0.5')
    [~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, esno, 0.5);
    roff_5 = single(QPSK);

    sprintf('0.6')
    [~, QPSK] = generate_signal_roll_off('QPSK', 0, batch, symbols, sps, sym_rate, esno, 0.6);
    roff_6 = single(QPSK);

    save(sprintf('qpsk_awgn_sym%d_sps%d_esno%d.dat', symbols, sps, esno))
end