addpath('Plot functions');        % Path of plot functions

shared_HH_parameters;

%% Figure specific parameters
title_text = {'Conventional CE','Modified CE','Modified CE vs. Conventional CE'};

x_offset = 4;
x_gap = 1;

x_length = [10,10,10];
x_begin = zeros(size(x_length));
for ii = 1:length(x_length)
    x_begin(ii) = x_offset + (x_length(ii) + x_gap) * (ii-1);
end 
x_begin(3) = x_begin(3) + x_gap * 0.5;

y_offset = 2;
y_gap = 1;
y_length = [4,4];

y_begin = zeros(size(y_length));
for ii = 1:length(y_length)
    y_begin(ii) = y_offset + (y_length(ii) + y_gap) * (3-ii);
end

Data_Aspect_Ratio = [1,1,1];

color_bar.TickLength = 0.01;
color_bar_title.HorizontalAlignment = 'Right';
color_bar_title.VerticalAlignment = 'Middle';
color_bar_title.Position = [0,0.5,0];
%%
plot_label_cb;
plot_SC_HH;
plot_F8Ca_HH;
plot_F8Cp_HH;

%%
im = cat(1, im_0, im_1);
im = cat(1, im, im_2);
im = cat(1, im, im_3);
im = cat(1, im, im_end);
[imind,cm] = rgb2ind(im,256);
imwrite(    imind,cm,'MS_HH_combined.tif','tif','WriteMode','overwrite', 'Resolution',500,'Compression','none');

rmpath('Plot functions');