% Description — Acquire 11-s LFP at 2 kHz from two NI-DAQ analog inputs (ai11, ai12)
% while outputting a 10 Hz square-wave stimulus on ao1 during 5–6 s.
% ACTION — Configures channels, builds/queues the AO waveform, records the inputs
% (data), and plots both the LFP (data) and the stimulus (dataS).


clc
clear 
close all
s = daq.createSession('ni'); 

% Channels
eeg1=addAnalogInputChannel(s,'Dev2', 'ai11', 'Voltage');
eeg1.TerminalConfig=('SingleEnded');
 
eeg2=addAnalogInputChannel(s,'Dev2', 'ai12', 'Voltage');
eeg2.TerminalConfig=('SingleEnded');

% Stimulus train
addAnalogOutputChannel(s,'Dev2','ao1', 'Voltage');
fs = 2e3;
t1=0:1/fs:5; 
t2=5.0005:1/fs:5.9995;
t3=6.000:1/fs:10.9995;

t = [t1,t2,t3];

dataS= [0*t1,square(2*pi*10*t2,10)*10,0*t3]; % 2*pi*10*t2 (10 Hz)
                                             %"()*10" power
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
queueOutputData(s,dataS');
ctr.Frequency = 10;
ctr.InitialDelay = 0.5;
ctr.DutyCycle = 0.75;

% StartForeground returns data for input channels only. The data variable
% will contain one column of data.
% % plot(data.Time, data.Variables);

s.Rate = 2000; %frequency sampling
beep
data = startForeground(s);
f1 = figure;
 plot(data)
hold on
f2 = figure;
 plot(dataS)
hold on
beep

% % 
