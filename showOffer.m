function showOffer(myimgfile, window, rect) 

    ima=imread(myimgfile, 'png');

    Screen('PutImage', window, ima);
    Screen('Flip',window);


return
