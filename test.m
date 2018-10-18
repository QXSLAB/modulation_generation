close all
N = 100;
sps = 8;
% out = generate_signal('QAM', 8, 1, N, sps, 1e6, 50);
% out = single(out);
% t = 1:length(out);
% figure()
% plot(out)
% hold on
% plot(out,'ro','MarkerFaceColor','r')
% figure()
% plot(t/sps, real(out))
% hold on
% plot(t/sps, imag(out))
% grid on
% figure()
% plot(t/sps, phase(out))
% hold on
% plot(t/sps, abs(out))
% grid on

[sym, out] = generate_signal('DQPSK', 8, 1, N, sps, 1e6, 50);
out = single(out);
plot(out)
hold on
plot(sym,'ro','MarkerFaceColor','r')