function [PSTHpath,STApath,Outpath,files] = print_PSE

PSTHpath    = fullfile(datapath,'PSTH\Grip Onset(-1_3,Spike)\EitoTxx');
STApath     = fullfile(datapath,'STA\Spike(-0.03_0.05,lEMGl,Inf)\EitoTxx');
Outpath     = fullfile(datapath,'figures\STA\Spike(-0.03_0.05,lEMGl,Inf)\EitoTxx');


files   ={'PSTH (Grip Onset (svwostim), Spike).mat','STA (Spike, lFDIl(uV)).mat';...
    'STA (Spike, lADPl(uV)).mat',   'STA (Spike, l3DIl(uV)).mat';...
    'STA (Spike, l2DIl(uV)).mat',   'STA (Spike, lAbPBl(uV)).mat';...
    'STA (Spike, lBRDl(uV)).mat',   'STA (Spike, lED23l(uV)).mat';...
    'STA (Spike, lECRl(uV)).mat',   'STA (Spike, lEDCl(uV)).mat';...
    'STA (Spike, lECUl(uV)).mat',   'STA (Spike, lAbPLl(uV)).mat';...
    'STA (Spike, l4DIl(uV)).mat',   'STA (Spike, lAbDMl(uV)).mat';...
    'STA (Spike, lFCRl(uV)).mat',   'STA (Spike, lFDSl(uV)).mat';...
    'STA (Spike, lFDPrl(uV)).mat',  'STA (Spike, lFDPul(uV)).mat';...
    'STA (Spike, lFCUl(uV)).mat',   'STA (Spike, lPLl(uV)).mat';...
    'STA (Spike, lBicepsl(uV)).mat','STA (Spike, lTricepsl(uV)).mat'};

% Expnames    = {'EitoT00101',...
% 'EitoT00102',...
% 'EitoT00103',...
% 'EitoT00104',...
% 'EitoT00105',...
% 'EitoT00106',...
% 'EitoT00107',...
% 'EitoT00108',...
% 'EitoT00109',...
% 'EitoT00201',...
% 'EitoT00202',...
% 'EitoT00203',...
% 'EitoT00204',...
% 'EitoT00205',...
% 'EitoT00206',...
% 'EitoT00207',...
% 'EitoT00208',...
% 'EitoT00209',...
% 'EitoT00210',...
% 'EitoT00211',...
% 'EitoT00212',...
% 'EitoT00213',...
% 'EitoT00214',...
% 'EitoT00215',...
% 'EitoT00216',...
% 'EitoT00217',...
% 'EitoT00218',...
% 'EitoT00219',...
% 'EitoT00220',...
% 'EitoT00221',...
% 'EitoT00222',...
% 'EitoT00223',...
% 'EitoT00224',...
% 'EitoT00225',...
% 'EitoT00226',...
% 'EitoT00227',...
% 'EitoT00228',...
% 'EitoT00401',...
% 'EitoT00402',...
% 'EitoT00403',...
% 'EitoT00404',...
% 'EitoT00405',...
% 'EitoT00406',...
% 'EitoT00407',...
% 'EitoT00408',...
% 'EitoT00409',...
% 'EitoT00410',...
% 'EitoT00411',...
% 'EitoT00412',...
% 'EitoT00413',...
% 'EitoT00414',...
% 'EitoT00415',...
% 'EitoT00501',...
% 'EitoT00502',...
% 'EitoT00503',...
% 'EitoT00504',...
% 'EitoT00505',...
% 'EitoT00506',...
% 'EitoT00507',...
% 'EitoT00508',...
% 'EitoT00509',...
% 'EitoT00510',...
% 'EitoT00511',...
% 'EitoT00512',...
% 'EitoT00513',...
% 'EitoT00514',...
% 'EitoT00515',...
% 'EitoT00601',...
% 'EitoT00602',...
% 'EitoT00603',...
% 'EitoT00604',...
% 'EitoT00605',...
% 'EitoT00606',...
% 'EitoT00607',...
% 'EitoT00608',...
% 'EitoT00609',...
% 'EitoT00610',...
% 'EitoT00611',...
% 'EitoT00612',...
% 'EitoT00613',...
% 'EitoT00614',...
% 'EitoT00615',...
% 'EitoT00616',...
% 'EitoT00617',...
% 'EitoT00618',...
% 'EitoT00619',...
% 'EitoT00701',...
% 'EitoT00702',...
% 'EitoT00703',...
% 'EitoT00704',...
% 'EitoT00705',...
% 'EitoT00706',...
% 'EitoT00707',...
% 'EitoT00708',...
% 'EitoT00709',...
% 'EitoT00710',...
% 'EitoT00711',...
% 'EitoT00712',...
% 'EitoT00713',...
% 'EitoT00714',...
% 'EitoT00715',...
% 'EitoT00716',...
% 'EitoT00717',...
% 'EitoT00718',...
% 'EitoT00719',...
% 'EitoT00720',...
% 'EitoT00721',...
% 'EitoT00801',...
% 'EitoT00802',...
% 'EitoT00803',...
% 'EitoT00804',...
% 'EitoT00805',...
% 'EitoT00806',...
% 'EitoT00807',...
% 'EitoT00808',...
% 'EitoT00809',...
% 'EitoT00810',...
% 'EitoT00811',...
% 'EitoT00812',...
% 'EitoT00813',...
% 'EitoT00814',...
% 'EitoT00815',...
% 'EitoT00816',...
% 'EitoT00901',...
% 'EitoT00902',...
% 'EitoT00903',...
% 'EitoT00904',...
% 'EitoT00905',...
% 'EitoT00906',...
% 'EitoT00907',...
% 'EitoT00908',...
% 'EitoT00909',...
% 'EitoT00910',...
% 'EitoT00911',...
% 'EitoT00912',...
% 'EitoT00913',...
% 'EitoT01001',...
% 'EitoT01002',...
% 'EitoT01003',...
% 'EitoT01004',...
% 'EitoT01005',...
% 'EitoT01006',...
% 'EitoT01007',...
% 'EitoT01008',...
% 'EitoT01009',...
% 'EitoT01010',...
% 'EitoT01011',...
% 'EitoT01012',...
% 'EitoT01013',...
% 'EitoT01014',...
% 'EitoT01015',...
% 'EitoT01016',...
% 'EitoT01017',...
% 'EitoT01018',...
% 'EitoT01019',...
% 'EitoT01020',...
% 'EitoT01021',...
% 'EitoT01022',...
% 'EitoT01101',...
% 'EitoT01201',...
% 'EitoT01202',...
% 'EitoT01203',...
% 'EitoT01204',...
% 'EitoT01301',...
% 'EitoT01302',...
% 'EitoT01303',...
% 'EitoT01304',...
% 'EitoT01305',...
% 'EitoT01306',...
% 'EitoT01307',...
% 'EitoT01308',...
% 'EitoT01309',...
% 'EitoT01310',...
% 'EitoT01401',...
% 'EitoT01402',...
% 'EitoT01403',...
% 'EitoT01404',...
% 'EitoT01405',...
% 'EitoT01406',...
% 'EitoT01407',...
% 'EitoT01408',...
% 'EitoT01409',...
% 'EitoT01410',...
% 'EitoT01411',...
% 'EitoT01412',...
% 'EitoT01413',...
% 'EitoT01414',...
% 'EitoT01415',...
% 'EitoT01501',...
% 'EitoT01502',...
% 'EitoT01503',...
% 'EitoT01504',...
% 'EitoT01505',...
% 'EitoT01506',...
% 'EitoT01507',...
% 'EitoT01508',...
% 'EitoT01509',...
% 'EitoT01510',...
% 'EitoT01511',...
% 'EitoT01512',...
% 'EitoT01513',...
% 'EitoT01514',...
% 'EitoT01515',...
% 'EitoT01516',...
% 'EitoT01517',...
% 'EitoT01601',...
% 'EitoT01602',...
% 'EitoT01603',...
% 'EitoT01604',...
% 'EitoT01605',...
% 'EitoT01606',...
% 'EitoT01607',...
% 'EitoT01608',...
% 'EitoT01609',...
% 'EitoT01610',...
% 'EitoT01611',...
% 'EitoT01612',...
% 'EitoT01613',...
% 'EitoT01614',...
% 'EitoT01615',...
% 'EitoT01701',...
% 'EitoT01702',...
% 'EitoT01703',...
% 'EitoT01704',...
% 'EitoT01705',...
% 'EitoT01706',...
% 'EitoT01707',...
% 'EitoT01708',...
% 'EitoT01709',...
% 'EitoT01710',...
% 'EitoT01711',...
% 'EitoT01712',...
% 'EitoT01713',...
% 'EitoT01714',...
% 'EitoT01715',...
% 'EitoT01716',...
% 'EitoT01717',...
% 'EitoT01718',...
% 'EitoT01719',...
% 'EitoT01720',...
% 'EitoT01721',...
% 'EitoT01722',...
% 'EitoT01723',...
% 'EitoT01724',...
% 'EitoT01725',...
% 'EitoT01726',...
% 'EitoT01801',...
% 'EitoT01802',...
% 'EitoT01803',...
% 'EitoT01804',...
% 'EitoT01805',...
% 'EitoT01806',...
% 'EitoT01807',...
% 'EitoT01808',...
% 'EitoT01809',...
% 'EitoT01810',...
% 'EitoT01811',...
% 'EitoT01901',...
% 'EitoT01902',...
% 'EitoT01903',...
% 'EitoT01904',...
% 'EitoT01905',...
% 'EitoT01906',...
% 'EitoT01907',...
% 'EitoT01908',...
% 'EitoT01909',...
% 'EitoT02101',...
% 'EitoT02102',...
% 'EitoT02103',...
% 'EitoT02104',...
% 'EitoT02105',...
% 'EitoT02106',...
% 'EitoT02107',...
% 'EitoT02108',...
% 'EitoT02109',...
% 'EitoT02110',...
% 'EitoT02301',...
% 'EitoT02302',...
% 'EitoT02303',...
% 'EitoT02304',...
% 'EitoT02305',...
% 'EitoT02306',...
% 'EitoT02307',...
% 'EitoT02308',...
% 'EitoT02309',...
% 'EitoT02310',...
% 'EitoT02311',...
% 'EitoT02312',...
% 'EitoT02313',...
% 'EitoT02314',...
% 'EitoT02315',...
% 'EitoT02316',...
% 'EitoT02401',...
% 'EitoT02402',...
% 'EitoT02403',...
% 'EitoT02404',...
% 'EitoT02405',...
% 'EitoT02406',...
% 'EitoT02407',...
% 'EitoT02408',...
% 'EitoT02409',...
% 'EitoT02410',...
% 'EitoT02411',...
% 'EitoT02412',...
% 'EitoT02413',...
% 'EitoT02414',...
% 'EitoT02415',...
% 'EitoT02416',...
% 'EitoT02417',...
% 'EitoT02418',...
% 'EitoT02419',...
% 'EitoT02501',...
% 'EitoT02502',...
% 'EitoT02503',...
% 'EitoT02504',...
% 'EitoT02505',...
% 'EitoT02506',...
% 'EitoT02507',...
% 'EitoT02601',...
% 'EitoT02602',...
% 'EitoT02603',...
% 'EitoT02604',...
% 'EitoT02605',...
% 'EitoT02606',...
% 'EitoT02607',...
% 'EitoT02608',...
% 'EitoT02609',...
% 'EitoT02610',...
% 'EitoT02611',...
% 'EitoT02701',...
% 'EitoT02702',...
% 'EitoT02703',...
% 'EitoT02704',...
% 'EitoT02705',...
% 'EitoT02706',...
% 'EitoT02707',...
% 'EitoT02708',...
% 'EitoT02709',...
% 'EitoT02710',...
% 'EitoT02711',...
% 'EitoT02712',...
% 'EitoT02713'};
% 
% 
% % Expnames    = {'EitoT00215'};