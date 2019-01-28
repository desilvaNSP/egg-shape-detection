function X = Test(ImageFile)
% Step 1: Read image Read in
trainRGB = imread("normal/normal3.JPG"); %Treshold Image
%  figure,
%  imshow(trainRGB),
%  title('Original Image');

ITrain = rgb2gray(trainRGB);
seTrain = strel('disk',15)
trainBackground = imopen(ITrain,seTrain);
I2Train = ITrain - trainBackground;
I3Train = imadjust(I2Train);

% Step 2: Convert image from rgb to gray 
trainGRAY = rgb2gray(trainRGB);
% figure,
% imshow(trainGRAY),
% title('Gray Image');

trainThreshold = graythresh(I3Train);
trainBinaryimage = im2bw(trainGRAY, trainThreshold);
% figure,
% imshow(trainBinaryimage),
% title('Binary Image IM2bW');

%Filter Binary Image by Size of Objects
BW2Train = bwareafilt(trainBinaryimage,1);
% figure,
% imshow(BW2Train),
% title('BW2 Image');

BW2Train = im2bw(BW2Train); %// Just in case...
sTrain  = regionprops(BW2Train,'centroid');
centroids = cat(1, sTrain.Centroid);
% imshow(BW2Train)
% title('BW2 Image - Centroid');
hold on
plot(centroids(:,1), centroids(:,2), 'b*')
hold off

boundTrain = regionprops(BW2Train, 'BoundingBox', 'Area'); 
%// Obtaining Bounding Box co-ordinates
bboxesTrain = reshape([boundTrain.BoundingBox], 4, []).';

%// Obtain the areas within each bounding box
areasTrain = [boundTrain.Area].';

%// Figure out which bounding box has the maximum area
[~,maxIndTrain] = max(areasTrain);

%// Obtain this bounding box
%// Ensure all floating point is removed
finalBBTrain = floor(bboxesTrain(maxIndTrain,:));

%// Crop the image
outTrainBinaryimage = BW2Train(finalBBTrain(2):finalBBTrain(2)+finalBBTrain(4), finalBBTrain(1):finalBBTrain(1)+finalBBTrain(3));
%// Show the images
% figure;
% imshow(outTrainBinaryimage);

[theight, twidth, numberOfColorChannels] = size(outTrainBinaryimage)

fprintf("train width : %i", theight);
fprintf("train height : %i", twidth);
fprintf("train width/height : %f",theight/twidth);


%binaryimage: a binary image
trainxwidth = 1:size(outTrainBinaryimage, 2);
trainxcount = sum(outTrainBinaryimage, 1);
trainyheight = 1:size(outTrainBinaryimage, 1);
trainycount = sum(outTrainBinaryimage, 2);

% Step 1: Read image Read in
RGBevaluate = imread(ImageFile); %Treshold Image
% figure,
% imshow(RGBevaluate),
% title('Original Image');


IEvaluate = rgb2gray(RGBevaluate);
seEvaluate = strel('disk',15)
backgroundEvaluate = imopen(IEvaluate,seEvaluate);
% imshow(backgroundEvaluate)
I2evaluate = IEvaluate - backgroundEvaluate;
% figure,
% imshow(I2evaluate)


I3evaluate = imadjust(I2evaluate);
% figure,
% imshow(I3evaluate)

% Step 2: Convert image from rgb to gray 
evaluateGRAY = rgb2gray(RGBevaluate);
% figure,
% imshow(evaluateGRAY),
% title('Gray Image');

evaluatethreshold = graythresh(I3evaluate);
evaluateBinaryimage = im2bw(evaluateGRAY, evaluatethreshold);
% figure,
% imshow(evaluateBinaryimage),
% title('Binary Image');

%Filter Binary Image by Size of Objects
BW2evaluate = bwareafilt(evaluateBinaryimage,1);
% figure,
% imshow(BW2evaluate),
% title('BW2 Image');

BW2evaluate = im2bw(BW2evaluate); %// Just in case...
s  = regionprops(BW2evaluate,'centroid');
centroids = cat(1, s.Centroid);
% imshow(BW2evaluate)
% title('BW2 Image - Centroid');
hold on
plot(centroids(:,1), centroids(:,2), 'b*')
hold off

bound = regionprops(BW2evaluate, 'BoundingBox', 'Area'); 
%// Obtaining Bounding Box co-ordinates
bboxes = reshape([bound.BoundingBox], 4, []).';

%// Obtain the areas within each bounding box
areas = [bound.Area].';

%// Figure out which bounding box has the maximum area
[~,maxInd] = max(areas);

%// Obtain this bounding box
%// Ensure all floating point is removed
finalEvaluateBB = floor(bboxes(maxInd,:));

%// Crop the image
outEvaluateBinaryimage = BW2evaluate(finalEvaluateBB(2):finalEvaluateBB(2)+finalEvaluateBB(4), finalEvaluateBB(1):finalEvaluateBB(1)+finalEvaluateBB(3));
%// Show the images
figure;
imshow(outEvaluateBinaryimage);
title(ImageFile);


[height, width, numberOfColorChannels] = size(outEvaluateBinaryimage)

%binaryimage: a binary image
xwidth = 1:size(outEvaluateBinaryimage, 2);
xcount = sum(outEvaluateBinaryimage, 1);
yheight = 1:size(outEvaluateBinaryimage, 1);
ycount = sum(outEvaluateBinaryimage, 2);

fprintf("Image Name : %s  \n", ImageFile);
fprintf("width : %i  \n", height);
fprintf("height : %i \n", width);
fprintf("width/height : %f \n",height/width);


% NORMAL - 0.697 <  W/H <  0.801
% ROUND   -  0.801 <  W/H 
% SHARPE -   W/H  <  0.697

a = height/width;
if a >= 0.697 && a <= 0.801
   fprintf("Result : NORMAL\n");
   msgbox('NORMAL','Success');
elseif a > 0.801
    fprintf("Result : ROUND \n");
    msgbox('ROUND','Success');
else
    fprintf("Result : SHARPE \n");
    msgbox('SHARPE','Success');
end

% figure;
% idxmin = find(xcount == max(xcount));
% idxmax = find(xcount == min(xcount));
% plot(xwidth,xcount,'-p','MarkerIndices',[idxmin idxmax],...
%     'MarkerFaceColor','red',...
%     'MarkerSize',15)
% 
% xlabel('pixel position along x');
% ylabel('pixel count');
% title('Max value in horizontal histogram');
% 
% subplot(1, 2, 1);
% plot(xwidth, xcount, trainxwidth, trainxcount, '--');
% xlabel('pixel position along x');
% ylabel('pixel count');
% title('horizontal histogram');
% 
% subplot(1, 2, 2);
% plot(yheight, ycount, trainyheight, trainycount,'--');
% xlabel('pixel position along y');
% ylabel('pixel count');
% title('vertical histogram');

return


