Project: Neurophysiology Analysis Pipeline for Sleep Deprivation Study
This repository contains a some analysis pipeline developed for my M.Sc. thesis in Neurobiology. The project's goal was to characterize the effects of sleep deprivation on brain activity and behavior by analyzing multi-channel Local Field Potential (LFP) and behavioral data from a crayfish model.

The repository includes a multi-language workflow with the following core components:

1. Signal Acquisition and Spike Analysis (MATLAB)
Scripts for handling raw, multi-channel neural data acquisition signals.

A pipeline for detecting and analyzing single-unit activity (spike analysis)..

2. LFP Preprocessing and Analysis (Python)
A Python-based pipeline for preprocessing raw LFP data, including filtering, artifact handling, and epoching for further analysis.

Time-frequency analysis using Short-Time Fourier Transform (STFT) to generate spectrograms and quantify power changes in different neural frequency bands over time.

Mutual information and multivariate MI to cuantify 

3. Behavioral Analysis (Python)
A script for the quantification of alterations in recognition memory after sleep.

Together, these tools form a multi-level workflow—from raw signal processing and population-level LFP dynamics and behavioral correlation—designed to provide a comprehensive characterization of the neural and behavioral signatures of sleep deprivation.
