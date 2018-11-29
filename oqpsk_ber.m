clc;clear;

rolloff  =  0.3;
span = 4;
sps = 8;
batch = 1;
symbols = 1e6;
b = rcosdesign(rolloff, span, sps, 'normal');

qpskModulator = comm.OQPSKModulator('BitInput',true);
%Դ����
data = randi([0 1],batch*symbols*log2(4),1);
%QPSK����
out1 = qpskModulator(data);

% �ϲ���+�����˲�
out2 = upfirdn(out1, b, sps);



% esno=50;
% snr = esno+10*log10(1/sps);
% 
% out22 = awgn(out2,snr,'measured');
% 
% %��ȡ����
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

    %��ȡ����
    out3 = out22(1:sps:end);
    out4 = out3(3:end-2);
    
    qpskDemodulator = comm.OQPSKDemodulator('BitOutput',true);
    errorRate = comm.ErrorRate('ReceiveDelay',2);
    rxData = qpskDemodulator(out4);
    errorStats = errorRate(data,rxData);

    bers = [bers errorStats(1)];
end

semilogy(esnos-3,bers,'ro')
grid on
title('QPSK������')
ylabel('BER')
xlabel('Eb/No(dB)')