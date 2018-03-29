coil_title = 'Figure-8 coil - aligned';
x_lim = [-2.53,7.53];   %cm

h_f = figure(format_figure);
set_axes_2x3;

%% F8Ca_mp F8Ca_mp F8Ca_mp F8Ca_mp F8Ca_mp F8Ca_mp F8Ca_mp F8Ca_mp F8Ca_mp F8Ca_mp F8Ca_mp F8Ca_mp
ax_ind_coil = 1;

model_name='F8Ca_mp_HH';

filename=fullfile(model_name,[model_name,'_compiled_result.mat']);
load(filename,'compiled_results');

XX_all = compiled_results.XX;
YY_all = compiled_results.YY;
th_CE = compiled_results.th_CE;
th_MCE = compiled_results.th_MCE;
th_per_diff = compiled_results.th_per_diff_MCE;
R_coil = compiled_results.R_coil;

ind_X_neg = (find(XX_all(:,1) <= abs(x_lim(1)) , 1, 'last') : -1: 1);
%--------------------------------------------------------------------------
ax_ind_type = 1;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf([-XX_all(ind_X_neg,:); XX_all],[ YY_all(ind_X_neg,:);  YY_all],...
            log10(abs([th_CE(ind_X_neg,:);th_CE])),color_level_amp,'LineStyle','none');

[C,h_contour]=contour( [-XX_all(ind_X_neg,:); XX_all],[ YY_all(ind_X_neg,:);  YY_all],...
                        abs([th_CE(ind_X_neg,:);th_CE]),10.^(ceil(amp_log_min):floor(amp_log_max)));
clabel(C,h_contour,'FontSize',12,'Interpreter','latex','LabelSpacing',350);
set(h_contour,contour_line,'Color','k');

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% --------------------------------------------------------------------------
ax_ind_type = 2;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf( XX_all,YY_all,log10(abs(th_MCE)),amp_log_min:0.01:amp_log_max,'LineStyle','none');
contourf(-XX_all(ind_X_neg,:),YY_all(ind_X_neg,:),log10(abs(th_MCE(ind_X_neg,:))),amp_log_min:0.01:amp_log_max,'LineStyle','none');

[C,h_contour]=contour( XX_all,YY_all,abs(th_MCE),10.^(round(amp_log_min:amp_log_max)));
set(h_contour,contour_line,'Color','k');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);
[~,h_contour]=contour(-XX_all(ind_X_neg,:),YY_all(ind_X_neg,:),abs(th_MCE(ind_X_neg,:)),10.^(round(amp_log_min:amp_log_max)));
set(h_contour,contour_line,'Color','k');

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% --------------------------------------------------------------------------
ax_ind_type = 3;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf( XX_all,YY_all,th_per_diff,color_level_per_neg,'LineStyle','none');
contourf(-XX_all(ind_X_neg,:),YY_all(ind_X_neg,:),th_per_diff(ind_X_neg,:),color_level_per_neg,'LineStyle','none');

ind_X = find(XX_all(:,1)<=2.5);
ind_Y = find(YY_all(1,:)>=-2.5);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:20:-50));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');
[C,h_contour]=contour(-XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:20:-50));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');
ind_Y = find(YY_all(1,:)<=-2.5);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:20:-50));
set(h_contour,contour_line,'Color','w');
[C,h_contour]=contour(-XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:20:-50));
set(h_contour,contour_line,'Color','w');
ind_Y = find(YY_all(1,:)<=-2.0);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-80:20:-40));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');
[~,h_contour]=contour(-XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-80:20:-40));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');
ind_Y = find(YY_all(1,:)>=-2.0);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-80:20:-40));
set(h_contour,contour_line,'Color','w');
[~,h_contour]=contour(-XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-80:20:-40));
set(h_contour,contour_line,'Color','w');

ind_Y = find(YY_all(1,:)>=-2.5);
ind_X = find(XX_all(:,1)>=2.25 & XX_all(:,1)<=5.5);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:10:-40));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');
ind_X = find(XX_all(:,1)>=5.5);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:10:-40));
set(h_contour,contour_line,'Color','w');

ind_Y = find(YY_all(1,:)<=-2.5);
ind_X = find(XX_all(:,1)>=2.25);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:10:-40));
set(h_contour,contour_line,'Color','w');

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs
ax_ind_coil = 2;
model_name='F8Ca_hs_HH';

filename=fullfile(model_name,[model_name,'_compiled_result.mat']);
load(filename,'compiled_results');

XX_all = compiled_results.XX;
YY_all = compiled_results.YY;
th_CE = compiled_results.th_CE;
th_MCE = compiled_results.th_MCE;
th_per_diff = compiled_results.th_per_diff_MCE;
R_coil = compiled_results.R_coil;

%--------------------------------------------------------------------------
ax_ind_type = 1;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf([-XX_all(ind_X_neg,:); XX_all],[ YY_all(ind_X_neg,:);  YY_all],...
            log10(abs([th_CE(ind_X_neg,:);th_CE])),color_level_amp,'LineStyle','none');

[C,h_contour]=contour( [-XX_all(ind_X_neg,:); XX_all],[ YY_all(ind_X_neg,:);  YY_all],...
                        abs([th_CE(ind_X_neg,:);th_CE]),10.^(ceil(amp_log_min):floor(amp_log_max)));
clabel(C,h_contour,'FontSize',12,'Interpreter','latex','LabelSpacing',350);
set(h_contour,contour_line,'Color','k');

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 2;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf( XX_all,YY_all,log10(abs(th_MCE)),amp_log_min:0.01:amp_log_max,'LineStyle','none');
contourf(-XX_all(ind_X_neg,:),YY_all(ind_X_neg,:),log10(abs(th_MCE(ind_X_neg,:))),amp_log_min:0.01:amp_log_max,'LineStyle','none');

[C,h_contour]=contour( XX_all,YY_all,abs(th_MCE),10.^(round(amp_log_min:amp_log_max)));
set(h_contour,contour_line,'Color','k');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);

[~,h_contour]=contour(-XX_all(ind_X_neg,:),YY_all(ind_X_neg,:),abs(th_MCE(ind_X_neg,:)),10.^(round(amp_log_min:amp_log_max)));
set(h_contour,contour_line,'Color','k');

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% --------------------------------------------------------------------------
ax_ind_type = 3;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf( XX_all,YY_all,th_per_diff,color_level_per_neg,'LineStyle','none');
contourf(-XX_all(ind_X_neg,:),YY_all(ind_X_neg,:),th_per_diff(ind_X_neg,:),color_level_per_neg,'LineStyle','none');

ind_X = find(XX_all(:,1)>=5.5);
[~,h_contour]=contour(XX_all(ind_X,:),YY_all(ind_X,:),th_per_diff(ind_X,:),(-80:5:-65));
set(h_contour,contour_line,'Color','w');
ind_X = find(XX_all(:,1)<=5.5 & XX_all(:,1)>=3.5);
[C,h_contour]=contour(XX_all(ind_X,:),YY_all(ind_X,:),th_per_diff(ind_X,:),(-85:5:-60));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');

ind_X = find(XX_all(:,1)<=3.5 & XX_all(:,1)>=2.25);
[~,h_contour]=contour(XX_all(ind_X,:),YY_all(ind_X,:),th_per_diff(ind_X,:),(-85:5:-60));
set(h_contour,contour_line,'Color','w');

ind_X = find(XX_all(:,1)>=2.25);
ind_Y = find(YY_all(1,:)<=-2);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-90));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');
[~,h_contour]=contour(-XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-90));
set(h_contour,contour_line,'Color','w');
ind_Y = find(YY_all(1,:)>=-2);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-90));
set(h_contour,contour_line,'Color','w');
[~,h_contour]=contour(-XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-90));
set(h_contour,contour_line,'Color','w');

ind_X = find(XX_all(:,1)<=2.5);
ind_Y = find(YY_all(1,:)<=-2.0);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-80:20:-60));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');
[C,h_contour]=contour(-XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-80:20:-60));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');
ind_Y = find(YY_all(1,:)>=-2.0);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-80:20:-60));
set(h_contour,contour_line,'Color','w');
[~,h_contour]=contour(-XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-80:20:-60));
set(h_contour,contour_line,'Color','w');

ind_Y = find(YY_all(1,:)>=-2.5);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:20:-50));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');
[C,h_contour]=contour(-XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:20:-50));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300,'Color','w');
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[-95,-95]);
set(h_contour,contour_line,'Color','w');
[~,h_contour]=contour(-XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[-95,-95]);
set(h_contour,contour_line,'Color','w');
ind_Y = find(YY_all(1,:)<=-2.5);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[-90:20:-50]);
set(h_contour,contour_line,'Color','w');
[~,h_contour]=contour(-XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[-90:20:-50]);
set(h_contour,contour_line,'Color','w');

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%%
frame = getframe(h_f);
im_2 = frame2im(frame);
im_2 = im_2(round( (1 - ( y_begin(1) + y_length(1) + y_gap/2) * y_unit ) * figure_length_y) +1:round( (1 - ( y_begin(2) - y_gap*3/2) * y_unit ) * figure_length_y),:,:);
close(h_f);
