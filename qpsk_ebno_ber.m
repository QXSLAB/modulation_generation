clc;clear;

rolloff  =  0.5;
span = 4;
sps = 8;
batch = 1;
symbols = 1e5;
b = rcosdesign(rolloff, span, sps, 'normal');

qpskModulator = comm.QPSKModulator('BitInput',true);
%源数据
data = randi([0 1],batch*symbols*log2(4),1);
%QPSK调制
out1 = qpskModulator(data);

% 上采样+成型滤波
out2 = upfirdn(out1, b, sps);



% esno=16;
% snr = esno+10*log10(1/sps);
% 
% out22 = awgn(out2,snr,'measured');
% plot(out22(1:2000))

% %截取数据
% out3 = out22(1:sps:end);
% out4 = out3(3:end-2);
% 
% rxData = qpskDemodulator(out4);
% 
% errorStats = errorRate(data,rxData);
% 
% errorStats(1)




esnos = [10:2:20];
bers = []
for esno=esnos
    
    snr = esno+10*log10(1/sps);

    out22 = awgn(out2,snr,'measured');

    %截取数据
    out3 = out22(1:sps:end);
    out4 = out3(3:end-2);
    
    qpskDemodulator = comm.QPSKDemodulator('BitOutput',true);
    errorRate = comm.ErrorRate;
    rxData = qpskDemodulator(out4);
    errorStats = errorRate(data,rxData);

    bers = [bers errorStats(1)];
end

semilogy(esnos-3,bers)
grid on
title('QPSK误码率')
ylabel('BER')
xlabel('Eb/No(dB)')