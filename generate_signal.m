function [sym, out] = generate_signal(method, order, batch, symbols, sps, sym_rate, snr);

% 二阶星座图
[X2, Y2] = meshgrid([-1, 1], [-1, 1]);
const2 = X2+1i*Y2;
const2 = const2(:);
% 四阶星座图
[X4, Y4] = meshgrid([-3, -1, 1, 3], [-3, -1, 1, 3]);
const4 = X4+1i*Y4;
const4 = const4(:);
% 八阶星座图
[X8, Y8] = meshgrid([-7 -5, -3, -1, 1, 3, 5, 7], [-7, -5, -3, -1, 1, 3, 5, 7]);
const8 = X8+1i*Y8;
const8 = const8(:);

% 成型滤波器
% http://www.mathworks.com/help/signal/ref/rcosdesign.html
rolloff  =  0.25;
span = 4;
b = rcosdesign(rolloff, span, sps, 'normal');

% 选择调制格式
switch method
    
    case 'QAM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.generalqammodulator-system-object.html
        mod = comm.GeneralQAMModulator;
        %选择调制阶数/星座图
        switch order
            case 2
                const = const2;
            case 4
                const = const4;
            case 8
                const = const8;
            otherwise
                error('constellation not supported')
        end
        mod.Constellation = const;
        %源数据
        data = randi([0 length(const)-1], batch*symbols, 1);
        %QAM调制
        out = step(mod, data);
        %调制符号
        sym = out*max(b);

        % 上采样+成型滤波
        out = upfirdn(out, b, sps);
        %截取数据
        out = out(1:symbols*sps*batch);
        
    case 'PAM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.generalqammodulator-system-object.html
        mod = comm.GeneralQAMModulator;
        %选择调制阶数/星座图
        switch order
            case 2
                const = [-1, 1];
            case 4
                const = [-3, -1, 1, 3];
            case 8
                const = [-7 -5, -3, -1, 1, 3, 5, 7];
            otherwise
                error('constellation not supported')
        end
        mod.Constellation = const;
        %源数据
        data = randi([0 length(const)-1], batch*symbols, 1);
        %PAM调制
        out = step(mod, data);
        %调制符号
        sym = out*max(b);
        
        % 上采样+成型滤波
        out = upfirdn(out, b, sps);
        %截取数据
        out = out(1:symbols*sps*batch);
        
    case 'CPFSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.cpfskmodulator-system-object.html
        mod = comm.CPFSKModulator('ModulationOrder', order,...
            'BitInput', true, 'SymbolMapping', 'Gray',...
            'SamplesPerSymbol', sps);
        % 二进制源数据
        data = randi([0 1],batch*symbols*log2(order),1);
        %CPFSK调制
        out = step(mod, data);
        
        %重置调制器
        reset(mod)
        %取消上采样
        release(mod)
        mod.SamplesPerSymbol = 1;
        %调制符号
        sym = step(mod, data);

    case 'CPM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.cpmmodulator-system-object.html
        mod = comm.CPMModulator('ModulationOrder', order,...
             'BitInput', true, 'SymbolMapping', 'Gray',...
             'SamplesPerSymbol', sps);
         % 二进制源数据
        data = randi([0 1],batch*symbols*log2(order),1);
        %CPM调制
        out = step(mod, data);
        
        %重置调制器
        reset(mod)
        %取消上采样
        release(mod)
        mod.SamplesPerSymbol = 1;
        %调制符号
        sym = step(mod, data);
        
    case 'GFSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.cpmmodulator-system-object.html
        mod = comm.CPMModulator('ModulationOrder', 2,...
            'FrequencyPulse', 'Gaussian',...
            'BandwidthTimeProduct', 0.5,...
            'ModulationIndex', 1,...
            'BitInput', true,...
            'SamplesPerSymbol', sps);
        data = randi([0 1],batch*symbols,1);
        out = mod(data);
        
        %重置调制器
        reset(mod)
        %取消上采样
        release(mod)
        mod.SamplesPerSymbol = 1;
        %调制符号
        sym = step(mod, data);
        
    case 'GMSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.gmskmodulator-system-object.html
        mod = comm.GMSKModulator('BitInput', true,...
            'InitialPhaseOffset', pi/4,...
            'SamplesPerSymbol', sps);
        %源数据
        data = randi([0 1],batch*symbols,1);
        %GMSK调制
        out = step(mod, data);

        %重置调制器
        reset(mod)
        %取消上采样
        release(mod)
        mod.SamplesPerSymbol = 1;
        %调制符号
        sym = step(mod, data);
        
    case 'MSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.mskmodulator-system-object.html
        mod = comm.MSKModulator('BitInput', true, ...
            'InitialPhaseOffset', pi/4,...
            'SamplesPerSymbol', sps);
        %源数据
        data = randi([0 1],batch*symbols,1);
        %MSK调制
        out = step(mod, data);
        
         %重置调制器
        reset(mod)
        %取消上采样
        release(mod)
        mod.SamplesPerSymbol = 1;
        %调制符号
        sym = step(mod, data);
        
    case 'M-FSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.fskmodulator-system-object.html
        %频率间隔
        freqSep = sym_rate*sps/order;
        mod = comm.FSKModulator('ModulationOrder', order,...
            'FrequencySeparation', freqSep,...
            'ContinuousPhase', true,...
            'SamplesPerSymbol', sps,...
            'SymbolRate', sym_rate);
        %源数据
        data = randi([0 order-1], batch*symbols, 1);
        %MFSK调制
        out = step(mod,data);
        
        %重置调制器
        reset(mod)
        %取消上采样
        release(mod)
        mod.SamplesPerSymbol = 1;
        %调制符号
        sym = step(mod, data);
        
    case 'OFDM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.ofdmmodulator-system-object.html
        %OFDM信号参数
        fft = 128;
        cp = 16;
        %需要生成的符号数
        blockNum = ceil(batch*symbols/(fft+cp));
        mod = comm.OFDMModulator('FFTLength', fft,...
            'CyclicPrefixLength', cp,...
            'NumSymbols', blockNum);
        %每个符号所需要的数据量
        modDim = info(mod);
        blockLen = max(modDim.DataInputSize);
        %选择源数据的调制阶数
        switch order
            case 2
                const = const2;
            case 4
                const = const4;
            case 8
                const = const8;
            otherwise
                error('constellation not supported')
        end
        %使用M-QAM调制生成源数据
        data = step(comm.GeneralQAMModulator('Constellation', const),...
            randi([0 length(const)-1], blockLen*blockNum, 1));
        data = reshape(data, blockLen, blockNum);
        %OFDM调制
        out = step(mod,data);
        %调制符号
        sym = out*max(b);
        
        % 上采样+成型滤波
        out = upfirdn(out, b, sps);
        %截取数据
        out = out(1:symbols*sps*batch);
        
    case 'BPSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.bpskmodulator-system-object.html
        mod = comm.BPSKModulator;
        %源数据
        data = randi([0 1], batch*symbols,1);
        %BPSK调制
        out = step(mod, data);
        %调制符号
        sym = out*max(b);
        
         % 上采样+成型滤波
        out = upfirdn(out, b, sps);
        %截取数据
        out = out(1:symbols*sps*batch);

    case 'DBPSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.dbpskmodulator-system-object.html
        mod = comm.DBPSKModulator(pi/4);
        %源数据
        data = randi([0 1], batch*symbols,1);
        %DPSK调制
        out = step(mod, data);
        %调制符号
        sym = out*max(b);
        
        % 上采样+成型滤波
        out = upfirdn(out, b, sps);
        %截取数据
        out = out(1:symbols*sps*batch);
        
    case 'M-DPSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.dpskmodulator-system-object.html
        mod = comm.DPSKModulator(order,pi/order,'BitInput',true);
        %二进制源数据
        data = randi([0 1],batch*symbols*log2(order),1);
        %M-DPSK调制
        out = mod(data);
        %调制符号
        sym = out*max(b);
        
        % 上采样+成型滤波
        out = upfirdn(out, b, sps);
        %截取数据
        out = out(1:symbols*sps*batch);
        
    case 'M-PSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.pskmodulator-system-object.html
        mod = comm.PSKModulator;
        %源数据
        data = randi([0 order-1],batch*symbols,1);
        %MPSK调制
        out = step(mod,data);
        %调制符号
        sym = out*max(b);
        
        % 上采样+成型滤波
        out = upfirdn(out, b, sps);
        %截取数据
        out = out(1:symbols*sps*batch);
        
    case 'QPSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.qpskmodulator-system-object.html
        mod = comm.QPSKModulator;
        %源数据
        data = randi([0 3],batch*symbols,1);
        %QPSK调制
        out = mod(data);
        %调制符号
        sym = out*max(b);
        
        % 上采样+成型滤波
        out = upfirdn(out, b, sps);
        %截取数据
        out = out(1:symbols*sps*batch);
        
    case 'DQPSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.dqpskmodulator-system-object.html
        mod = comm.DQPSKModulator('BitInput',true);
        %二进制源数据
        data = randi([0 1],batch*symbols*log2(4),1);
        %DQPSK调制
        out = mod(data);
        %调制符号
        sym = out*max(b);
        
        % 上采样+成型滤波
        out = upfirdn(out, b, sps);
        %截取数据
        out = out(1:symbols*sps*batch);
        
    case 'OQPSK'
        %https://ww2.mathworks.cn/help/comm/digital-baseband-modulation.html
        mod = comm.OQPSKModulator('BitInput',true);
        %二进制源数据
        data = randi([0 1],batch*symbols*log2(4),1);
        %OQPSK调制
        out = mod(data);
        %调制符号
        sym = out*max(b);
        
        % 上采样+成型滤波
        out = upfirdn(out, b, sps);
        %截取数据
        out = out(1:symbols*sps*batch);
        
    case 'QAM-TCM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.generalqamtcmmodulator-system-object.html
        %源数据
        data = randi([0 1], batch*symbols,1);
        %QAM TCM调制
        t = poly2trellis(7,[171 133]);
        hMod = comm.GeneralQAMTCMModulator(t,...
            'Constellation',exp(pi*1i*[1 2 3 6]/4));
        out = step(hMod,data);
        %调制符号
        sym = out*max(b);
        
        % 上采样+成型滤波
        out = upfirdn(out, b, sps);
        %截取数据
        out = out(1:symbols*sps*batch);
        
    case '8PSK-TCM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.psktcmmodulator-system-object.html
        %源数据
        data = randi([0 1], batch*symbols,1);
        %8PSK TCM调制
        t =  poly2trellis([5 4],[23 35 0; 0 5 13]);
        hMod = comm.PSKTCMModulator(t,'ModulationOrder',8);
        out = step(hMod,data);
        %调制符号
        sym = out*max(b);
        
        % 上采样+成型滤波
        out = upfirdn(out, b, sps);
        %截取数据
        out = out(1:symbols*sps*batch);
        
    case 'RQAM-TCM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.rectangularqamtcmmodulator-system-object.html
        %源数据
        data = randi([0 1],batch*symbols*3,1);
        %8PSK TCM调制
        hMod = comm.RectangularQAMTCMModulator;
        out = step(hMod,data);
        %调制符号
        sym = out*max(b);
        
        % 上采样+成型滤波
        out = upfirdn(out, b, sps);
        %截取数据
        out = out(1:symbols*sps*batch);

    case 'F-OFDM'
        disp('https://ww2.mathworks.cn/help/comm/examples/f-ofdm-vs-ofdm-modulation.html')
        
    case 'UFMC'
        disp('https://ww2.mathworks.cn/help/comm/examples/ufmc-vs-ofdm-modulation.html')
        
    case 'FBMC'
        disp('https://ww2.mathworks.cn/help/comm/examples/fbmc-vs-ofdm-modulation.html')
        
    otherwise
        error('modulation not supported')
   
end

% %加入随机相位
% phs = -pi + 2*pi*rand(batch,1);
% phs = repmat(phs, symbols*sps, 1);
% phs = phs(:);
% out = out.*exp(1i*phs);

%设置信噪比
hAWGN = comm.AWGNChannel('NoiseMethod', ...
    'Signal to noise ratio (SNR)', ...
    'SNR', snr);
out = step(hAWGN, out);

%变换输出格式
out = reshape(out, symbols*sps, batch);
out = out';