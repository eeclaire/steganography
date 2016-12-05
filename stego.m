
msg = 'Hello world'; % message to embed

% read in image, convert to grayscale, show gray image
RGB = imread('impossibly-cute-puppy.jpg');
I = rgb2gray(RGB);
figure, imshow(I)

J = dct2(I);    % get the 2D DCT of the grayscale images 


msgIndex = 1;   % dumb 1-indexing


% hardcoding some numbers of iterations over the 37 rows and 42 columns
for yWindow = 1:37
    for xWindow = 1:42
        
        % Obtain a window of the image to operate on
        Jsegment = J(yWindow*16-15:yWindow*16, xWindow*16-15:xWindow*16);
        availableBlock=0;
        for i = 1:16
            for j = 1:16
                if Jsegment(j,i) > 100
                    availableBlock = 1;
                    Jsegment(j,i) = Jsegment(j,i)+msg(msgIndex);
                end
            end
        end
        
        % If this block now contains a msg character, iterate to next char
        if availableBlock > 0 & msgIndex < size(msg)
            msgIndex = msgIndex + 1;
        end
        
        % Concatenate all of the blocks back together for the inverse DCT
        J(yWindow*16-15:yWindow*16, xWindow*16-15:xWindow*16) = Jsegment; 
    end
end
        

figure, imshow(log(abs(J)),[]), colormap(gca,jet(64)), colorbar

% Convert back to spatial
K = idct2(J);
figure, imshow(K,[0 255])