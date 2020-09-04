clear all
clc
close all

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                CIBIT
%                    Brain Imaging Network Portugal
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FileName:   Ultimatum_Game_EN
%
% Project:    Trust Game
%
% Descripion: Ultimatum Game experiment
%             Trial sequence: fixation cross, info on the amount to be 
%		      divided and participant decision to accept or reject the offer
%			  and feedback period.
%            
%             
% Autor:      Sara Santos
% Version:    
% Date:       2014
% Update:
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






header1 = 'Trustee';
header2 = 'TotalValue';
header3 = 'Proportion';
header4 = 'Response';
header5 = 'RT';

info_nome = input('Nome: ', 's');
fid=fopen(strcat(info_nome, '.txt'),'w');
fprintf(fid, [header1 ' ' header2 ' ' header3 ' ' header4 ' ' header5 ' \r\n']);


path = 'D:\exp_TrustGame\Tasks_Code_e_Design\UG\Ultimatum_Game_Code';

videoExtension = '.avi';

ZeroTime = GetSecs;

%Initial amounts to be divided
valores = [10, 7.5, 2.5, 0.2];
numproporcoes = 5; 
countT1 = 0;
countT2 = 0;

%proportions for division
for j= 1 : length(valores)
    top = 9;
    bottom = 1;
        
        for i = 1: numproporcoes
            if top ~= 7
                countT1 = countT1 + 1;
                               
                t1aux = trial;
                t1aux.proporcao = top * 0.1;
                t1aux.valor = valores(j);
                t1aux.img = strcat(path, '\Images\pedro_', num2str(top), '_', num2str(bottom), '.png');

                if top > 6
                    t1aux.video = strcat(path, '\Videos\T1\AvertedT1_', num2str(randi([1 2],1,1)), videoExtension);
                else
                    t1aux.video = strcat(path, '\Videos\T1\LongT1_', num2str(randi([1 2],1,1)), videoExtension);
                end
                t1aux.nome = 'Pedro';
                trialsT1(countT1) = t1aux;
                
                if top == 9 || top == 8
                   countT1 = countT1 + 1;
                   trialsT1(countT1) = t1aux;
                end

                
				countT2 = countT2 + 1;
                t2aux = trial;
                t2aux.proporcao = top * 0.1;
                t2aux.valor = valores(j);
                t2aux.img = strcat(path, '\Images\ivo_', num2str(top), '_', num2str(bottom), '.png');

                if top > 6
                    t2aux.video = strcat(path, '\Videos\T2\AvertedT2_', num2str(randi([1 2],1,1)), videoExtension);
                else
                    t2aux.video = strcat(path, '\Videos\T2\LongT2_', num2str(randi([1 2],1,1)), videoExtension);
                end
                t2aux.nome = 'Ivo';
                trialsT2(countT2) = t2aux;
                
                if top == 6 || top == 5
                   countT2 = countT2 + 1; 
                   trialsT2(countT2) = t2aux; 
                end

            end
            top = top - 1;
            bottom = bottom + 1;
        end
    
    
end



arrayT = [trialsT1 trialsT2];
array = arrayT(randperm(numel(arrayT)));

totalduration = 0;

Screen('Preference','Verbosity',0);
Screen('Preference','SkipSyncTests',1);
Screen('Preference','VisualDebugLevel',0);

screenNum=0;
[window, rect] = Screen('OpenWindow', screenNum, [155,194,183]);



for i = 1: 48 
   
   
    HideCursor;
    
    
    fixcross_time = 1.5;
    fixation_cross(fixcross_time, window, rect);
    array(i).img
    array(i).video
    vpath = strcat(array(i).video);
    Trustee_Movie(vpath, window, rect);
    
    Screen('TextSize',window, 30);
	
	%Info on the amount to be divided
    text_1 =  sprintf('%s%s%s%s%s', array(i).nome, ' was offered ', num2str(array(i).valor), ' euros ', ' but he needs to '); 
    [nx, ny, bbox] = DrawFormattedText(window, text_1, 'center', 350, 0);
    text_2 = ' share it with you.';
    [nx, ny, bbox] = DrawFormattedText(window, text_2, 'center', 450, 0);
    text_3 = 'This is his proposal:';
    [nx, ny, bbox] = DrawFormattedText(window, text_3, 'center', 550, 0);
    Screen('Flip',window);
    WaitSecs(4);
    
	%Offer and participant decision period to accept or reject
    showOffer(array(i).img, window, rect);
    
    StartTime = GetSecs;
    
    KbName('UnifyKeyNames');
    KbWait;
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;% Wait for answer and check kwhich key was pressed

    response=KbName(keyCode);
    
  
   %Feedback Period
        
    
    if strcmp(response,'LeftArrow') %Accept - LeftArrow
	
        ganhouPc = array(i).proporcao * array(i).valor;
        
        ganhouUser = (1 - array(i).proporcao) * array(i).valor;
        
        Screen('TextSize',window, 30);
        text_1 = 'You accepted!'; 
        [nx, ny, bbox] = DrawFormattedText(window, text_1, 'center', 300, 0);
        text_2 = sprintf('%s%s%s%s%s%s%s', 'From the initial value of ', num2str(array(i).valor), ' euros, ', array(i).nome, ' won ', num2str(ganhouPc), ' euros.');
        [nx, ny, bbox] = DrawFormattedText(window, text_2, 'center', 400, 0);
        text_3 =  sprintf('%s%s%s', 'You have won ', num2str(ganhouUser), ' euros.');
        [nx, ny, bbox] = DrawFormattedText(window, text_3, 'center', 500, 0);
        Screen('Flip',window);
        WaitSecs(4);
        
        
    else % Reject
         Screen('TextSize',window, 30);
        text_1 = 'You rejected!'; 
        [nx, ny, bbox] = DrawFormattedText(window, text_1, 'center', 400, 0);
        
        text_3 = 'None of you will receive any money.';
        [nx, ny, bbox] = DrawFormattedText(window, text_3, 'center', 500, 0);
        Screen('Flip',window);
        WaitSecs(4);
                   
        
        
    end
    

    
    secs = secs - StartTime;
    fprintf(fid, '%s %.2f %.2f %s %f %f' , array(i).nome, array(i).valor, array(i).proporcao, response, secs);
    fprintf(fid, '\n');
end


sca

totalduration = GetSecs - ZeroTime;
fprintf(fid, 'Total Duration: ');
fprintf(fid, '%f', totalduration);
fprintf(fid, '\n');
fclose(fid);

