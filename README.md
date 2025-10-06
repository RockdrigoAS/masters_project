Project: Neurophysiology Analysis for Sleep Deprivation Study
This repo collects analysis code from my M.Sc. project (plus ongoing MI work) on the neural and behavioral effects of sleep deprivation in Procambarus clarkii. It spans raw signal acquisition, LFP preprocessing, time–frequency analysis, information-theoretic connectivity, and a small behavioral metric—aimed at a clear, end-to-end workflow others can inspect and reuse.

What’s inside

MATLAB · Acquisition & spike demo
NI-DAQ script to record ~11-s LFP epochs at 2 kHz from two channels while outputting a 10 Hz light-pulse train (5–6 s). A companion script filters (HP 50 Hz + 60 Hz harmonics notch), optionally rectifies, segments a 3-s window (1 s pre / 1 s stim / 1 s post), and counts spike-like peaks and their magnitudes per channel.

Python · LFP preprocessing (Notebook)
Batch pipeline for multichannel LFP: 3–60 Hz band-pass, 60 Hz notch (+ harmonics), ICA artifact reduction, z-score, 30-s epoching; outputs clean per-channel .npy.

Python · STFT spectrograms
Loads CSV trials across conditions (control / deprivation / recovery), averages a selected channel, and produces globally normalized spectrograms for fair across-condition power comparison.

Python · Connectivity via MI / Total Correlation
Computes pairwise MI (ordinal estimator, embedding dim 4–5, base 2) and multivariate MI (total correlation via KSG k-NN) on LFP epochs (epochs × channels × samples). Outputs per-epoch MI matrices and multivariate-MI trajectories; optional lag sweeps probe delayed interactions.

Python · Behavioral state-space shift
Quantifies the distance between control vs sleep-deprived triad trajectories (centroid shift) and tests its significance (one-sample t-test).

Together, these tools form a multi-level workflow—from raw signal processing and population-level LFP dynamics and behavioral correlation—designed to provide a comprehensive characterization of the neural and behavioral signatures of sleep deprivation in the crayfish.
