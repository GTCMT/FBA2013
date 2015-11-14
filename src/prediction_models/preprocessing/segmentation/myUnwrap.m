%% Phase Unwrap Function
% [unwrapDelPhase] = myUnwrap(phase, windowSize, hopSize)
% input: 
%   phase: windowSize x n matrix, where n is the number of blocks
% output: 
%   unwrapPhaseDiff = windowSize x n matrix of unwrapped phase difference

function [unwrapDelPhase] = myUnwrap(phase, windowSize, hopSize)

[len, wid] = size(phase);
unwrapDelPhase = zeros(size(phase));
unwrapDelPhase(:,1) = phase(:,1);

k = (0:windowSize-1)'*ones(1,wid-1);
addterm = 2*pi*k*hopSize/windowSize;

unwrapDelPhase(:,2:end) = addterm + princarg(diff(phase,1,2)-addterm);


end
