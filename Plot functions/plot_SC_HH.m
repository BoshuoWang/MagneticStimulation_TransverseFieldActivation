coil_title = 'Circular coil';
x_lim = [-5.03,5.03];   %cm

h_f = figure(format_figure);
set_axes_2x3;

%% SC_mp SC_mp SC_mp SC_mp SC_mp SC_mp SC_mp SC_mp SC_mp SC_mp SC_mp SC_mp 
ax_ind_coil = 1;

model_name='SC_mp_HH';

filename=fullfile(model_name,[model_name,'_compiled_result.mat']);
load(filename,'compiled_results');

XX_all = compiled_results.XX;
YY_all = compiled_results.YY;
th_CE = compiled_results.th_CE;
th_MCE = compiled_results.th_MCE;
th_per_diff = compiled_results.th_per_diff_MCE;
R_coil = compiled_results.R_coil;

th_CE(XX_all==0) = 1e7;
th_th_per_diff(XX_all==0) = -100;

%
%-------------------------------------------------------------------------
ax_ind_type = 1;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_CE)),color_level_amp,'LineStyle','none');

ind_Y = find(YY_all(1,:)>=-4);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_CE(:,ind_Y)),10.^(ceil(amp_log_min) + [1,1]));
set(h_contour,contour_line,'Color','k');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_CE(:,ind_Y)),10.^(ceil(amp_log_min) + [2,2]));
set(h_contour,contour_line,'Color','k');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 2;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_MCE)),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all(:,:),YY_all(:,:),abs(th_MCE(:,:)),10.^round(amp_log_min:amp_log_max));
set(h_contour,contour_line,'Color','k');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%%--------------------------------------------------------------------------
ax_ind_type = 3;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,th_per_diff,color_level_per_neg,'LineStyle','none');

ind_Y = find(YY_all(1,:)>=-1);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[-50,-50]);
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');

ind_Y = find( YY_all(1,:) >=-2.55);
ind_X = find(abs(XX_all(:,1)) <=3.75);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:10:-60));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');
ind_X = find(XX_all(:,1) <= -3.75);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:10:-60));
set(h_contour,contour_line,'Color','w');
ind_X = find(XX_all(:,1) >= 3.75);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:10:-60));
set(h_contour,contour_line,'Color','w');

ind_Y = find(YY_all(1,:) <= -2.5);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),(-90:10:-60));
set(h_contour,contour_line,'Color','w');

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% SC_hs SC_hs SC_hs SC_hs SC_hs SC_hs SC_hs SC_hs SC_hs SC_hs SC_hs SC_hs 
ax_ind_coil = 2;

model_name='SC_hs_HH';

filename=fullfile(model_name,[model_name,'_compiled_result.mat']);
load(filename,'compiled_results');

XX_all = compiled_results.XX;
YY_all = compiled_results.YY;
th_CE = compiled_results.th_CE;
th_MCE = compiled_results.th_MCE;
th_per_diff = compiled_results.th_per_diff_MCE;
R_coil = compiled_results.R_coil;

th_CE(XX_all==0) = 1e7;
th_per_diff(XX_all==0) = -100;

%-------------------------------------------------------------------------
ax_ind_type = 1;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_CE)),color_level_amp,'LineStyle','none');

ind_Y = find(YY_all(1,:)>=-1.5);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_CE(:,ind_Y)),10.^(ceil(amp_log_min) + [1,1]));
set(h_contour,contour_line,'Color','k');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_CE(:,ind_Y)),10.^(ceil(amp_log_min) + [2,2]));
set(h_contour,contour_line,'Color','k');
ind_Y = find(YY_all(1,:)<=-1.5);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_CE(:,ind_Y)),10.^(ceil(amp_log_min) + [2,2]));
set(h_contour,contour_line,'Color','k');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 2;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_MCE)),color_level_amp,'LineStyle','none');

ind_Y = find(YY_all(1,:)>=-1);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_MCE(:,ind_Y)),10.^round(amp_log_min:amp_log_max));
set(h_contour,contour_line,'Color','k');

ind_Y = find(YY_all(1,:)>=-4 & YY_all(1,:)<=-1);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_MCE(:,ind_Y)),10.^round(amp_log_min:amp_log_max));
set(h_contour,contour_line,'Color','k');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);
% ind_Y = find(YY_all(1,:)<=-4);
% [~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_MCE(:,ind_Y)),10.^round(amp_log_min:amp_log_max));
% set(h_contour,contour_line,'Color','k');

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% --------------------------------------------------------------------------
ax_ind_type = 3;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,th_per_diff,color_level_per_neg,'LineStyle','none');

ind_Y = find(YY_all(1,:)>=-1);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[-65,-65]);
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');

ind_X = find(XX_all(:,1) <= -3.75);
[~,h_contour]=contour(XX_all(ind_X,:),YY_all(ind_X,:),th_per_diff(ind_X,:),(-95:5:-70));
set(h_contour,contour_line,'Color','w');

ind_X = find( XX_all(:,1) >=-3.75 & XX_all(:,1) <= 0 );
ind_Y = find( YY_all(1,:) >=-2.5);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-70));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');

ind_Y = find( YY_all(1,:) >=-4 & YY_all(1,:) <= -2.5);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-70));
set(h_contour,contour_line,'Color','w');

ind_X = find( XX_all(:,1) <= 4 & XX_all(:,1) >= 0 );
ind_Y = find( YY_all(1,:) >=-2.75);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-70));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');

ind_Y = find(YY_all(1,:) <= -2.75);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-70));
set(h_contour,contour_line,'Color','w');

ind_X = find(XX_all(:,1) >= 4);
[C,h_contour]=contour(XX_all(ind_X,:),YY_all(ind_X,:),th_per_diff(ind_X,:),(-95:5:-70));
set(h_contour,contour_line,'Color','w');

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%%
frame = getframe(h_f);
im_1 = frame2im(frame);
im_1 = im_1(round( (1 - ( y_begin(1) + y_length(1) + y_gap/2) * y_unit ) * figure_length_y) +1:round( (1 - ( y_begin(2) - y_gap*3/2) * y_unit ) * figure_length_y),:,:);
close(h_f);
