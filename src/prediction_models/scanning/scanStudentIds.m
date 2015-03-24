function [student_ids] = scanStudentIds(band_option, instrument_option)
%SCANSTUDENTIDS Return student Ids for given band and instrument
%
% input:
%   band_option (string): 'middle', 'concert' or 'symphonic'
%   instrument_option (string): instrument
%
%   Instruments (incomplete list?):
%     Alto Saxophone
%     Bari Saxophone
%     Bass Clarinet
%     Bass Trombone
%     Bassoon
%     Bb Clarinet
%     Bb Contrabass Clarinet
%     EbClarinet
%     English Horn
%     Euphonium
%     Flute
%     French Horn
%     Oboe
%     Percussion
%     Piccolo
%     Tenor Saxophone
%     Trombone
%     Trumpet
%     Tuba
%
% output:
%   N-by-1 vector of student ids

% path to excel file:
xls_path = '../../../FBA2013';

switch band_option
    case 'middle'
        file_name = 'Middle School';
    case 'concert'
        file_name = 'Concert Band Scores';
    case 'symphonic'
        file_name = 'Symphonic Band Scores';
    otherwise
        disp(['Invalid band option. Options: ' char(39) 'middle' char(39) ', ' char(39) 'concert' char(39) ' or ' char(39) 'symphonic' char(39) '.']);
        return;
end

[num,text] = xlsread(file_name, 1);

% find index of first id for this instrument:
index = 1;
while strcmp(text(index,1), instrument_option) == 0
    index = index+1;
end

index       = index-2;
student_ids = [];

while isnan(num(index)) == 0 
    student_ids = [student_ids ; num(index)];
    index       = index+1;  
end

end