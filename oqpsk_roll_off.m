clear
batch = 100e3;
symbols = 128;
sps = 16;
sym_rate = 1e6;

for esno=10:2:20
    esno
    sprintf('0.3')
    [~, oqpsk] = generate_signal_roll_off('OQPSK', 0, batch, symbols, sps, sym_rate, esno, 0.3);
    roff_3 = single(oqpsk);

    sprintf('0.4')
    [~, oqpsk] = generate_signal_roll_off('OQPSK', 0, batch, symbols, sps, sym_rate, esno, 0.4);
    roff_4 = single(oqpsk);

    sprintf('0.5')
    [~, oqpsk] = generate_signal_roll_off('OQPSK', 0, batch, symbols, sps, sym_rate, esno, 0.5);
    roff_5 = single(oqpsk);

    sprintf('0.6')
    [~, oqpsk] = generate_signal_roll_off('OQPSK', 0, batch, symbols, sps, sym_rate, esno, 0.6);
    roff_6 = single(oqpsk);

    save(sprintf('oqpsk_awgn_sym%d_sps%d_esno%d.dat', symbols, sps, esno))
end