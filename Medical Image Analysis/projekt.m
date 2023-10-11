function boneSegmentationApp()

    % GUI
    app = uifigure('Name','Segmentacja kości');
    app.Position = [100 100 350 400];

    selectButton = uibutton(app,'push','Position',[20 350 100 22],'Text','Wybierz zdjęcie','ButtonPushedFcn',@(selectButton,event) selectButtonPushed(app));
    segmentButton = uibutton(app,'push','Position',[140 350 150 22],'Text','Segmentuj wybraną kość','ButtonPushedFcn',@(segmentButton,event) segmentButtonPushed(app));

    UIAxes1 = uiaxes(app,'Position',[20 20 300 300],'ButtonDownFcn',@(obj,event) axesClickCallback(app,obj,event));

    % Choose picture function
    function selectButtonPushed(app)
        [fileName, filePath] = uigetfile({'*.jpg;*.png;*.bmp;*.tiff;*.dcm','Image Files'},'Wybierz obraz');
        if fileName ~= 0
            imagePath = fullfile(filePath, fileName);
            app.UserData.imagePath = imagePath;
            app.UserData.imageData = dicomread(imagePath);
            imshow(app.UserData.imageData, [], 'Parent', UIAxes1);
        end
    end

    % Bone segmentation function
    function segmentButtonPushed(app)
        if isfield(app.UserData, 'imageData')
            I = app.UserData.imageData;
            imshow(app.UserData.imageData, [], 'Parent', UIAxes1);
            title(UIAxes1, 'Wybierz strukturę');
            roi = drawpoint(UIAxes1);
            x = roi.Position(1);
            y = roi.Position(2);
            C = 0.15; 
            contrastAdjusted = imadjust(I);
            BW = im2bw(contrastAdjusted, graythresh(contrastAdjusted) + C);
            se = strel('disk', 3);
            BW = imclose(BW, se);
            CC = bwconncomp(BW);
            L = labelmatrix(CC);
            idx = L(round(y), round(x));
            segmentedData = ismember(L, idx);
            imshow(segmentedData, 'Parent', UIAxes1);
       end
    end
end