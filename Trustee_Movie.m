%Play Movie
%Needs QuickTime7

function Trustee_Movie(moviename, window, rect)
 % For a more complex demo see PlayMoviesDemo. The remaining demos show more advanced concepts
% like proper timing etc.


% Check if Psychtoolbox is properly installed:
%AssertOpenGL;

if nargin < 1 || isempty(moviename)
    % No moviename given: Use default movie:
    moviename = [ PsychtoolboxRoot 'PsychDemos/MovieDemos/DualDiscs.mov' ];
end

if nargin < 2 || isempty(rect)
    rect = [];
end

KbReleaseWait;% Wait until user releases keys on keyboard
%screenid = max(Screen('Screens'));% Select screen for display of movie

try
    % Open 'windowrect' sized window on screen, with black [0] background color:
   % win = Screen('OpenWindow', screenid, [0], windowrect);
    movie = Screen('OpenMovie', window, moviename);% Open movie file
    Screen('PlayMovie', movie, 1); % Start playback engine
    
    % Playback loop: Runs until end of movie or keypress:
    while ~KbCheck
        % Wait for next movie frame, retrieve texture handle to it
        tex = Screen('GetMovieImage', window, movie);
        
        % Valid texture returned? A negative value means end of movie reached:
        if tex<=0
            % We're done, break out of loop:
            break;
        end
        
        Screen('DrawTexture', window, tex); % Draw the new texture immediately to screen
        Screen('Flip', window);% Update display
        Screen('Close', tex); % Release texture
    end
    
    Screen('PlayMovie', movie, 0); % Stop playback
    Screen('CloseMovie', movie);  % Close movie
    
    
catch %#ok<CTCH>
    sca;
    psychrethrow(psychlasterror);
end

return

