clc, clear  % 작업 공간에서 항목 제거하여 시스템 메모리를 늘림
close all   % 'all' 모든 창 닫기
%% Set simulate Time
       end_time   = 5;      % 시뮬레이션 종료 시간은 4
       delta_t    = 0.001;  % 시뮬레이션 시간 간격은 0.001
       sim_time   = [0:delta_t:end_time]; % 0~end_time까지 delta_t 간격 Time Matrix
       
       sine_mag1   = 2.0;     sine_freq1  = 1.0;   % 정상신호 (크기 : 2.0 / 주파수 : 1.0Hz)
       sine_mag2   = 0.5;     sine_freq2  = 10.0;  % 노이즈 신호 (크기 : 0.5 / 주파수 : 10.0Hz)
       
       sim_y =  sine_mag1 * sin(sine_freq1*(2*pi*sim_time));
       sim_x =  sine_mag1 * sin(sine_freq1*(2*pi*sim_time))...  
              + sine_mag2 * sin(sine_freq2*(2*pi*sim_time))... 
              + 0.8*randn(size(sim_time));
%% IIR
n       = 2;        % 필터 차수
Fc      = 5;        % Cut-off Frequency
Fs      = 1/delta_t;% Sampling Frequency
Fn      = Fs/2;     % Nyquist Frequency
Wn      = Fc/Fn;    % Frequency Control Condition
%% IIR Low-pass Filter 매트랩 제공 함수
[b, a]  = butter(n, Wn, 'low'); % IIR 필터를 n차의 Wn Frequency control condition을 가진 LPF로 생성
% ftype의 값과 Wn의 요소 개수에 따라 저역통과, 고역통과, 대역통과 또는 대역저지 버터워스 필터를 설계
% 결과로 생성되는 대역통과 설계와 대역저지 설계는 차수가 2n임
% 2차 필터
sim_y_IIR1 = filtfilt(b, a, sim_x); % sim_x를 위에서 만든 필터로 처리한 결과를 sim_y_IIR1에 담는다.

%% IIR
n       = 6;        % 필터 차수
Fc      = 5;        % Cut-off Frequency
Fs      = 1/delta_t;% Sampling Frequency
Fn      = Fs/2;     % Nyquist Frequency
Wn      = Fc/Fn;    % Frequency Control Condition
%% IIR Low-pass Filter 매트랩 제공 함수
[b, a]  = butter(n, Wn, 'low'); % IIR 필터를 n차의 Wn Frequency control condition을 가진 LPF로 생성
% ftype의 값과 Wn의 요소 개수에 따라 저역통과, 고역통과, 대역통과 또는 대역저지 버터워스 필터를 설계
% 결과로 생성되는 대역통과 설계와 대역저지 설계는 차수가 2n임
% 2차 필터
sim_y_IIR2 = filtfilt(b, a, sim_x); % sim_x를 위에서 만든 필터로 처리한 결과를 sim_y_IIR1에 담는다.

%% IIR
n       = 9;        % 필터 차수
Fc      = 5;        % Cut-off Frequency
Fs      = 1/delta_t;% Sampling Frequency
Fn      = Fs/2;     % Nyquist Frequency
Wn      = Fc/Fn;    % Frequency Control Condition
%% IIR Low-pass Filter 매트랩 제공 함수
[b, a]  = butter(n, Wn, 'low'); % IIR 필터를 n차의 Wn Frequency control condition을 가진 LPF로 생성
% ftype의 값과 Wn의 요소 개수에 따라 저역통과, 고역통과, 대역통과 또는 대역저지 버터워스 필터를 설계
% 결과로 생성되는 대역통과 설계와 대역저지 설계는 차수가 2n임
% 2차 필터
sim_y_IIR3 = filtfilt(b, a, sim_x); % sim_x를 위에서 만든 필터로 처리한 결과를 sim_y_IIR1에 담는다.

%% Calculate FFT
% FFT 파라미터 정의
Fs       = 1/delta_t;      % Sampling 주파수 설정 => 1000Hz (f= 1/주기(T))
T        = delta_t;        % Sampling 주기 설정
L        = length(sim_y_IIR1);   % sim_y_MAF1에 있는 값중 가장 큰 값을 받아온다. / length(x) : x 안에서 가장 큰 배열의 차원 길이 반환
T_vector = (0:L-1)*T;      % Time Vector(시간 벡터)

fft_f1    = Fs*(0:(L/2))/L; % 분석 주파수 분해능 = fft_f(2) - fft_f(1) / Frequency Range

%% Calcultate FFT (IIR  Low-pass Filter 매트랩 제공 함수)
fft_y_temp1     = abs(fft(sim_y_IIR1)/L);   % 허수부 제거
fft_y1          = fft_y_temp1(1:L/2+1); % 켤레 복소수
fft_y1(2:end-1) = 2*fft_y1(2:end-1);    % 켤레 복소수 대응

%% Calculate FFT
% FFT 파라미터 정의
Fs       = 1/delta_t;      % Sampling 주파수 설정 => 1000Hz (f= 1/주기(T))
T        = delta_t;        % Sampling 주기 설정
L        = length(sim_y_IIR2);   % sim_y_MAF1에 있는 값중 가장 큰 값을 받아온다. / length(x) : x 안에서 가장 큰 배열의 차원 길이 반환
T_vector = (0:L-1)*T;      % Time Vector(시간 벡터)

fft_f2   = Fs*(0:(L/2))/L; % 분석 주파수 분해능 = fft_f(2) - fft_f(1) / Frequency Range

%% Calcultate FFT (IIR Low-pass Filter for C언어)
fft_y_temp2    = abs(fft(sim_y_IIR2)/L);   % 허수부 제거
fft_y2          = fft_y_temp2(1:L/2+1); % 켤레 복소수
fft_y2(2:end-1) = 2*fft_y2(2:end-1);    % 켤레 복소수 대응

%% Calculate FFT
% FFT 파라미터 정의
Fs       = 1/delta_t;      % Sampling 주파수 설정 => 1000Hz (f= 1/주기(T))
T        = delta_t;        % Sampling 주기 설정
L        = length(sim_y_IIR3);   % sim_y_MAF1에 있는 값중 가장 큰 값을 받아온다. / length(x) : x 안에서 가장 큰 배열의 차원 길이 반환
T_vector = (0:L-1)*T;      % Time Vector(시간 벡터)

fft_f3   = Fs*(0:(L/2))/L; % 분석 주파수 분해능 = fft_f(2) - fft_f(1) / Frequency Range

%% Calcultate FFT (IIR Low-pass Filter for C언어)
fft_y_temp3    = abs(fft(sim_y_IIR3)/L);   % 허수부 제거
fft_y3          = fft_y_temp3(1:L/2+1); % 켤레 복소수
fft_y3(2:end-1) = 2*fft_y3(2:end-1);    % 켤레 복소수 대응

%% Draw Graph 그래프 그리기
    figure('units', 'pixels', 'pos', [200 0 1000 700], 'Color', [1,1,1]); % Figure 창 생성
     
      Xmin =   0.0;     XTick = 1.0;    Xmax = 11.0;  % X축 : 범위 0 ~ 11.0
      Ymin =   0.0;     YTick = 1.0;    Ymax = 3.0;       % Y축 : 범위 0.0 ~ 3.0
      subplot(3,1,1)  % Frequency_Domain
            stem(fft_f1, fft_y1, '-k', 'LineWidth', 2); % 이산 시퀀스 데이터 플로팅
            grid on;    % grid 켜기
            axis([Xmin Xmax Ymin Ymax])       % X축 : Xmin~Xmax / Y축 : Ymin ~ Ymax 범위의 그래프를 그림
            set(gca, 'XTick', [0 1.0 10.0]);  % X축 grid 0, 1.0, 10.0 에 표시
            set(gca, 'YTick', [0 0.5  2.0]);  % Y축 grid
      xlabel('Frequency (Hz)', 'fontsize', 20);        % X축에 'Frequency (Hz)' 쓰기 (글씨크기는 20)
      ylabel('Magnitude',      'fontsize', 20);        % Y축에 'Magnitude' 쓰기 (글씨크기는 20)
      title ('IIR (N=2)',           'fontsize', 25);        % 제목
            
      subplot(3,1,2)  % Frequency_Domain
            stem(fft_f2, fft_y2, '-k', 'LineWidth', 2); % 이산 시퀀스 데이터 플로팅
            grid on;    % grid 켜기
            axis([Xmin Xmax Ymin Ymax])       % X축 : Xmin~Xmax / Y축 : Ymin ~ Ymax 범위의 그래프를 그림
            set(gca, 'XTick', [0 1.0 10.0]);  % X축 grid 0, 1.0, 10.0 에 표시
            set(gca, 'YTick', [0 0.5  2.0]);  % Y축 grid
      xlabel('Frequency (Hz)', 'fontsize', 20);        % X축에 'Frequency (Hz)' 쓰기 (글씨크기는 20)
      ylabel('Magnitude',      'fontsize', 20);        % Y축에 'Magnitude' 쓰기 (글씨크기는 20)
      title ('IIR (N=6)',    'fontsize', 25);        % 제목
      
      subplot(3,1,3)  % Frequency_Domain
            stem(fft_f3, fft_y3, '-k', 'LineWidth', 2); % 이산 시퀀스 데이터 플로팅
            grid on;    % grid 켜기
            axis([Xmin Xmax Ymin Ymax])       % X축 : Xmin~Xmax / Y축 : Ymin ~ Ymax 범위의 그래프를 그림
            set(gca, 'XTick', [0 1.0 10.0]);  % X축 grid 0, 1.0, 10.0 에 표시
            set(gca, 'YTick', [0 0.5  2.0]);  % Y축 grid
      xlabel('Frequency (Hz)', 'fontsize', 20);        % X축에 'Frequency (Hz)' 쓰기 (글씨크기는 20)
      ylabel('Magnitude',      'fontsize', 20);        % Y축에 'Magnitude' 쓰기 (글씨크기는 20)
      title ('IIR (N=9)',    'fontsize', 25);        % 제목