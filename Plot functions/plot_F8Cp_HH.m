coil_title = 'Figure-8 coil - perpendicular';
x_lim = [-5.03,5.03];   %cm

h_f = figure(format_figure);
set_axes_2x3;

%% F8Cp_mp F8Cp_mp F8Cp_mp F8Cp_mp F8Cp_mp F8Cp_mp F8Cp_mp F8Cp_mp F8Cp_mp
ax_ind_coil = 1;

model_name='F8Cp_mp_HH';

filename=fullfile(model_name,[model_name,'_compiled_result.mat']);
load(filename,'compiled_results');

XX_all = compiled_results.XX;
YY_all = compiled_results.YY;
th_CE = compiled_results.th_CE;
th_MCE = compiled_results.th_MCE;
th_per_diff = compiled_results.th_per_diff_MCE;
R_coil = compiled_results.R_coil;

th_CE(isnan(th_CE)) = 1e7;
th_per_diff(isnan(th_per_diff)) = -100;

%--------------------------------------------------------------------------
ax_ind_type = 1;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_CE)),color_level_amp,'LineStyle','none');

ind_Y = find(YY_all(1,:)>=-4);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_CE(:,ind_Y)),10.^(ceil(amp_log_min) + [1,1]));
set(h_contour,contour_line,'Color','k');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);
ind_Y = find(YY_all(1,:)>=-1.25);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_CE(:,ind_Y)),10.^(ceil(amp_log_min) + [2,2]));
set(h_contour,contour_line,'Color','k');
ind_Y = find(YY_all(1,:)<=-1.25);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_CE(:,ind_Y)),10.^(ceil(amp_log_min) + [2,2]));
set(h_contour,contour_line,'Color','k');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 2;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_MCE)),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_MCE),10.^(round(amp_log_min:amp_log_max)));
set(h_contour,contour_line,'Color','k');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 3;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,th_per_diff,color_level_per_neg,'LineStyle','none');

% left
ind_X = find( XX_all(:,1) >= -3.75 & XX_all(:,1) <=0);
ind_Y = find( YY_all(1,:) >=-2.75 & YY_all(1,:) <= -1);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:10:-70));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',100,'Color','w');
ind_Y = find(  YY_all(1,:) >= -1);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:10:-70));
set(h_contour,contour_line,'Color','w');
ind_X = find(XX_all(:,1) <= -3.75);
[~,h_contour]=contour(XX_all(ind_X,:),YY_all(ind_X,:),th_per_diff(ind_X,:),(-90:10:-70));
set(h_contour,contour_line,'Color','w');


ind_Y = find( YY_all(1,:) >=-1.5);
ind_X = find( XX_all(:,1) >= -3.75 & XX_all(:,1) <=-1.75);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-60:10:-40));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',12,'Interpreter','latex','LabelSpacing',100,'Color','w');

ind_X = find( XX_all(:,1) >= -1.75 & XX_all(:,1) <=0);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-60:10:-40));
set(h_contour,contour_line,'Color','w');

% right
ind_X = find( XX_all(:,1) <= 3.25 & XX_all(:,1) >=0);
ind_Y = find( YY_all(1,:) >=-2.5 & YY_all(1,:) <= -0.5);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-90:10:-70));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',100,'Color','w');

ind_X = find( XX_all(:,1) <= 3.25 & XX_all(:,1) >=0);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-60:10:-50));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',100,'Color','w');

ind_X = find(XX_all(:,1) >= 3.25);
[~,h_contour]=contour(XX_all(ind_X,:),YY_all(ind_X,:),th_per_diff(ind_X,:),(-90:10:-50));
set(h_contour,contour_line,'Color','w');

% bottom
ind_Y = find(YY_all(1,:) <= -2.5);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),(-90:10:-60));
set(h_contour,contour_line,'Color','w');
% [C,h]=contour(XX_all,YY_all,th_per_diff,(-90:10:-40));
% clabel(C,h,'FontSize',13,'Interpreter','latex','LabelSpacing',250,'Color','w');

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% F8Cp_hs F8Cp_hs F8Cp_hs F8Cp_hs F8Cp_hs F8Cp_hs F8Cp_hs F8Cp_hs F8Cp_hs F8Cp_hs
ax_ind_coil = 2;

model_name='F8Cp_hs_HH';

filename=fullfile(model_name,[model_name,'_compiled_result.mat']);
load(filename,'compiled_results');

XX_all = compiled_results.XX;
YY_all = compiled_results.YY;
th_CE = compiled_results.th_CE;
th_MCE = compiled_results.th_MCE;
th_per_diff = compiled_results.th_per_diff_MCE;
R_coil = compiled_results.R_coil;

th_CE(isnan(th_CE)) = 1e7;
th_per_diff(isnan(th_per_diff)) = -100;

%--------------------------------------------------------------------------
ax_ind_type = 1;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_CE)),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_CE),10.^(ceil(amp_log_min):floor(amp_log_max)-1));
set(h_contour,contour_line,'Color','k');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',300);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 2;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_MCE)),amp_log_min-0.1:0.01:amp_log_max,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_MCE),10.^(round(amp_log_min:amp_log_max)));
set(h_contour,contour_line,'Color','k');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% --------------------------------------------------------------------------
ax_ind_type = 3;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,th_per_diff,color_level_per_neg,'LineStyle','none');

ind_Y = find(YY_all(1,:)>=-1.25);
ind_X = find( XX_all(:,1) >= 0 );
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-65:5:-60));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',100,'Color','w');
ind_X = find( XX_all(:,1) <= 0 );
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-70:5:-65));
set(h_contour,contour_line,'Color','w');

ind_X = find( XX_all(:,1) >=-4 & XX_all(:,1) <= 0 );
ind_Y = find( YY_all(1,:) >=-3.25 & YY_all(1,:) <= -1.0);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-85));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',100,'Color','w');
ind_Y = find( YY_all(1,:) >=-1.0);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-85));
set(h_contour,contour_line,'Color','w');
ind_Y = find(YY_all(1,:) <= -3.25);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-85));
set(h_contour,contour_line,'Color','w');

ind_Y = find( YY_all(1,:) >=-3.25);
ind_X = find( XX_all(:,1) >=-4 & XX_all(:,1) <= -1.75 );
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-80:5:-75));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',12,'Interpreter','latex','LabelSpacing',100,'Color','w');
ind_X = find( XX_all(:,1) >=-1.75 & XX_all(:,1) <= -0 );
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-80:5:-75));
set(h_contour,contour_line,'Color','w');

ind_X = find(XX_all(:,1) <= -4);
[~,h_contour]=contour(XX_all(ind_X,:),YY_all(ind_X,:),th_per_diff(ind_X,:),(-90:5:-85));
set(h_contour,contour_line,'Color','w');

ind_X = find( XX_all(:,1) <= 3.5 & XX_all(:,1) >= 0 );
ind_Y = find( YY_all(1,:) >=-2.75 & YY_all(1,:) <= -0.75);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-70));
set(h_contour,contour_line,'Color','w');
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',100,'Color','w');
ind_Y = find( YY_all(1,:) >=-0.75);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-70));
set(h_contour,contour_line,'Color','w');
ind_Y = find(YY_all(1,:) <= -2.75);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),(-95:5:-70));
set(h_contour,contour_line,'Color','w');

ind_X = find(XX_all(:,1) >= 3.5);
[C,h_contour]=contour(XX_all(ind_X,:),YY_all(ind_X,:),th_per_diff(ind_X,:),(-95:5:-70));
set(h_contour,contour_line,'Color','w');

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
%%

frame = getframe(h_f);
im_3 = frame2im(frame);
im_3 = im_3(round( (1 - ( y_begin(1) + y_length(1) + y_gap/2) * y_unit ) * figure_length_y)*2 +1:round( (1 - ( y_begin(2) - y_gap*3/2) * y_unit ) * figure_length_y)*2,:,:);
close(h_f)