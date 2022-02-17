clc, clear
close all
%% Set Simulation Time
    end_time    = 1;    % simulation time은 1초
    delta_t     = 0.1;  % 0.1초 간격
    sim_time    = [0:delta_t:end_time];

%% Make Input Signal
    sim_x       = 14.4 + 2 * randn(length(sim_time),1) + 3;
    % 평균 14.4, 표준 편차 2 인 랜덤 시그널
    % randn() : 행과 열을 뽑음(난수) / 1을 기준으로 정규분포
    sim_x(6)   = 110;
    % 일부러 평균에서 많이 벗어난 값 추가
    
%% Analysis the Signal
    %% Get Mean
        x_Mean      = mean(sim_x);  % sim_x의 평균 구하기
        temp        = ones(length(sim_time), 1);
        % 모든 변수가 1인 11x11 행렬 temp 생성
        sim_x_Mean  = x_Mean * temp(:,1);
        % 평균값을 11x1 sim_x_Mean 행렬에 모두 넣어주어 직선을 그릴 수 있게 해줌
    %% Get Median
        x_Median    = median(sim_x);% sim_x의 중앙값 구하기
        % 함수 안에 있는 변수들을 크기순으로 정렬했을 때의 중간값
        sim_x_Median= x_Median * temp(:,1);
        % 중앙값을 11x1 sim_x_Median 행렬에 모두 넣어주어 직선을 그릴 수 있게 해줌
    %% Get Normal Distribution
        ND_Range    = [-200:1:200]; % -200 부터 1 간격으로 200까지 넣기
        x_SD        = std(sim_x);   % Standard Deviation 표준편차
        % 크기가 1이 아닌 첫 번째 배열 차원을 따라 sim_x의 요소의 표준편차를 x_SD에 넣음
        x_ND        = normpdf(ND_Range, x_Mean, x_SD);
        % 평균 x_min 및 표준편차 x_SD를 갖는 정규분포에 대한 pdf를 ND_Range의 값에서
        % 계산하여 x_ND에 넣음
%% Draw gragh
    figure('units', 'pixels', 'pos', [0 0 1000 1000], 'Color', [1,1,1]); % Figure 창 생성
        Xmin =      0.0;     XTick = 1.0;    Xmax = end_time;  % X축 : 범위 0 ~ end_time      
        Ymin =   -140.0;     YTick = 1.0;    Ymax = 140.0;
    subplot(2, 4, [1,2]);
            plot(sim_time, sim_x, 'ok', 'LineWidth', 1) % 난수로 생성한 변수들
            hold on
            plot(sim_time, sim_x_Mean   , '-g', 'LineWidth', 2) % 평균값
            plot(sim_time, sim_x_Median, '-r', 'LineWidth', 2) % 중앙값
            legend('noise', 'Average', 'Median') % 범례 추가
            
            grid on;    % grid 켜기
            axis([Xmin Xmax Ymin Ymax])            % X축 : Xmin~Xmax / Y축 : Ymin ~ Ymax 범위의 그래프를 그림
            set(gca, 'XTick', [Xmin:XTick:Xmax]);  % grid 설정 범위는 Xmin ~ Xmax / 간격은 XTIck
            set(gca, 'YTick', [Ymin, Ymax]);  % grid 설정 범위는 Ymin ~ Ymax / 간격은 YTIck
            yticks([Ymin 0 x_Median x_Mean Ymax]);
      xlabel('Time (s)',  'fontsize', 20);        % X축에 'Time (s)' 쓰기 (글씨크기는 20)
      ylabel('Magnitude', 'fontsize', 20);        % Y축에 'Magnitude' 쓰기 (글씨크기는 20)
      title ('난수 데이터 분포','fontsize', 15);

    subplot(2, 4, 3);   % 확률 분포
        plot(x_ND, ND_Range,'-r', 'LineWidth', 2)
        axis([0 0.015 -140 140])
        grid on;    % grid 켜기
        yticks([Ymin 0 x_Mean Ymax]);
        xlabel('Probability Density', 'fontsize', 18);
        title ('확률 밀도 함수','fontsize', 15);
        
    subplot(2, 4, 4);  % Box Plot으로 데이터의 모양 파악하기 위함
        boxplot(sim_x);
        axis([0 2 -140 140])
        xlabel('Input Signal', 'fontsize', 18);
        title ('Box Plot','fontsize', 15);
        
    subplot(2, 4, [5,6]);
            plot(sim_time, sim_x, 'ok', 'LineWidth', 1) % 난수로 생성한 변수들
            hold on
            plot(sim_time, sim_x_Mean   , '-g', 'LineWidth', 2) % 평균값
            plot(sim_time, sim_x_Median, '-r', 'LineWidth', 2) % 중앙값
            legend('noise', 'Average', 'Median') % 범례 추가
            
            grid on;    % grid 켜기
            axis([0 1 0 30])
            set(gca, 'XTick', [Xmin:XTick:Xmax]);  % grid 설정 범위는 Xmin ~ Xmax / 간격은 XTIck
            set(gca, 'YTick', [Ymin, Ymax]);  % grid 설정 범위는 Ymin ~ Ymax / 간격은 YTIck
            yticks([Ymin 0 x_Median x_Mean Ymax]);
      xlabel('Time (s)',  'fontsize', 20);        % X축에 'Time (s)' 쓰기 (글씨크기는 20)
      ylabel('Magnitude', 'fontsize', 20);        % Y축에 'Magnitude' 쓰기 (글씨크기는 20)
      title ('난수 데이터 분포','fontsize', 15);
      
    subplot(2, 4, 7);   % 확률 분포
        plot(x_ND, ND_Range,'-r', 'LineWidth', 2)
        axis([0 0.015 0 30])
        grid on;    % grid 켜기
        yticks([Ymin 0 x_Mean Ymax]);
        xlabel('Probability Density', 'fontsize', 13);
        title ('확률 밀도 함수','fontsize', 15);
        
    subplot(2, 4, 8);  % Box Plot으로 데이터의 모양 파악하기 위함
        boxplot(sim_x);
        axis([0 2 0 30])
        xlabel('Input Signal', 'fontsize', 13);
        title ('Box Plot','fontsize', 15);