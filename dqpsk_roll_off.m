clear
batch = 100e3;
symbols = 128;
sps = 16;
sym_rate = 1e6;

for esno=10:2:20
    esno
    sprintf('0.3')
    [~, dqpsk] = generate_signal_roll_off('DQPSK', 0, batch, symbols, sps, sym_rate, esno, 0.3);
    roff_3 = single(dqpsk);

    sprintf('0.4')
    [~, dqpsk] = generate_signal_roll_off('DQPSK', 0, batch, symbols, sps, sym_rate, esno, 0.4);
    roff_4 = single(dqpsk);

    sprintf('0.5')
    [~, dqpsk] = generate_signal_roll_off('DQPSK', 0, batch, symbols, sps, sym_rate, esno, 0.5);
    roff_5 = single(dqpsk);

    sprintf('0.6')
    [~, dqpsk] = generate_signal_roll_off('DQPSK', 0, batch, symbols, sps, sym_rate, esno, 0.6);
    roff_6 = single(dqpsk);

    save(sprintf('dqpsk_awgn_sym%d_sps%d_esno%d.dat', symbols, sps, esno))
end