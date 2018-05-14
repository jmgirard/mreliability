function [RESULTS] = mBINARY(DATA, OUTPUT)
% Calculate performance measures for binary classification tasks
%
%   DATA is a numeric matrix where each row is one object, the first column
%   contains the test results (predictions), and the second column contains
%   the criterion results (trusted labels). Note that the positive class
%   must be labeled as 1 and the negative class must be labeled as 0.
%
%   OUTPUT is an optional parameter determining what value is contained in
%   the RESULTS function output (default = 'table'). This is useful when
%   combined with the bootci() function to generate confidence intervals.
%
%   RESULTS is determined by the OUTPUT parameter.
%       'table' or 'all': A table containing all the other options
%       'ACC' or 'Accuracy': Accuracy
%       'TPR' or 'Sensitivity' or 'Recall': True Positive Rate
%       'TNR' or 'Specificity': True Negative Rate
%       'PPV' or 'Precision': Positive Predictive Value
%       'NPV': Negative Predictive Value
%       'PLR': Positive Likelihood Ratio
%       'NLR': Negative Likelihood Ratio
%       'F1S' or 'F1': F1 Score
%       'MCC' or 'PHI': Matthews Correlation Coefficient
%       'BMI' or 'BM': Bookmakers Informedness
%       'MRK' or 'MK': Markedness
%
%   Example usage: mBINARY([preds, labels])
%   Example usage: mBINARY([preds, labels], 'PLR')
%   Example usage: bootci(2000, @(x) mBINARY(x, 'F1S'), [preds, labels])
%
%   (c) Jeffrey M. Girard, 2018
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3
    POSCLASS = 1;
    NEGCLASS = 0;
end

if nargin < 4
    OUTPUT = 'table';
end

if ~isnumeric(DATA)
    disp('data must be numeric');
    RESULTS = NaN;
    return;
end

if size(DATA, 2) ~= 2
    disp('DATA must have 2 columns');
    RESULTS = NaN;
    return;
end

test = DATA(:, 1);
crit = DATA(:, 2);
TP = sum((test == POSCLASS) & (crit == POSCLASS));
FP = sum((test == POSCLASS) & (crit == NEGCLASS));
FN = sum((test == NEGCLASS) & (crit == POSCLASS));
TN = sum((test == NEGCLASS) & (crit == NEGCLASS));

ACC = (TP + TN) / (TP + TN + FP + FN);
TPR = TP / (TP + FN);
TNR = TN / (TN + FP);
PPV = TP / (TP + FP);
NPV = TN / (TN + FN);
PLR = TPR / (1 - TNR);
NLR = (1 - TPR) / TNR;
F1S = (2 * TP) / (2 * TP + FP + FN);
MCC = (TP * TN - FP * FN) / sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN));
BMI = TPR + TNR - 1;
MRK = PPV + NPV - 1;

if strcmpi(OUTPUT, 'table') || strcmpi(OUTPUT, 'all')
    RESULTS = table(ACC, TPR, TNR, PPV, NPV, PLR, NLR, F1S, MCC, BMI, MRK);
elseif strcmpi(OUTPUT, 'ACC') || strcmpi(OUTPUT, 'Accuracy')
    RESULTS = ACC;
elseif strcmpi(OUTPUT, 'TPR') || strcmpi(OUTPUT, 'Sensitivity') || strcmpi(OUTPUT, 'Recall')
    RESULTS = TPR;
elseif strcmpi(OUTPUT, 'TNR') || strcmpi(OUTPUT, 'Specificity')
    RESULTS = TNR;
elseif strcmpi(OUTPUT, 'PPV') || strcmpi(OUTPUT, 'Precision')
    RESULTS = PPV;
elseif strcmpi(OUTPUT, 'NPV')
    RESULTS = NPV;
elseif strcmpi(OUTPUT, 'PLR')
    RESULTS = PLR;
elseif strcmpi(OUTPUT, 'NLR')
    RESULTS = NLR;
elseif strcmpi(OUTPUT, 'F1S') || strcmpi(OUTPUT, 'F1')
    RESULTS = F1S;
elseif strcmpi(OUTPUT, 'MCC') || strcmpi(OUTPUT, 'PHI')
    RESULTS = MCC;
elseif strcmpi(OUTPUT, 'BMI') || strcmpi(OUTPUT, 'BM')
    RESULTS = BMI;
elseif strcmpi(OUTPUT, 'MRK') || strcmpi(OUTPUT, 'MK')
    RESULTS = MRK;
else
    RESULTS = NaN;
end

end