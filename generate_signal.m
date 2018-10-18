function [sym, out] = generate_signal(method, order, batch, symbols, sps, sym_rate, snr);

% ��������ͼ
[X2, Y2] = meshgrid([-1, 1], [-1, 1]);
const2 = X2+1i*Y2;
const2 = const2(:);
% �Ľ�����ͼ
[X4, Y4] = meshgrid([-3, -1, 1, 3], [-3, -1, 1, 3]);
const4 = X4+1i*Y4;
const4 = const4(:);
% �˽�����ͼ
[X8, Y8] = meshgrid([-7 -5, -3, -1, 1, 3, 5, 7], [-7, -5, -3, -1, 1, 3, 5, 7]);
const8 = X8+1i*Y8;
const8 = const8(:);

% �����˲���
% http://www.mathworks.com/help/signal/ref/rcosdesign.html
rolloff  =  0.25;
span = 4;
b = rcosdesign(rolloff, span, sps, 'normal');

% ѡ����Ƹ�ʽ
switch method
    
    case 'QAM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.generalqammodulator-system-object.html
        mod = comm.GeneralQAMModulator;
        %ѡ����ƽ���/����ͼ
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
        %Դ����
        data = randi([0 length(const)-1], batch*symbols, 1);
        %QAM����
        out = step(mod, data);
        %���Ʒ���
        sym = out*max(b);

        % �ϲ���+�����˲�
        out = upfirdn(out, b, sps);
        %��ȡ����
        out = out(1:symbols*sps*batch);
        
    case 'PAM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.generalqammodulator-system-object.html
        mod = comm.GeneralQAMModulator;
        %ѡ����ƽ���/����ͼ
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
        %Դ����
        data = randi([0 length(const)-1], batch*symbols, 1);
        %PAM����
        out = step(mod, data);
        %���Ʒ���
        sym = out*max(b);
        
        % �ϲ���+�����˲�
        out = upfirdn(out, b, sps);
        %��ȡ����
        out = out(1:symbols*sps*batch);
        
    case 'CPFSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.cpfskmodulator-system-object.html
        mod = comm.CPFSKModulator('ModulationOrder', order,...
            'BitInput', true, 'SymbolMapping', 'Gray',...
            'SamplesPerSymbol', sps);
        % ������Դ����
        data = randi([0 1],batch*symbols*log2(order),1);
        %CPFSK����
        out = step(mod, data);
        
        %���õ�����
        reset(mod)
        %ȡ���ϲ���
        release(mod)
        mod.SamplesPerSymbol = 1;
        %���Ʒ���
        sym = step(mod, data);

    case 'CPM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.cpmmodulator-system-object.html
        mod = comm.CPMModulator('ModulationOrder', order,...
             'BitInput', true, 'SymbolMapping', 'Gray',...
             'SamplesPerSymbol', sps);
         % ������Դ����
        data = randi([0 1],batch*symbols*log2(order),1);
        %CPM����
        out = step(mod, data);
        
        %���õ�����
        reset(mod)
        %ȡ���ϲ���
        release(mod)
        mod.SamplesPerSymbol = 1;
        %���Ʒ���
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
        
        %���õ�����
        reset(mod)
        %ȡ���ϲ���
        release(mod)
        mod.SamplesPerSymbol = 1;
        %���Ʒ���
        sym = step(mod, data);
        
    case 'GMSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.gmskmodulator-system-object.html
        mod = comm.GMSKModulator('BitInput', true,...
            'InitialPhaseOffset', pi/4,...
            'SamplesPerSymbol', sps);
        %Դ����
        data = randi([0 1],batch*symbols,1);
        %GMSK����
        out = step(mod, data);

        %���õ�����
        reset(mod)
        %ȡ���ϲ���
        release(mod)
        mod.SamplesPerSymbol = 1;
        %���Ʒ���
        sym = step(mod, data);
        
    case 'MSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.mskmodulator-system-object.html
        mod = comm.MSKModulator('BitInput', true, ...
            'InitialPhaseOffset', pi/4,...
            'SamplesPerSymbol', sps);
        %Դ����
        data = randi([0 1],batch*symbols,1);
        %MSK����
        out = step(mod, data);
        
         %���õ�����
        reset(mod)
        %ȡ���ϲ���
        release(mod)
        mod.SamplesPerSymbol = 1;
        %���Ʒ���
        sym = step(mod, data);
        
    case 'M-FSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.fskmodulator-system-object.html
        %Ƶ�ʼ��
        freqSep = sym_rate*sps/order;
        mod = comm.FSKModulator('ModulationOrder', order,...
            'FrequencySeparation', freqSep,...
            'ContinuousPhase', true,...
            'SamplesPerSymbol', sps,...
            'SymbolRate', sym_rate);
        %Դ����
        data = randi([0 order-1], batch*symbols, 1);
        %MFSK����
        out = step(mod,data);
        
        %���õ�����
        reset(mod)
        %ȡ���ϲ���
        release(mod)
        mod.SamplesPerSymbol = 1;
        %���Ʒ���
        sym = step(mod, data);
        
    case 'OFDM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.ofdmmodulator-system-object.html
        %OFDM�źŲ���
        fft = 128;
        cp = 16;
        %��Ҫ���ɵķ�����
        blockNum = ceil(batch*symbols/(fft+cp));
        mod = comm.OFDMModulator('FFTLength', fft,...
            'CyclicPrefixLength', cp,...
            'NumSymbols', blockNum);
        %ÿ����������Ҫ��������
        modDim = info(mod);
        blockLen = max(modDim.DataInputSize);
        %ѡ��Դ���ݵĵ��ƽ���
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
        %ʹ��M-QAM��������Դ����
        data = step(comm.GeneralQAMModulator('Constellation', const),...
            randi([0 length(const)-1], blockLen*blockNum, 1));
        data = reshape(data, blockLen, blockNum);
        %OFDM����
        out = step(mod,data);
        %���Ʒ���
        sym = out*max(b);
        
        % �ϲ���+�����˲�
        out = upfirdn(out, b, sps);
        %��ȡ����
        out = out(1:symbols*sps*batch);
        
    case 'BPSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.bpskmodulator-system-object.html
        mod = comm.BPSKModulator;
        %Դ����
        data = randi([0 1], batch*symbols,1);
        %BPSK����
        out = step(mod, data);
        %���Ʒ���
        sym = out*max(b);
        
         % �ϲ���+�����˲�
        out = upfirdn(out, b, sps);
        %��ȡ����
        out = out(1:symbols*sps*batch);

    case 'DBPSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.dbpskmodulator-system-object.html
        mod = comm.DBPSKModulator(pi/4);
        %Դ����
        data = randi([0 1], batch*symbols,1);
        %DPSK����
        out = step(mod, data);
        %���Ʒ���
        sym = out*max(b);
        
        % �ϲ���+�����˲�
        out = upfirdn(out, b, sps);
        %��ȡ����
        out = out(1:symbols*sps*batch);
        
    case 'M-DPSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.dpskmodulator-system-object.html
        mod = comm.DPSKModulator(order,pi/order,'BitInput',true);
        %������Դ����
        data = randi([0 1],batch*symbols*log2(order),1);
        %M-DPSK����
        out = mod(data);
        %���Ʒ���
        sym = out*max(b);
        
        % �ϲ���+�����˲�
        out = upfirdn(out, b, sps);
        %��ȡ����
        out = out(1:symbols*sps*batch);
        
    case 'M-PSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.pskmodulator-system-object.html
        mod = comm.PSKModulator;
        %Դ����
        data = randi([0 order-1],batch*symbols,1);
        %MPSK����
        out = step(mod,data);
        %���Ʒ���
        sym = out*max(b);
        
        % �ϲ���+�����˲�
        out = upfirdn(out, b, sps);
        %��ȡ����
        out = out(1:symbols*sps*batch);
        
    case 'QPSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.qpskmodulator-system-object.html
        mod = comm.QPSKModulator;
        %Դ����
        data = randi([0 3],batch*symbols,1);
        %QPSK����
        out = mod(data);
        %���Ʒ���
        sym = out*max(b);
        
        % �ϲ���+�����˲�
        out = upfirdn(out, b, sps);
        %��ȡ����
        out = out(1:symbols*sps*batch);
        
    case 'DQPSK'
        %https://ww2.mathworks.cn/help/comm/ref/comm.dqpskmodulator-system-object.html
        mod = comm.DQPSKModulator('BitInput',true);
        %������Դ����
        data = randi([0 1],batch*symbols*log2(4),1);
        %DQPSK����
        out = mod(data);
        %���Ʒ���
        sym = out*max(b);
        
        % �ϲ���+�����˲�
        out = upfirdn(out, b, sps);
        %��ȡ����
        out = out(1:symbols*sps*batch);
        
    case 'OQPSK'
        %https://ww2.mathworks.cn/help/comm/digital-baseband-modulation.html
        mod = comm.OQPSKModulator('BitInput',true);
        %������Դ����
        data = randi([0 1],batch*symbols*log2(4),1);
        %OQPSK����
        out = mod(data);
        %���Ʒ���
        sym = out*max(b);
        
        % �ϲ���+�����˲�
        out = upfirdn(out, b, sps);
        %��ȡ����
        out = out(1:symbols*sps*batch);
        
    case 'QAM-TCM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.generalqamtcmmodulator-system-object.html
        %Դ����
        data = randi([0 1], batch*symbols,1);
        %QAM TCM����
        t = poly2trellis(7,[171 133]);
        hMod = comm.GeneralQAMTCMModulator(t,...
            'Constellation',exp(pi*1i*[1 2 3 6]/4));
        out = step(hMod,data);
        %���Ʒ���
        sym = out*max(b);
        
        % �ϲ���+�����˲�
        out = upfirdn(out, b, sps);
        %��ȡ����
        out = out(1:symbols*sps*batch);
        
    case '8PSK-TCM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.psktcmmodulator-system-object.html
        %Դ����
        data = randi([0 1], batch*symbols,1);
        %8PSK TCM����
        t =  poly2trellis([5 4],[23 35 0; 0 5 13]);
        hMod = comm.PSKTCMModulator(t,'ModulationOrder',8);
        out = step(hMod,data);
        %���Ʒ���
        sym = out*max(b);
        
        % �ϲ���+�����˲�
        out = upfirdn(out, b, sps);
        %��ȡ����
        out = out(1:symbols*sps*batch);
        
    case 'RQAM-TCM'
        %https://ww2.mathworks.cn/help/comm/ref/comm.rectangularqamtcmmodulator-system-object.html
        %Դ����
        data = randi([0 1],batch*symbols*3,1);
        %8PSK TCM����
        hMod = comm.RectangularQAMTCMModulator;
        out = step(hMod,data);
        %���Ʒ���
        sym = out*max(b);
        
        % �ϲ���+�����˲�
        out = upfirdn(out, b, sps);
        %��ȡ����
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

% %���������λ
% phs = -pi + 2*pi*rand(batch,1);
% phs = repmat(phs, symbols*sps, 1);
% phs = phs(:);
% out = out.*exp(1i*phs);

%���������
hAWGN = comm.AWGNChannel('NoiseMethod', ...
    'Signal to noise ratio (SNR)', ...
    'SNR', snr);
out = step(hAWGN, out);

%�任�����ʽ
out = reshape(out, symbols*sps, batch);
out = out';