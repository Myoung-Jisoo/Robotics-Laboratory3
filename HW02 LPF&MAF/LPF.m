clc, clear      % 작업 공간에서 항목 제거하여 시스템 메모리를 늘림
close all       % 'all' 모든 창 닫기
%% Set Prameters 파라미터 설정
    % Set simulatinon Time 시뮬레이션 시간 설정
       end_time   = 4;      % 시뮬레이션 종료 시간은 4
       delta_t    = 0.001;  % 시뮬레이션 시간 간격은 0.001
       sim_time   = [0:delta_t:end_time]; % 0~end_time까지 delta_t 간격 Time Matrix
       
    % Set Sine Wave 생성 신호 파라미터 설정
       sine_mag1   = 2.0;     sine_freq1  = 1.0;   % 정상신호 (크기 : 2.0 / 주파수 : 1.0Hz)
       sine_mag2   = 0.5;     sine_freq2  = 10.0;  % 노이즈 신호 (크기 : 0.5 / 주파수 : 10.0Hz)

    %  정상신호 사인파 생성
    y1    =  sine_mag1 * sin(sine_freq1*(2*pi*sim_time)); % 크기 : 2.0 / 주파수 : 1.0Hz
    %  노이즈 신호 생성
    y2    =  y1...  
             + sine_mag2 * sin(sine_freq2*(2*pi*sim_time))...  % 노이즈 신호 (크기 : 0.5 / 주파수 : 10.0Hz) 추가
             + 0.8*randn(size(sim_time));                      % 화이트 노이즈
    sim_x =  y2;      %  Simulation의 sim_y(n), y축 데이터에 위의 신호 + 노이즈 + 화이트 노이즈 값 넣기
%% Low-path 필터 구현 / cut off frequency = 1Hz
% 첫 LPF에만 주석을 달고 cut off frequency를 변경한 경우에는 똑같은 코드이므로 자세한 주석 생략

f_cut   = 1;               % 차단 주파수 10hz
tau     = 1/(2*pi*f_cut);   % RC (시정수)
n           = 1;
pre_y_LPF   = 0;            % 이전 데이터값

for(t=0:delta_t:end_time)
    % Simulation
        y_LPF       = ((delta_t*sim_x(n)) + (tau*pre_y_LPF)) / (tau + delta_t);
        pre_y_LPF   = y_LPF;    % 이후 데이터 값으로 넣기 위해 저장
    % get data
        sim_y_LPF1(n) = y_LPF;   % 필터 사용후 나온 데이터값들 저장
        n = n+1;                % 다음 index
end
%% Low-path 필터 구현 / cut off frequency = 3Hz
f_cut   = 3;               % 차단 주파수 3hz
tau     = 1/(2*pi*f_cut);   % RC (시정수)
n           = 1;
pre_y_LPF   = 0;            % 이전 데이터값

for(t=0:delta_t:end_time)
    % Simulation
        y_LPF       = ((delta_t*sim_x(n)) + (tau*pre_y_LPF)) / (tau + delta_t);
        pre_y_LPF   = y_LPF;    % 이후 데이터 값으로 넣기 위해 저장
    % get data
        sim_y_LPF2(n) = y_LPF;   % 필터 사용후 나온 데이터값들 저장
        n = n+1;                % 다음 index
end
%% Low-path 필터 구현 / cut off frequency = 8Hz
f_cut   = 8;               % 차단 주파수 3hz
tau     = 1/(2*pi*f_cut);   % RC (시정수)
n           = 1;
pre_y_LPF   = 0;            % 이전 데이터값

for(t=0:delta_t:end_time)
    % Simulation
        y_LPF       = ((delta_t*sim_x(n)) + (tau*pre_y_LPF)) / (tau + delta_t);
        pre_y_LPF   = y_LPF;    % 이후 데이터 값으로 넣기 위해 저장
    % get data
        sim_y_LPF3(n) = y_LPF;   % 필터 사용후 나온 데이터값들 저장
        n = n+1;                % 다음 index
end
%% Draw Graph 그래프 그리기
    figure('units', 'pixels', 'pos', [700 300 1000 600], 'Color', [1,1,1]); % Figure 창 생성
        Xmin =   0.0;     XTick = 1.0;    Xmax = end_time;  % X축 : 범위 0 ~ end_time
        Ymin =  -3.0;     YTick = 1.0;    Ymax = 3.0;       % Y축 : 범위 -3.0 ~ 3.0
        
            plot(sim_time, sim_x, '-k', 'LineWidth', 1) % 노이즈가 포함된 그래프
            % X축 데이터는 sim_time / Y축 데이터는 sim_y / 선은 solid 타입에 검은색
            % 'LineWidth' 선굵기는 1로 설정
            hold on % 두 개의 그래프를 겹쳐서 보기 위함
            plot(sim_time, y1, '-w', 'LineWidth', 8) % 정상신호 (하얀색에 굵기 8)
            hold on % 세 개의 그래프를 겹쳐서 보기 위함
            plot(sim_time, sim_y_LPF1, '-b', 'LineWidth', 4) % tau = 1Hz (파란색에 굵기 4)
            hold on % 네 개의 그래프를 겹쳐서 보기 위함
            plot(sim_time, sim_y_LPF2, '-g', 'LineWidth', 5) % tau = 3Hz (초록색에 굵기 5)
            % MAF_Size = 150 결과와 거의 겹쳐서 육안으로 확인이 어려워 선굵기를 늘림
            hold on % 다섯 개의 그래프를 겹쳐서 보기 위함
            plot(sim_time, sim_y_LPF3, '-r', 'LineWidth', 2) % tau = 8Hz (빨간색에 굵기 2)
            
            legend('noise', '정상신호', 'cut off frequency = 1Hz', 'cut off frequency = 3Hz', 'cut off frequency = 8Hz') % 범례 추가
          
            grid on;    % grid 켜기
            axis([Xmin Xmax Ymin Ymax])            % X축 : Xmin~Xmax / Y축 : Ymin ~ Ymax 범위의 그래프를 그림
            set(gca, 'XTick', [Xmin:XTick:Xmax]);  % grid 설정 범위는 Xmin ~ Xmax / 간격은 XTIck
            set(gca, 'YTick', [Ymin:YTick:Ymax]);  % grid 설정 범위는 Ymin ~ Ymax / 간격은 YTIck
      xlabel('Time (s)',              'fontsize', 20);        % X축에 'Time (s)' 쓰기 (글씨크기는 20)
      ylabel('Magnitude',             'fontsize', 20);        % Y축에 'Magnitude' 쓰기 (글씨크기는 20)
      title ('First Low-pass filter', 'fontsize', 25);        % First Older

%% FFT 주파수 분석
%% Calculate FFT / Cut off frequency = 1
% FFT 파라미터 정의
Fs       = 1/delta_t;      % Sampling 주파수 설정 => 1000Hz (f= 1/주기(T))
T        = delta_t;        % Sampling 주기 설정
L        = length(sim_y_LPF1);   % sim_y_MAF1에 있는 값중 가장 큰 값을 받아온다. / length(x) : x 안에서 가장 큰 배열의 차원 길이 반환
T_vector = (0:L-1)*T;      % Time Vector(시간 벡터)

fft_f1    = Fs*(0:(L/2))/L; % 분석 주파수 분해능 = fft_f(2) - fft_f(1) / Frequency Range
%% Calcultate FFT
fft_y_temp     = abs(fft(sim_y_LPF1)/L);   % 허수부 제거
fft_y1          = fft_y_temp(1:L/2+1); % 켤레 복소수
fft_y1(2:end-1) = 2*fft_y1(2:end-1);    % 켤레 복소수 대응

%% Calculate FFT / Cut off frequency = 3
% FFT 파라미터 정의
Fs       = 1/delta_t;      % Sampling 주파수 설정 => 1000Hz (f= 1/주기(T))
T        = delta_t;        % Sampling 주기 설정
L        = length(sim_y_LPF2);   % sim_y_MAF1에 있는 값중 가장 큰 값을 받아온다. / length(x) : x 안에서 가장 큰 배열의 차원 길이 반환
T_vector = (0:L-1)*T;      % Time Vector(시간 벡터)

fft_f2    = Fs*(0:(L/2))/L; % 분석 주파수 분해능 = fft_f(2) - fft_f(1) / Frequency Range
%% Calcultate FFT
fft_y_temp     = abs(fft(sim_y_LPF2)/L);   % 허수부 제거
fft_y2          = fft_y_temp(1:L/2+1); % 켤레 복소수
fft_y2(2:end-1) = 2*fft_y2(2:end-1);    % 켤레 복소수 대응

%% Calculate FFT / Cut off frequency = 8
% FFT 파라미터 정의
Fs       = 1/delta_t;      % Sampling 주파수 설정 => 1000Hz (f= 1/주기(T))
T        = delta_t;        % Sampling 주기 설정
L        = length(sim_y_LPF3);   % sim_y_MAF1에 있는 값중 가장 큰 값을 받아온다. / length(x) : x 안에서 가장 큰 배열의 차원 길이 반환
T_vector = (0:L-1)*T;      % Time Vector(시간 벡터)

fft_f3    = Fs*(0:(L/2))/L; % 분석 주파수 분해능 = fft_f(2) - fft_f(1) / Frequency Range
%% Calcultate FFT
fft_y_temp     = abs(fft(sim_y_LPF3)/L);   % 허수부 제거
fft_y3          = fft_y_temp(1:L/2+1); % 켤레 복소수
fft_y3(2:end-1) = 2*fft_y3(2:end-1);    % 켤레 복소수 대응

%% 그래프 그리기
figure('units', 'pixels', 'pos', [1000 300 800 600], 'Color', [1,1,1]); % Figure 창 생성
      subplot(3,1,1)  % Frequency_Domain
           Xmin = 0.0;      Xmax = 11;  % X축 그래프 범위 : 0.0~11.0
           Ymin = 0.0;      Ymax = 3.0; % Y축 그래프 범위 : 0.0~3.0
           stem(fft_f1, fft_y1, '-k', 'LineWidth', 2); % 이산 시퀀스 데이터 플로팅
           % X축 데이터는 fft_f / Y축 데이터는 fft_y / 선은 solid 타입에 검은색
           % 'LineWidth' 선굵기는 2로 설정
           % 데이터 시퀀스 Y를 기준선에서 x축을 따라 연장되는 줄기로 플로팅
            grid on;    % grid 켜기
            axis([Xmin Xmax Ymin Ymax])       % X축 : Xmin~Xmax / Y축 : Ymin ~ Ymax 범위의 그래프를 그림
            set(gca, 'XTick', [0 1.0 10.0]);  % X축 grid 0, 1.0, 10.0 에 표시
            set(gca, 'YTick', [0 0.05  1.4]);  % Y축 grid 0, 0.05,  1.4 에 표시
      xlabel('Frequency (Hz)',   'fontsize', 20);        % X축에 'Frequency (Hz)' 쓰기 (글씨크기는 20)
      ylabel('Magnitude',        'fontsize', 20);        % Y축에 'Magnitude' 쓰기 (글씨크기는 20)
      title ('Cut off frequency 1Hz', 'fontsize', 25);    % 제목 (글씨크기는 25)
           
      subplot(3,1,2)  % Frequency_Domain
            stem(fft_f2, fft_y2, '-k', 'LineWidth', 2); % 이산 시퀀스 데이터 플로팅
            grid on;    % grid 켜기
            axis([Xmin Xmax Ymin Ymax])       % X축 : Xmin~Xmax / Y축 : Ymin ~ Ymax 범위의 그래프를 그림
            set(gca, 'XTick', [0 1.0 10.0]);  % X축 grid 0, 1.0, 10.0 에 표시
            set(gca, 'YTick', [0 0.1  2.0]);  % Y축 grid 0, 0.1,  2.0 에 표시
      xlabel('Frequency (Hz)',   'fontsize', 20);        % X축에 'Frequency (Hz)' 쓰기 (글씨크기는 20)
      ylabel('Magnitude',        'fontsize', 20);        % Y축에 'Magnitude' 쓰기 (글씨크기는 20)
      title ('Cut off frequency 3Hz', 'fontsize', 25);    % 제목
            
      subplot(3,1,3)  % Frequency_Domain
            stem(fft_f3, fft_y3, '-k', 'LineWidth', 2); % 이산 시퀀스 데이터 플로팅
            grid on;    % grid 켜기
            axis([Xmin Xmax Ymin Ymax])       % X축 : Xmin~Xmax / Y축 : Ymin ~ Ymax 범위의 그래프를 그림
            set(gca, 'XTick', [0 1.0 10.0]);  % X축 grid 0, 1.0, 10.0 에 표시
            set(gca, 'YTick', [0 0.3  2.0]);  % Y축 grid 0, 0.3,  2.0 에 표시
      xlabel('Frequency (Hz)',   'fontsize', 20);        % X축에 'Frequency (Hz)' 쓰기 (글씨크기는 20)
      ylabel('Magnitude',        'fontsize', 20);        % Y축에 'Magnitude' 쓰기 (글씨크기는 20)
      title ('Cut off frequency 8Hz', 'fontsize', 25);    % 제목