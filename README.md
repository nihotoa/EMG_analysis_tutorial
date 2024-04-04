## Overview
This repository provides codes & some files for tutorials on EMG analysis and muscle synergy analysis

***

## How to analyze

  - <span style="font-size: 18px;">**preliminary preparations**</span>

    - Please place all recorded data file directly under the monkey name folder.

      (ex.) EMG_analysis_turorial/data/Yachimun/

      - (To obtain the dataset, <strong>please contact the email address given at the end of this README.</strong>)

    <!-- insert image -->
    <img src="explanation_materials/explanation1.jpg" alt="explanation1" width="100%" style="display: block; margin-left: auto; margin-right: auto; padding: 20px">

    - Understand the directory structure of this repository

      The documentation in the code assumes that you understand this folder structure.<br>
      The Shematic diagram of folder structure is shown in the following figure. (This folder structure is tentative version. It may change in future updates)

      ```
      EMG_analysis_tutorial
        │
        ├ README.md
        │
        ├ analysis_data_days(Yachimun).csv
        │
        ├ code
        │　├ filterBat_SynNMFPre.m
        │　├ makeEMGNMFbtc_Oya.m
        │　├ (other function files)
        │　│
        │　├ VBSR
        │　│　└ (some function files)
        │　│ 　　
        │　├ codeForPlotTarget　
        │　│　└ (some function files)
        │　│
        │　└ ttb
        │　　 └ (some function files)
        │
        ├ data
        │　├ runnningEasyfunc.m
        │　├ plotTarget.m
        │　├ SAVE4NMF.m
        │　│
        │　└ Yachimun
        │      ├ SaveFileinfo.m
        │      ├ SYNERGYPLOT.m
        │      ├ (other function files)
        │　 　　│
        │      └ new_nmf_result
        │      　　├ dispNMF_W.m
        │      　　├ plotVAF.m
        │      　　└ MakeDataForPlot_H_utb.m
        │
        └ explanation_materials
        　　└  (some images)

      ```

    - Please add 'code' and 'data' folder to PATH in MATLAB

    <!-- insert image -->
    <img src="explanation_materials/explanation2.gif" alt="explanation1" width="100%" style="display: block; margin-left: auto; margin-right: auto; padding: 20px">

  - <span style="font-size: 18px;">**EMG analysis**</span>

    If you want to perform EMG analysis, please execute the functions in the following procedure

    1. **'SaveFileinfo.m'**

      **Role:** Save data for merging measurement data.
      <br>

    2. **'runnningEasyfunc.m'**

      **Role:** 3 roles

        1. Merge data & generate timing_data

        2. Evaluate cross-talk

        3. Filtering EMG & performing Time Normalization for each task trial

    3. **'plotTarget.m'**

      **Role:** Plot filtered EMG
      <br>

  <!-- - **Muscle synergy analysis** -->
  - <span style="font-size: 18px;">**Muscle synergy analysis**</span>

    If you want to perform muscle synergy analysis, please execute the functions in the following procedure

    1. **'SaveFileinfo.m'**

      **Role:** Same process as EMG analysis.
      <br>

    2. **'SAVE4NMF.m'**

      **Role:** Merge & save EMG data for each muscle
      <br>

    3. **'filterBat_SynNMFPre.m'**

      **Role:** Filter & save EMG data for each muscle.
      <br>

    4. **'makeEMGNMFbtc_Oya.m'**

      **Role:** Perform muscle synergy analysis with using filtered EMG.
      <br>

    5. **'plotVAF.m'**

      **Role:** Visualize the VAF value of synergy obtained by NNMF and save it as a figure
      <br>

    6. **'SYNERGYPLOT.m'**

      **Role:** Plot the results of the muscle synergy analysis for each experimental day.
      <br>

    7. **'dispNMF_W.m'**

      **Role:** Plot the spatial pattern of muscle synergy on all experimental days.
      <br>

    8. **'MakeDataForPlot_H_utb.m'**

      **Role:** Processing data on temporal patterns of muscle synergy(e.g., trial-specific cutouts, time normalization, etc.).
      <br>

    9. **'plotTarget.m'**

      **Role:** Plot temporal patterns of muscle synergy on all experimental days.

***

## Remarks
  The following information is written at the beginning of every code. Please refer to them and proceed with the analysis.
  - **Your operation**<br>
    This section contains instructions for executing the code

  - **Role of this code**<br>
    The role of code is briefly described in this section

  - **Saved data location**<br>
    This section contains details of data to be saved and where these data are saved

  - **Procedure**<br>
    This section describes which code should be executed before and after this code.

***

## Other information

  - If all datasets are processed, the total size of the output data and figures will be about 100GB. Therefore, please make sure that you have enough storage on your device before you start analysis

  - The dates adopted as experimental dates are summarized in 'analysis_data_days(Yachimun).csv'. Please refer this

  - Details of the experiment and analysis outline are distributed separately. If you would like to get these information, <strong>please contact at the email address at the end of this README.</strong>

***

## Contact

  If you want to get the dataset for analysis or have any questions, please feel free to contact me at nao-ota@ncnp.go.jp
