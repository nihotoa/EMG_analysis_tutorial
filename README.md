## Overview
This repository provides codes & some files for tutorials on EMG analysis and muscle synergy analysis

## How to analyze

  - **preliminary preparations** <br>

    * Please place all recorded data file directly under the monkey name folder.<br>
    (ex.) EMG_analysis_turorial/data/Yachimun/<br>

      * How to obtain recorded data:<br>
        To obtain the dataset, please contact the email address given at the end of this README.

    * Understand the directory structure of this repository<br>
      The documentation in the code assumes that you understand this folder structure.<br>
      The folder structre is shown in the following figure.<br>
      <ここにフォルダ構造のツリーを書いていく>

    * Please add 'code' and 'data' folder to PATH in MATLAB


  - **EMG_analysis** <br>
    If you want to perform EMG analysis, please execute the functions in the following procedure
    1. **Run 'SaveFileinfo.m'**

      - **file location**: EMG_analysis_turorial/data/monkeyname/

      - **function**: Save data for merging measurement data.

    2. **Run 'runnningEasyfunc.m'**
      - **file location**: EMG_analysis_turorial/data/

      - **function**: 3 function

        1. merge data & generate timing_data

        2. evaluate cross-talk

        3. filtering & Time Normalization of Tasks

    3. **Run 'plotTarget.m'**

      - **file location**: EMG_analysis_turorial/data/

      - **function**: Plot EMG data

  - **Synergy_analysis**

    1. **Run 'SaveFileinfo.m'** <br>
      この後にシナジー解析の順番を書いていく

## Remarks
  The following information is written at the beginning of every code. Please refer to them and proceed with the analysis.
  - **Your operation**<br>
    This section contains instructions for executing the code

  - **Role of this code**<br>
    The role of code is briefly described in this section

  - **Saved data location**<br>
    This section contains details of the data and where it is saved

  - **Procedure**<br>
    This section describes which code should be executed before and after the target code.

## Contact

  if you need the dataset for analysis or have any questions, please feel free to contact us at nao-ota@ncnp.go.jp
