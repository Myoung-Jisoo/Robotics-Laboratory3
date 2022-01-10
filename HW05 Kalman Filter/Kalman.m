%% workspace 초기화
clc
clear all
close all

%% main
dt = 0.2; % 시뮬레이션 시간 간격은 0.2초
t = 0: dt: 10; % 0~10초
Nsamples = length(t); % 시간 배열 t 크기만한 배열 Nsample을 만든다.

X_est_saved = zeros(Nsamples, 3);     % [추정 전압, 오차공분산, 칼만 게인]의 값들을 담기 위한 배열
Z_measure_saved = zeros(Nsamples, 1); % 

for k = 1: Nsamples
    z_measure = GetVolt();                              % 전압값 읽어오기
    [x_est_volt, Cov, KG] = KalmanFilter(z_measure);    % 칼만 필터 함수 호출
    
    X_est_saved(k, :) = [x_est_volt Cov KG];            % [추정 전압, 오차공분산, 칼만 게인]
    Z_measure_saved(k) = z_measure;                     % 전압값 배열로 저장
end

%% Draw Graph
figure('units', 'pixels', 'pos', [100 100 300 900], 'Color', [1,1,1]);     % Figure 창 생성
    subplot(3, 1, 1);
        plot(t, Z_measure_saved, '-*g')
        hold on;
        plot(t, X_est_saved(:, 1), '-*r');
        xlabel('Time[sec]');
        ylabel('Voltage[V]');
        title('칼만필터 추정 전압값 (w=2)');
        legend('Measurements', 'Kalman Filter');
    subplot(3, 1, 2);
        plot(t, X_est_saved(:, 2), '-ob');
        xlabel('Time[sec]');
        ylabel('P');
        title('오차 공분산 변화');
        legend('P-calculated');
    subplot(3, 1, 3);
        plot(t, X_est_saved(:, 3), '-ob')
        xlabel('Time[sec]');
        ylabel('K');
        title('칼만 게인 변화');
        legend('K-gain');
    
        
%% Kalman Filter
% 칼만 필터 모델 함수를 정의
function [x_est_volt, P, K_gain] = KalmanFilter(z)
    persistent A H Q R                  % 시스템 모델 변수
    persistent x_est P_calculated       % 영속 변수 정의
    persistent firstRun                 % 변수의 값은 함수 호출간에 메모리 유지
    
    if isempty(firstRun)
        %시스템 모델 변수 A H Q R을 영속 변수로 정의
        % 영속변수 : 해당 함수가 끝나더라도 그 값이 시스템 메모리 상에 유지됨
        A = 1;                          % 이전 측정치를 바탕으로 추정값을 예측할 때 사용되는 행렬
        H = 1;                          % 예측값을 측정값의 형태로 변환할 때 사용되는 행렬
        
        Q = 0;                          % 시스템 노이즈의 공분산 행렬
        R = 4;                          % 측정값 노이즈의 공분산 행렬
        
        % 초기 예측 전압을 14로 하고 초기 예측 오차 공분산을 6으로 설정
        x_est = 14;                     % 초기 예측 전압 지정
        P_calculated = 6;               % 초기 예측 오차 공분산
        
        firstRun = 1;
    end
    
    % 정의된 모델 변수를 사용해 주정값과 오차 공분산 계산
    x_pred = A * x_est;                                 % 추정값 예측
    P_pred = A * P_calculated * A' + Q;                 % 오차 공분산 예측
    
    K_gain = P_pred * H' * inv(H * P_pred * H' + R);    % 오차 공분산과 모델 변수들을 사용해 칼만 이득 계산
    
    x_est = x_pred + K_gain * (z - H * x_pred);         % 이득(gain)값과 예측한 추정값으로 실추정값 계산
    P_calculated = P_pred - K_gain * H * P_pred;        % 동일하게 예측한 오차 공분산에서 실 오차 공분산 계산
    
    x_est_volt = x_est;                                 % 계산된 추정값을 반환
    P = P_calculated;
end

%% Get Volt
% 전압 측정치를 생성해주는 함수를 정의
function z_measure = GetVolt()
    v = 2 * randn(1, 1);        % 잡음 생성 (w=2)
    % randn()함수를 사용해 표준 정규분포에서 난수를 추출하고
    % 해당 난수에 임의의 값을 곱해 표준편차를 조절하고
    z_measure = 14.4 + v;       % 전압에 잡음 추가
    % 원하는 값을 더해 평균을 옮길 수 있다.
    
end
