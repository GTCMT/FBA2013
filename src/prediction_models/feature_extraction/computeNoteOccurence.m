function [note_indices] = computeNoteOccurence(midi_mat_score)
% function [note1_index, note2_index] = computeNoteOccurence(midi_mat_score)
% Computes the first and second most occuring duration
% in the score and returns their indices.
% Arg: midi_mat_score (readmidi('midi_file'))
% Output: Indices of first and highest occuring notes

dur_list = midi_mat_score(:,7);
dur_norm = dur_list/min(dur_list);
edge_list = 0.5:1:10.5;
num_counts = histcounts(dur_norm, edge_list);
%newx = edge_list(1:end-1)+0.5;
[~,ind] = sort(num_counts,'descend');

note1 = ind(1);
note2 = ind(2);

dur_norm = round(dur_norm);
note1_indices = find(dur_norm==note1);
note2_indices = find(dur_norm==note2);

note_indices = [note1_indices; note2_indices];

end