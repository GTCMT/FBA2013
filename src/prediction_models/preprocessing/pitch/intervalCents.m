function cents = intervalCents(freq_1, freq_2)
  cents = 1200 * log2(freq_2 / freq_1);
end

