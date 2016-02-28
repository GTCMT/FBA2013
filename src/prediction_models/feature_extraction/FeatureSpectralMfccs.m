% ======================================================================
%> @brief computes the MFCCs from the magnitude spectrum (see Slaney)
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vmfcc mel frequency cepstral coefficients
% ======================================================================
function [vmfcc] = FeatureSpectralMfccs(X, f_s)

     iNumCoeffs  = 13;
    
    % allocate memory
    vmfcc_interm       = zeros(iNumCoeffs, size(X,2));

    H           = ToolMfccFb(size(X,1), f_s);
    T           = GenerateDctMatrix (size(H,1), iNumCoeffs);
 
    for (n = 1:size(X,2))
        % compute the mel spectrum
        X_Mel       = log10(H * X(:,n)+1e-20);

        % calculate the mfccs
        vmfcc_interm(:,n)  = T * X_Mel;
    end
    vmfcc=mean(vmfcc_interm,2);
end

