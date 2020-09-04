function fixation_cross(time, window, rect)


[X,Y] = RectCenter(rect);
FixCross = [X-1,Y-40,X+1,Y+40;X-40,Y-1,X+40,Y+1];
Screen('FillRect', window, [0,0,0], FixCross');
Screen('Flip', window);
WaitSecs(time)


return