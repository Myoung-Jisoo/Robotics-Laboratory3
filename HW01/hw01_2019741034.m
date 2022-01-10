clc         % 명령창 지우기
clear       % 작업 공간에서 항목 제거하여 시스템 메모리를 늘림
close all   % 'all' 모든 창 닫기
%% Set Prameters 파라미터 설정
    % Set simulatinon Time 시뮬레이션 시간 설정
       end_time   = 4;      % 시뮬레이션 종료 시간은 4
       delta_t    = 0.001;  % 시뮬레이션 시간 간격은 0.001
    % Set Sine Wave 생성 신호 파라미터 설정
       sine_mag1   = 2.0;     sine_freq1  = 1.0;   % 정상신호 (크기 : 2.0 / 주파수 : 1.0Hz)
       sine_mag2   = 0.5;     sine_freq2  = 10.0;  % 노이즈 신호 (크기 : 0.5 / 주파수 : 10.0Hz)
%% Simulation 시뮬레이션
n = 1;
for(t = 0:delta_t:end_time)     % t = 0 일때부터 delta_t의 간격(t증가)으로 end_time에 도달할 때까지 반복
    y =   sine_mag1 * sin(sine_freq1*(2*pi*t))...  %  정상신호 사인파 생성
          + sine_mag2 * sin(sine_freq2*(2*pi*t))... %  노이즈 신호 생성
          + 0.8*randn(size(t));                     %  화이트 노이즈 생성 (평균 = 0 / 표준편차 = 0.8)
    % get data
    sim_y(n)      = y;      %  Simulation의 sim_y(n), y축 데이터에 위의 신호 + 노이즈 + 화이트 노이즈 값 넣기
    sim_time(n)   = t;      %  Simulation의 sim_t(n), x축인 시간에 t 넣기
    n = n + 1;
end
%% Draw Graph 그래프 그리기
    % Time-Domain 그래프 그릴 범위 파라미터 설정
    Xmin =  0.0;    XTick = 1.0;    Xmax = end_time; % X축 : 범위 0 ~ end_time / grid 간격은 1.0
    Ymin = -3.0;    YTick = 1.0;    Ymax = 3.0;      % Y축 : 범위 -3.0 ~ 3.0 / grid 간격은 1.0
    
     figure('units', 'pixels', 'pos', [300 250 550 400], 'Color', [1,1,1]); % Figure 창 생성
     % 창의 위치는 (x, y) = (300, 250)에 띄우고 크기는 550X400으로 설정
        plot(sim_time, sim_y, '-k', 'LineWidth', 1)
        % X축 데이터는 sim_time / Y축 데이터는 sim_y / 선은 solid 타입에 검은색
        % 'LineWidth' 선굵기는 1로 설정
        
        grid on;    % grid 켜기
        axis([Xmin Xmax Ymin Ymax])            % X축 : Xmin~Xmax / Y축 : Ymin ~ Ymax 범위의 그래프를 그림
        set(gca, 'XTick', [Xmin:XTick:Xmax]);  % grid 설정 범위는 Xmin ~ Xmax / 간격은 XTIck
        set(gca, 'YTick', [Ymin:YTick:Ymax]);  % grid 설정 범위는 Ymin ~ Ymax / 간격은 YTick
    xlabel('Time (s)', 'fontsize', 20);        % X축에 'Time (s)' 쓰기 (글씨크기는 20)
    ylabel('Magnitude', 'fontsize', 20);       % Y축에 'Magnitude' 쓰기 (글씨크기는 20)
    title ('Time Domain', 'fontsize', 25);     % 제목(Top)에 'Time Domain' 쓰기 (글씨크기는 25)
%% Calculate FFT
% FFT 파라미터 정의
Fs       = 1/delta_t;      % Sampling 주파수 설정 => 1000Hz (f= 1/주기(T))
T        = delta_t;        % Sampling 주기 설정
L        = length(sim_y)   % sim_y에 있는 값중 가장 큰 값을 받아온다. / length(x) : x 안에서 가장 큰 배열의 차원 길이 반환
T_vector = (0:L-1)*T;      % Time Vector(시간 벡터)

fft_f    = Fs*(0:(L/2))/L; % 분석 주파수 분해능 = fft_f(2) - fft_f(1) / Frequency Range
%% Calcultate FFT
fft_y_temp     = abs(fft(sim_y)/L);   % 허수부 제거
fft_y          = fft_y_temp(1:L/2+1); % 켤레 복소수
fft_y(2:end-1) = 2*fft_y(2:end-1);    % 켤레 복소수 대응
%% Draw Graph
% subplot(rows, clumns, location)을 이용하면 여러 개의 그래프를 하나의 창에 그릴 수 있음
figure('units', 'pixels', 'pos', [300 700 700 300], 'Color', [1,1,1]); % Figure 창 생성
        Xmin =  0.0;     Xmax = 11.0;  % X축 : 범위 0 ~ 11
        Ymin =  0.0;     Ymax = 3.0;   % Y축 : 범위 0 ~ 3
        
           stem(fft_f, fft_y, '-k', 'LineWidth', 2); % 이산 시퀀스 데이터 플로팅
           % X축 데이터는 fft_f / Y축 데이터는 fft_y / 선은 solid 타입에 검은색
           % 'LineWidth' 선굵기는 2로 설정
           % 데이터 시퀀스 Y를 기준선에서 x축을 따라 연장되는 줄기로 플로팅
            
            grid on;    % grid 켜기
            axis([Xmin Xmax Ymin Ymax])       % X축 : Xmin~Xmax / Y축 : Ymin ~ Ymax 범위의 그래프를 그림
            set(gca, 'XTick', [0 1.0 10.0]);  % X축 grid 0, 1.0, 10.0 에 표시
            set(gca, 'YTick', [0 0.5  2.0]);  % Y축 grid 0, 0.5,  2.0 에 표시
      xlabel('Frequency (Hz)',  'fontsize', 20);        % X축에 'Frequency (Hz)' 쓰기 (글씨크기는 20)
      ylabel('Magnitude',       'fontsize', 20);        % Y축에 'Magnitude' 쓰기 (글씨크기는 20)
      title ('Frequency Domain', 'fontsize', 25);       % 제목(Top)에 'Frequency Domain' 쓰기 (글씨크기는 25)

%% Simulation 시뮬레이션 (다중그래프)
n = 1;
for(t = 0:delta_t:end_time)     % t = 0 일때부터 delta_t의 간격(t증가)으로 end_time에 도달할 때까지 반복
    y1 =   sine_mag1 * sin(sine_freq1*(2*pi*t));    %  정상신호 사인파 생성    
    
    y2 =   sine_mag1 * sin(sine_freq1*(2*pi*t))...  %  정상신호 사인파 생성
          + sine_mag2 * sin(sine_freq2*(2*pi*t))... %  노이즈 신호 생성
          + 0.8*randn(size(t));                     %  화이트 노이즈 생성 (평균 = 0 / 표준편차 = 0.8)
    % get data
    sim_y1(n)      = y1;      %  Simulation의 sim_y(n), y축 데이터에 위의 신호 + 노이즈 + 화이트 노이즈 값 넣기
    sim_y2(n)      = y2;
    sim_time(n)   = t;      %  Simulation의 sim_t(n), x축인 시간에 t 넣기
    n = n + 1;
end
%% 다중 그래프 그리기
close all   % 'all' 모든 창 닫기

figure('units', 'pixels', 'pos', [1000 300 800 600], 'Color', [1,1,1]); % Figure 창 생성
      subplot(2,1,1)   % Time-Domain 2, 1, 1에 그래프 생성
        Xmin =   0.0;     XTick = 1.0;    Xmax = end_time;  % X축 : 범위 0 ~ end_time
        Ymin =  -3.0;     YTick = 1.0;    Ymax = 3.0;       % Y축 : 범위 -3.0 ~ 3.0
        
            plot(sim_time, sim_y2, '-k', 'LineWidth', 1) % 노이즈가 포함된 그래프
            % X축 데이터는 sim_time / Y축 데이터는 sim_y / 선은 solid 타입에 검은색
            % 'LineWidth' 선굵기는 1로 설정
            hold on % 두개의 그래프를 겹쳐서 보기 위함
            
            plot(sim_time, sim_y1, '-b', 'LineWidth', 2) % 정상 신호 그래프 (파란색에 굵기 2)
            
            legend('noise', '정상 신호') % 범례 추가
          
            grid on;    % grid 켜기
            axis([Xmin Xmax Ymin Ymax])            % X축 : Xmin~Xmax / Y축 : Ymin ~ Ymax 범위의 그래프를 그림
            set(gca, 'XTick', [Xmin:XTick:Xmax]);  % grid 설정 범위는 Xmin ~ Xmax / 간격은 XTIck
            set(gca, 'YTick', [Ymin:YTick:Ymax]);  % grid 설정 범위는 Ymin ~ Ymax / 간격은 YTIck
      xlabel('Time (s)',        'fontsize', 20);        % X축에 'Time (s)' 쓰기 (글씨크기는 20)
      ylabel('Magnitude',       'fontsize', 20);        % Y축에 'Magnitude' 쓰기 (글씨크기는 20)
      title ('Time Domain',     'fontsize', 25);        % 제목(Top)에 'Time Domain' 쓰기 (글씨크기는 25)
      
      subplot(2,1,2)  % Frequency_Domain
           Xmin = 0.0;      Xmax = 11;  % X축 그래프 범위 : 0.0~11.0
           Ymin = 0.0;      Ymax = 3.0; % Y축 그래프 범위 : 0.0~3.0
           stem(fft_f, fft_y, '-k', 'LineWidth', 2); % 이산 시퀀스 데이터 플로팅
           % X축 데이터는 fft_f / Y축 데이터는 fft_y / 선은 solid 타입에 검은색
           % 'LineWidth' 선굵기는 2로 설정
           % 데이터 시퀀스 Y를 기준선에서 x축을 따라 연장되는 줄기로 플로팅
           
            grid on;    % grid 켜기
            axis([Xmin Xmax Ymin Ymax])       % X축 : Xmin~Xmax / Y축 : Ymin ~ Ymax 범위의 그래프를 그림
            set(gca, 'XTick', [0 1.0 10.0]);  % X축 grid 0, 1.0, 10.0 에 표시
            set(gca, 'YTick', [0 0.5  2.0]);  % Y축 grid 0, 0.5,  2.0 에 표시
      xlabel('Frequency (Hz)',   'fontsize', 20);        % X축에 'Frequency (Hz)' 쓰기 (글씨크기는 20)
      ylabel('Magnitude',        'fontsize', 20);        % Y축에 'Magnitude' 쓰기 (글씨크기는 20)
      title ('Frequency Domain', 'fontsize', 25);        % 제목(Top)에 'Frequency Domain' 쓰기 (글씨크기는 25)
      