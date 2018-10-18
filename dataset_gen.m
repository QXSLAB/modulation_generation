clear
batch = 100e3;
symbols = 128;
sps = 8;
sym_rate = 1e6;
snr = 50;
%single 4 byte, complex=real+imag
%size = symbols*sps*batch*4*2/1024/1024/1024;

sprintf('QPSK')
[~, QPSK] = generate_signal('QPSK', 0, batch, symbols, sps, sym_rate, snr);
QPSK = single(QPSK);

sprintf('QAM16')
[~, QAM16] = generate_signal('QAM', 4, batch, symbols, sps, sym_rate, snr);
QAM16 = single(QAM16);

sprintf('QAM64')
[~, QAM64] = generate_signal('QAM', 8, batch, symbols, sps, sym_rate, snr);
QAM64 = single(QAM64);

sprintf('PAM4')
[~, PAM4] = generate_signal('PAM', 4, batch, symbols, sps, sym_rate, snr);
PAM4 = single(PAM4);

sprintf('PAM8')
[~, PAM8] = generate_signal('PAM', 8, batch, symbols, sps, sym_rate, snr);
PAM8 = single(PAM8);

sprintf('CPFSK2')
[~, CPFSK2] = generate_signal('CPFSK', 2, batch, symbols, sps, sym_rate, snr);
CPFSK2 = single(CPFSK2);

% sprintf('CPFSK4')
% [~, CPFSK4] = generate_signal('CPFSK', 4, batch, symbols, sps, sym_rate, snr);
% CPFSK4 = single(CPFSK4);
% 
% sprintf('CPFSK8')
% [~, CPFSK8] = generate_signal('CPFSK', 8, batch, symbols, sps, sym_rate, snr);
% CPFSK8 = single(CPFSK8);

% sprintf('CPM2')
% [~, CPM2] = generate_signal('CPM', 2, batch, symbols, sps, sym_rate, snr);
% CPM2 = single(CPM2);
% 
% sprintf('CPM4')
% [~, CPM4] = generate_signal('CPM', 4, batch, symbols, sps, sym_rate, snr);
% CPM4 = single(CPM4);
% 
% sprintf('CPM8')
% [~, CPM8] = generate_signal('CPM', 8, batch, symbols, sps, sym_rate, snr);
% CPM8 = single(CPM8);

sprintf('GFSK')
[~, GFSK] = generate_signal('GFSK', 0, batch, symbols, sps, sym_rate, snr);
GFSK = single(GFSK);

sprintf('GMSK')
[~, GMSK] = generate_signal('GMSK', 0, batch, symbols, sps, sym_rate, snr);
GMSK = single(GMSK);

sprintf('MSK')
[~, MSK] = generate_signal('MSK', 0, batch, symbols, sps, sym_rate, snr);
MSK = single(MSK);

% sprintf('FSK2')
% [~, FSK2] = generate_signal('M-FSK', 2, batch, symbols, sps, sym_rate, snr);
% FSK2 = single(FSK2);
% 
% sprintf('FSK4')
% [~, FSK4] = generate_signal('M-FSK', 4, batch, symbols, sps, sym_rate, snr);
% FSK4 = single(FSK4);
% 
% sprintf('FSK8')
% [~, FSK8] = generate_signal('M-FSK', 8, batch, symbols, sps, sym_rate, snr);
% FSK8 = single(FSK8);

sprintf('BPSK')
[~, BPSK] = generate_signal('BPSK', 0, batch, symbols, sps, sym_rate, snr);
BPSK = single(BPSK);

% sprintf('DBPSK')
% [~, DBPSK] = generate_signal('DBPSK', 0, batch, symbols, sps, sym_rate, snr);
% DBPSK = single(DBPSK);
% 


% sprintf('DPSK2')
% [~, DPSK2] = generate_signal('M-DPSK', 2, batch, symbols, sps, sym_rate, snr);
% DPSK2 = single(DPSK2);
% 
% sprintf('DPSK4')
% [~, DPSK4] = generate_signal('M-DPSK', 4, batch, symbols, sps, sym_rate, snr);
% DPSK4 = single(DPSK4);
% 
% sprintf('DPSK8')
% [~, DPSK8] = generate_signal('M-DPSK', 8, batch, symbols, sps, sym_rate, snr);
% DPSK8 = single(DPSK8);

% sprintf('PSK2')
% [~, PSK2] = generate_signal('M-PSK', 2, batch, symbols, sps, sym_rate, snr);
% PSK2 = single(PSK2);

% sprintf('PSK4')
% [~, PSK4] = generate_signal('M-PSK', 4, batch, symbols, sps, sym_rate, snr);
% PSK4 = single(PSK4);

sprintf('PSK8')
[~, PSK8] = generate_signal('M-PSK', 8, batch, symbols, sps, sym_rate, snr);
PSK8 = single(PSK8);

sprintf('OQPSK')
[~, OQPSK] = generate_signal('OQPSK', 0, batch, symbols, sps, sym_rate, snr);
OQPSK = single(OQPSK);

sprintf('OFDM2')
[~, OFDM2] = generate_signal('OFDM', 2, batch, symbols, sps, sym_rate, snr);
OFDM2 = single(OFDM2);

% sprintf('OFDM4')
% [~, OFDM4] = generate_signal('OFDM', 4, batch, symbols, sps, sym_rate, snr);
% OFDM4 = single(OFDM4);
% 
% sprintf('OFDM8')
% [~, OFDM8] = generate_signal('OFDM', 8, batch, symbols, sps, sym_rate, snr);
% OFDM8 = single(OFDM8);

save(sprintf('batch%d_symbols%d_sps%d_baud%d_snr%d.dat', batch, symbols, sps, sym_rate/1e6,snr))