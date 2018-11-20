close all
sps = 8;
[~, out] = generate_signal('BPSK', 4, 10, 1000, 16, 1e6, 500);
% [sym, out] = generate_signal(method, order, batch, symbols, sps, sym_rate, snr);
figure
plot(out(1,:))
figure
plot(out(2,:))
figure
plot(out(3,:))
figure
plot(out(4,:))
figure
plot(out(5,:))
figure
plot(out(6,:))
% % out = single(out);
% t = 1:length(out);
% % figure()
% % plot(out)
% % hold on
% % plot(out,'ro','MarkerFaceColor','r')
% % figure()
% % plot(t/sps, real(out))
% % hold on
% % plot(t/sps, imag(out))
% % grid on
% figure()
% plot(t/sps, phase(out))
% hold on
% % plot(t/sps, abs(out))
% grid on
% 
% % [sym, out] = generate_signal('MSK', 8, 1, 128, 8, 1e6, 50);
% % out = single(out);
% % figure
% % plot(out)
% % hold on
% % plot(sym,'ro','MarkerFaceColor','r')