addpath('Plot functions');        % Path of plot functions

shared_RMG_parameters;

%% Figure specific parameters
x_offset = 2;
x_gap = 0.75;

y_offset = 2;
y_gap = 1;
y_length = [4,4,4,4,4,4];

y_begin = zeros(size(y_length));
for ii = 1:length(y_length)/2
    y_begin(ii) = y_offset + (y_length(ii) + y_gap) * (3-ii);
end
y_begin(4:6)= y_begin(1:3);

Data_Aspect_Ratio = [1,1,1];

waveforms = {'mp','hs'};

for ii = 1 : 2
    %%
    wvf = waveforms{ii};
    
    plot_label_cb_RMG_UND;
    plot_SC_RMG_UND;
    plot_F8Ca_RMG_UND;
    plot_F8Cp_RMG_UND;
    %
    
    %%
    x_mark_l = 1:50;
    x_mark_r = 50+1;
    y_mark1_l = 1:round((1 - y_unit*( y_begin(4) - y_gap/2 ))*figure_length_y);
    y_mark2_l = round((1 - y_unit*( y_begin(1) + y_length(1) +  y_gap/2 ))*figure_length_y)+1 : round((1 - y_unit*( y_begin(3) - y_gap/2 ))*figure_length_y);
    y_mark3_l = round((1 - y_unit*( y_begin(4) - y_gap/2 ))*figure_length_y)+1;
    
    y_mark1_r = 1:round((1 - y_unit*( y_begin(3) - y_gap/2 ))*figure_length_y);
    y_mark2_r = round((1 - y_unit*( y_begin(4)+ y_length(4) + y_gap/2 ))*figure_length_y)+1;
    
    im_0 = cat(1, im_0u(y_mark1_r,:,:), im_0d(y_mark2_r:end,:,:));
    im_end = cat(1, im_end_u(y_mark1_r,:,:), im_end_d(y_mark2_r:end,:,:));
    
    im_0 = cat(2, im_0,  cat(1, cat(1,im_1d(y_mark1_l,x_mark_l,:), im_1u(y_mark2_l,x_mark_l,:)), im_1d(y_mark3_l:end,x_mark_l,:) ));
    
    im_1 = cat(1, im_1u(y_mark1_r,x_mark_r:end,:), im_1d(y_mark2_r:end ,x_mark_r:end,:));
    im_2 = cat(1, im_2u(y_mark1_r,x_mark_r:end,:), im_2d(y_mark2_r:end ,x_mark_r:end,:));
    im_3 = cat(1, im_3u(y_mark1_r,x_mark_r:end,:), im_3d(y_mark2_r:end ,x_mark_r:end,:));
    
    im = cat(2, im_0, im_1);
    im = cat(2, im, im_2);
    im = cat(2, im, im_3);
    im = cat(2, im, im_end);
    [imind,cm] = rgb2ind(im,256);
    imwrite(    imind,cm,['MS_RMG_',wvf,'_UND_combined.tif'],'tif','WriteMode','overwrite', 'Resolution',500,'Compression','none');
end

rmpath('Plot functions');
