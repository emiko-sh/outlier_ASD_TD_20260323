Supplementary materials for ’Detecting Outliers of Pursuit Eye Movements: A Preliminary Analysis of Autism Spectrum Disorder’
# Detecting outliers of pursuit eye movements: a preliminary analysis of autism spectrum disorder
https://arxiv.org/abs/2603.22705  
https://arxiv.org/pdf/2603.22705  

This repository contains the **supplementary materials**, including analysis code and detailed methodologies, for the study:

> **Detecting outliers of pursuit eye movements: a preliminary analysis of autism spectrum disorder** > *Emiko Shishido, Seiko Miyata, Tetsuya Yamamoto, Masaki Fukunaga, Ryota Hashimoto, Kenichiro Miura, Norio Ozaki*

---

## 📌 Overview
This study proposes a novel **"outlier analysis"** approach to characterize the clinical and biological heterogeneity of smooth pursuit eye movements (SPEM) in adults with Autism Spectrum Disorder (ASD). 

Instead of traditional group-mean comparisons, we utilize **Principal Component Analysis (PCA)** and **Mahalanobis distance** to identify individual idiosyncratic patterns that are often masked in conventional analyses.

## 📂 Repository Structure
- **/methods**  
https://github.com/emiko-sh/outlier_ASD_TD_20260323/blob/main/methods/  
Provides a detailed description of:  
  - The experimental setup and the COCORO eye-tracking protocol.
  - Data preprocessing pipelines.
  - Mathematical definitions of the temporal and spatial eye-movement indices.

## 🚀 Key Methodological Features
- **Dimensionality Reduction:** Isolating core features from high-dimensional SPEM data to focus on individual deviations.
- **Strict Outlier Detection:** Utilizing a threshold of $D_M > \sqrt{10}$ (approximately $3.16\sigma$) within a three-dimensional feature space to ensure a conservative and robust definition of "atypicality."
- **Interpretability:** Unlike "black-box" machine learning models, this statistical framework allows for the interpretation of which specific oculomotor features contribute to an individual's outlier status.

## 📄 Citation
If you utilize this code or methodology in your research, please cite our preprint:
- Shishido, E., et al. (2026). Detecting outliers of pursuit eye movements: a preliminary analysis of autism spectrum disorder. 
arXiv: https://arxiv.org/pdf/2603.22705  

---
*This work was supported by JSPS KAKENHI Grant Number 24K10723.*
