# Pursuit Eye Movement Analysis Scripts  
*Accompanying the paper: “Detecting outliers of pursuit eye movements: a preliminary analysis of autism spectrum disorder” (Shishido et al., 2026)*  
https://arxiv.org/abs/2603.22705  
https://arxiv.org/pdf/2603.22705  

## Overview
This repository contains MATLAB scripts used to analyze pursuit eye movements in Healthy Control (HC) and Autism Spectrum Disorder (ASD) participants.  
The workflow includes:

- EDF → text conversion  
- Header extraction  
- Blink removal  
- Pursuit angle computation  
- Delay estimation between target and eye movement  
- Identification of unusable gaze regions  
- PCA‑based outlier detection using squared Mahalanobis distance  

These scripts accompany the paper:

> “Detecting outliers of pursuit eye movements: a preliminary analysis of autism spectrum disorder” (Shishido et al., 2026).  
> *The scripts are not fully executable as provided; general MATLAB procedures such as data import and function definitions are omitted.*

---

## Directory Structure
.  
├── script.m  
├── extractData03.m  
├── continuous0516.m  
├── removeBlinkFunction03.m  
├── measureDelay.m  
├── checkEachParticipantDat02.m  
├── ReadHeadder.m  


---

## Processing Pipeline

### 1. EDF Conversion
EDF files are converted to ASCII text using EyeLink’s `edf2asc` utility:


The resulting text file is imported into MATLAB and stored as a `.mat` cell array.

---

### 2. Header Extraction (`ReadHeadder.m`)
Extracts:

- calibration/validation quality  
- timestamps  
- header start and data start positions  
- calibration and validation error (deg)  

The function identifies the `"START"` marker and parses metadata from the EyeLink text file.

---

### 3. Trial Extraction & Preprocessing (`extractData03.m`)
For each trial:

- Reads gaze samples (gx, gy, pupil)  
- Applies median filtering (`medfilt1`)  
- Computes pursuit angle (`msTheta`) via `continuous0516.m`  
- Computes radial distance from screen center (`rMeasured`)  
- Stores all values in a structured array

---

### 4. Blink Removal (`removeBlinkFunction03.m`)
This function:

- Detects blink segments using velocity thresholds  
- Expands blink intervals based on stable regions  
- Replaces blink segments with `NaN`  
- Returns blink‑cleaned gaze positions

---

### 5. Pursuit Delay Estimation (`measureDelay.m`)
For each sample:

- Compares eye angle (`msTheta`) with target angle (`tgTheta`)  
- Searches within ±400 ms  
- Finds the time point minimizing angular difference  
- Computes:


This yields the temporal delay (or lead) of pursuit.

---

### 6. Identification of Invalid Regions (`checkEachParticipantDat02.m`)
This step:

- Removes half‑blinks using a Hampel filter  
- Excludes samples near the monitor center (<120 px)  
- Applies masks for unusable time regions  
- Computes summary metrics:
  - mean/std of timeDiff  
  - mean/std of radius ratio  
  - usable data percentage (`dataRatio`)

---

### 7. PCA‑Based Outlier Detection (`script.m`)
Using HC data:

1. Compute correlation matrix and variable weights  
2. Run PCA with variable weighting  
3. Compute orthogonalized coefficients (`coefforth`)  
4. Compute **Corrected Scores in PCA Space**:


5. Compute squared Mahalanobis distance (Hotelling’s T²):

- `st2` for HC  
- `st2ASD` for ASD  

These metrics are used to identify outliers in pursuit behavior.

---

## Key Outputs

### Per‑participant metrics
- `timeDiff_mean`, `timeDiff_std`  
- `ratio_mean`, `ratio_std`  
- `absDiffRatio_mean`, `absDiffRatio_std`  
- `dataRatio`  

### PCA‑based outlier metrics
- `cscores` — Corrected Scores in PCA Space  
- `st2` — squared Mahalanobis distance for HC  
- `st2ASD` — squared Mahalanobis distance for ASD  

---

## Requirements
- MATLAB R2020a or later  
- Signal Processing Toolbox  
- Statistics and Machine Learning Toolbox  
- EyeLink `edf2asc` utility  

---

## Notes
- Some helper functions and data files (e.g., `targetXY_FL.mat`, `positionTrials`) are referenced but some are not included.  
- These scripts document the analysis pipeline used in the paper and are not intended as a standalone executable package.

---

## Citation
If you use these scripts, please cite:

**Shishido, E. (2026).**  
*Detecting outliers of pursuit eye movements: a preliminary analysis of autism spectrum disorder.*  
arXiv:2603.22705 [q-bio.NC]  
https://arxiv.org/abs/2603.22705  
https://arxiv.org/pdf/2603.22705  
