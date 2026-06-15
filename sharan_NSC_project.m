function steganography()

clc; close all;

%% ================= FIGURE =================
fig = uifigure('Name','Image Steganography System',...
    'Position',[100 100 1100 650]);

%% ================= PANELS =================
p1 = uipanel(fig,'Title','Embed Secret Text',...
    'Position',[20 330 500 290]);

p2 = uipanel(fig,'Title','Extract Hidden Text',...
    'Position',[20 20 500 290]);

%% ================= AXES =================
ax1 = uiaxes(fig,'Position',[560 360 250 250]);
title(ax1,'Original Image');

ax2 = uiaxes(fig,'Position',[560 60 250 250]);
title(ax2,'Stego Image');

ax3 = uiaxes(fig,'Position',[850 60 220 220]);
title(ax3,'LSB Plane (Red)');

%% ================= EMBED UI =================
uilabel(p1,'Text','Cover Image:','Position',[20 220 100 22]);
coverField = uieditfield(p1,'text','Position',[130 220 230 22]);
uibutton(p1,'Text','Browse','Position',[370 220 80 22],...
    'ButtonPushedFcn',@loadCoverImage);

uilabel(p1,'Text','Secret Text:','Position',[20 180 100 22]);
secretField = uieditfield(p1,'text','Position',[130 180 230 22]);

uilabel(p1,'Text','Password:','Position',[20 140 100 22]);
passField = uieditfield(p1,'text','Position',[130 140 230 22]);

uibutton(p1,'Text','Embed Text','Position',[130 90 100 30],...
    'ButtonPushedFcn',@embedText);

uibutton(p1,'Text','Save Stego Image','Position',[250 90 140 30],...
    'ButtonPushedFcn',@saveStego);

%% ================= EXTRACT UI =================
uilabel(p2,'Text','Stego Image:','Position',[20 220 100 22]);
stegoField = uieditfield(p2,'text','Position',[130 220 230 22]);
uibutton(p2,'Text','Browse','Position',[370 220 80 22],...
    'ButtonPushedFcn',@loadStegoImage);

uilabel(p2,'Text','Password:','Position',[20 180 100 22]);
passField2 = uieditfield(p2,'text','Position',[130 180 230 22]);

uibutton(p2,'Text','Extract Text','Position',[130 130 120 30],...
    'ButtonPushedFcn',@extractText);

uilabel(p2,'Text','Extracted Message:','Position',[20 90 150 22]);
outputArea = uitextarea(p2,'Position',[20 20 450 70]);

%% ================= VARIABLES =================
coverImage = [];
stegoImage = [];

%% ================= FUNCTIONS =================

    function loadCoverImage(~,~)
        [f,p] = uigetfile({'*.png;*.jpg;*.jpeg'});
        if f==0, return; end
        coverField.Value = fullfile(p,f);

        [img,map] = imread(coverField.Value);
        if ~isempty(map)
            img = im2uint8(ind2rgb(img,map));
        end
        coverImage = img;
        imshow(coverImage,'Parent',ax1);
    end

    function embedText(~,~)
        if isempty(coverImage)
            uialert(fig,'Load cover image','Error'); return;
        end

        msg = secretField.Value;
        pwd = passField.Value;

        if isempty(msg) || isempty(pwd)
            uialert(fig,'Enter text and password','Error'); return;
        end

        encMsg = xorEncrypt(msg, pwd);

        msgBin = reshape(dec2bin(uint8(encMsg),8).'-'0',1,[]);
        lenBin = dec2bin(length(msgBin),32)-'0';
        allBits = [lenBin msgBin];

        [r,c,~] = size(coverImage);
        if length(allBits) > r*c
            uialert(fig,'Message too long','Error'); return;
        end

        stegoImage = coverImage;
        idx = 1;
        for i=1:r
            for j=1:c
                if idx <= length(allBits)
                    stegoImage(i,j,1) = bitset(stegoImage(i,j,1),1,allBits(idx));
                    idx = idx + 1;
                end
            end
        end

        imshow(stegoImage,'Parent',ax2);
        imshow(bitget(stegoImage(:,:,1),1),[],'Parent',ax3);
        uialert(fig,'Text embedded with password','Success');
    end

    function saveStego(~,~)
        if isempty(stegoImage)
            uialert(fig,'No stego image','Error'); return;
        end
        [f,p] = uiputfile('stego.png');
        if f==0, return; end
        imwrite(stegoImage,fullfile(p,f));
    end

    function loadStegoImage(~,~)
        [f,p] = uigetfile({'*.png;*.jpg;*.jpeg'});
        if f==0, return; end
        stegoField.Value = fullfile(p,f);

        [img,map] = imread(stegoField.Value);
        if ~isempty(map)
            img = im2uint8(ind2rgb(img,map));
        end
        stegoImage = img;
        imshow(stegoImage,'Parent',ax2);
        imshow(bitget(stegoImage(:,:,1),1),[],'Parent',ax3);
    end

    function extractText(~,~)
        if isempty(stegoImage)
            uialert(fig,'Load stego image','Error'); return;
        end

        pwd = passField2.Value;
        if isempty(pwd)
            uialert(fig,'Enter password','Error'); return;
        end

        [r,c,~] = size(stegoImage);
        bits = zeros(1,r*c);
        idx = 1;
        for i=1:r
            for j=1:c
                bits(idx) = bitget(stegoImage(i,j,1),1);
                idx = idx + 1;
            end
        end

        msgLen = bin2dec(char(bits(1:32)+'0'));
        msgBits = bits(33:32+msgLen);
        encMsg = char(bin2dec(reshape(char(msgBits+'0'),8,[]).')).';

        try
            msg = xorDecrypt(encMsg, pwd);
            outputArea.Value = msg;
        catch
            outputArea.Value = 'Wrong password!';
        end
    end
end

%% ================= ENCRYPTION FUNCTIONS =================
function out = xorEncrypt(msg, key)
    msg = uint8(msg);
    key = uint8(key);
    out = char(bitxor(msg, key(mod(0:length(msg)-1,length(key))+1)));
end

function out = xorDecrypt(msg, key)
    out = xorEncrypt(msg, key); % XOR is reversible
end
