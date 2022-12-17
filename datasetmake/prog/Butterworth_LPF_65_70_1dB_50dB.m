function y = Butterworth_LPF_65_70_1dB_50dB(x)
%BUTTERWORTH_LPF_65_70_1DB_50DB Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 9.3 and DSP System Toolbox 9.5.
% Generated on: 05-Nov-2022 19:24:10

%#codegen

% To generate C/C++ code from this function use the codegen command. Type
% 'help codegen' for more information.

persistent Hd;

if isempty(Hd)
    
    % The following code was used to design the filter coefficients:
    % % Equiripple Lowpass filter designed using the FIRPM function.
    %
    % % All frequency values are in Hz.
    % Fs = 866;  % Sampling Frequency
    %
    % Fpass = 65;               % Passband Frequency
    % Fstop = 70;               % Stopband Frequency
    % Dpass = 0.057501127785;   % Passband Ripple
    % Dstop = 0.0031622776602;  % Stopband Attenuation
    % dens  = 20;               % Density Factor
    %
    % % Calculate the order from the parameters using FIRPMORD.
    % [N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);
    %
    % % Calculate the coefficients using the FIRPM function.
    % b  = firpm(N, Fo, Ao, W, {dens});
    
    Hd = dsp.FIRFilter( ...
        'Numerator', [-0.000329118524346542 -0.00299721377427455 ...
        -0.00265312794049665 -0.00365909817425248 -0.00434226522547063 ...
        -0.00476292324274179 -0.00480227451935427 -0.00441704036142818 ...
        -0.00362639745744625 -0.00251734274238663 -0.00123489881971335 ...
        4.06897260809298e-05 0.00112399051734907 0.00185945196814694 ...
        0.00214982325818454 0.00197716448503518 0.00140679491662317 ...
        0.000576366051861936 -0.000330897571346605 -0.00112151805441245 ...
        -0.00163124208345426 -0.00175743666132756 -0.0014814405024399 ...
        -0.000871357613590747 -6.85132356361165e-05 0.00074441608532155 ...
        0.00138220378695075 0.00169927802361346 0.00162157304168903 ...
        0.00116449223837962 0.000429680989821127 -0.000415948341097802 ...
        -0.00117772190209817 -0.00167668748824615 -0.00179164268248298 ...
        -0.0014877700820565 -0.000827233582567389 4.39045018729564e-05 ...
        0.000926956976196039 0.0016158039309873 0.00194354718620789 ...
        0.00182329305598321 0.00127008752910509 0.000401269266143122 ...
        -0.000588767198054558 -0.00147110303661617 -0.00203564309701536 ...
        -0.00213966464222176 -0.00174367224623351 -0.000923730995510806 ...
        0.000141456734861301 0.0012096048324367 0.00202990071812466 ...
        0.00240169949909441 0.00222223989990146 0.00151386775240499 ...
        0.000423874574506866 -0.000804625283865321 -0.00188789474834356 ...
        -0.00256659686678205 -0.00266736280621246 -0.00214433925920996 ...
        -0.00109775690911223 0.000245316603516028 0.00157983641667038 ...
        0.00259316481513641 0.00303471059785365 0.00277815830590171 ...
        0.00185821162258316 0.000466716973072804 -0.00108912905894764 ...
        -0.00244871482847368 -0.00328403920058128 -0.00337971399706974 ...
        -0.00268344553191787 -0.00132650624227359 0.000395822039869828 ...
        0.00209545067498509 0.00337048899420549 0.00390297219314423 ...
        0.00353975637076258 0.00232634134319696 0.000516146873629936 ...
        -0.00149220941185707 -0.0032324822627349 -0.00428453531077385 ...
        -0.00437042818786782 -0.00342875402236716 -0.00163631417810897 ...
        0.000621959053064402 0.00283447509037907 0.00447791501235984 ...
        0.00513873454334389 0.0046160529974811 0.00297807554301212 ...
        0.000558994718417879 -0.00210785057289675 -0.00440503718886698 ...
        -0.00577247559094364 -0.00584122033464616 -0.00453003990074246 ...
        -0.00207812127978674 0.000993966725468016 0.00399297289391084 ...
        0.00620599692736813 0.00706739928525461 0.00629832798853401 ...
        0.00398901670103698 0.000597480190417284 -0.00313652638448684 ...
        -0.00634955285006862 -0.00824841139806155 -0.00830095302051971 ...
        -0.00637638084562333 -0.00280193442023727 0.00168523768161637 ...
        0.00608289721418535 0.00934049090078442 0.0106004056995207 ...
        0.00941287314632548 0.00587029623478134 0.000626981121909058 ...
        -0.005210238543143 -0.0103017707714894 -0.0133673483354955 ...
        -0.0134871924489996 -0.0103471837917789 -0.0043660186083982 ...
        0.00332968628893453 0.0110920590132744 0.0170728444120478 ...
        0.0196196311396057 0.0176689991530994 0.0110521069745026 ...
        0.000645675537928624 -0.0116819216754207 -0.0233289453732093 ...
        -0.0313913075877513 -0.0331898681379802 -0.026801846864069 ...
        -0.0114922466875648 0.0120453630154041 0.0416847914870935 ...
        0.0741261873146856 0.105369446187665 0.131331013716889 0.148497521147393 ...
        0.154498739960229 0.148497521147393 0.131331013716889 0.105369446187665 ...
        0.0741261873146856 0.0416847914870935 0.0120453630154041 ...
        -0.0114922466875648 -0.026801846864069 -0.0331898681379802 ...
        -0.0313913075877513 -0.0233289453732093 -0.0116819216754207 ...
        0.000645675537928624 0.0110521069745026 0.0176689991530994 ...
        0.0196196311396057 0.0170728444120478 0.0110920590132744 ...
        0.00332968628893453 -0.0043660186083982 -0.0103471837917789 ...
        -0.0134871924489996 -0.0133673483354955 -0.0103017707714894 ...
        -0.005210238543143 0.000626981121909058 0.00587029623478134 ...
        0.00941287314632548 0.0106004056995207 0.00934049090078442 ...
        0.00608289721418535 0.00168523768161637 -0.00280193442023727 ...
        -0.00637638084562333 -0.00830095302051971 -0.00824841139806155 ...
        -0.00634955285006862 -0.00313652638448684 0.000597480190417284 ...
        0.00398901670103698 0.00629832798853401 0.00706739928525461 ...
        0.00620599692736813 0.00399297289391084 0.000993966725468016 ...
        -0.00207812127978674 -0.00453003990074246 -0.00584122033464616 ...
        -0.00577247559094364 -0.00440503718886698 -0.00210785057289675 ...
        0.000558994718417879 0.00297807554301212 0.0046160529974811 ...
        0.00513873454334389 0.00447791501235984 0.00283447509037907 ...
        0.000621959053064402 -0.00163631417810897 -0.00342875402236716 ...
        -0.00437042818786782 -0.00428453531077385 -0.0032324822627349 ...
        -0.00149220941185707 0.000516146873629936 0.00232634134319696 ...
        0.00353975637076258 0.00390297219314423 0.00337048899420549 ...
        0.00209545067498509 0.000395822039869828 -0.00132650624227359 ...
        -0.00268344553191787 -0.00337971399706974 -0.00328403920058128 ...
        -0.00244871482847368 -0.00108912905894764 0.000466716973072804 ...
        0.00185821162258316 0.00277815830590171 0.00303471059785365 ...
        0.00259316481513641 0.00157983641667038 0.000245316603516028 ...
        -0.00109775690911223 -0.00214433925920996 -0.00266736280621246 ...
        -0.00256659686678205 -0.00188789474834356 -0.000804625283865321 ...
        0.000423874574506866 0.00151386775240499 0.00222223989990146 ...
        0.00240169949909441 0.00202990071812466 0.0012096048324367 ...
        0.000141456734861301 -0.000923730995510806 -0.00174367224623351 ...
        -0.00213966464222176 -0.00203564309701536 -0.00147110303661617 ...
        -0.000588767198054558 0.000401269266143122 0.00127008752910509 ...
        0.00182329305598321 0.00194354718620789 0.0016158039309873 ...
        0.000926956976196039 4.39045018729564e-05 -0.000827233582567389 ...
        -0.0014877700820565 -0.00179164268248298 -0.00167668748824615 ...
        -0.00117772190209817 -0.000415948341097802 0.000429680989821127 ...
        0.00116449223837962 0.00162157304168903 0.00169927802361346 ...
        0.00138220378695075 0.00074441608532155 -6.85132356361165e-05 ...
        -0.000871357613590747 -0.0014814405024399 -0.00175743666132756 ...
        -0.00163124208345426 -0.00112151805441245 -0.000330897571346605 ...
        0.000576366051861936 0.00140679491662317 0.00197716448503518 ...
        0.00214982325818454 0.00185945196814694 0.00112399051734907 ...
        4.06897260809298e-05 -0.00123489881971335 -0.00251734274238663 ...
        -0.00362639745744625 -0.00441704036142818 -0.00480227451935427 ...
        -0.00476292324274179 -0.00434226522547063 -0.00365909817425248 ...
        -0.00265312794049665 -0.00299721377427455 -0.000329118524346542]);
end

y = step(Hd,double(x));


% [EOF]