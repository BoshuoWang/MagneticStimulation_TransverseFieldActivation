coil_title = 'Figure-8 coil - perpendicular';
x_lim = [-5.03,5.03];   %cm

h_f = figure(format_figure);
set_axes_2x3;

%% F8Cp_mp F8Cp_mp F8Cp_mp F8Cp_mp F8Cp_mp F8Cp_mp F8Cp_mp F8Cp_mp F8Cp_mp
ax_ind_coil = 1;
model_name='F8Cp_mp_RMG';

filename=fullfile(model_name,[model_name,'_compiled_result.mat']);
load(filename,'compiled_results');

XX_all = compiled_results.XX;
YY_all = compiled_results.YY;
th_CE = compiled_results.th_CE;
th_MCE = compiled_results.th_MCE;
th_per_diff = compiled_results.th_per_diff_MCE;
R_coil = compiled_results.R_coil;
th_CE(isnan(th_CE)) = 1e5;
th_per_diff(isnan(th_per_diff)) = -100;

%-------------------------------------------------------------------------
ax_ind_type = 1;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_CE )),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_CE ),10.^([ceil(amp_log_min)+1,ceil(amp_log_min)+1]));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);

ind_Y = find(YY_all(1,:)>=-1.75);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_CE(:,ind_Y) ),10.^([ceil(amp_log_min)+2,ceil(amp_log_min)+2]));
set(h_contour,contour_line);
ind_Y = find(YY_all(1,:)<=-1.75);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_CE(:,ind_Y) ),10.^([ceil(amp_log_min)+2,ceil(amp_log_min)+2]));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 2;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_MCE )),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_MCE ),10.^([ceil(amp_log_min)+1,ceil(amp_log_min)+1]));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);

ind_Y = find(YY_all(1,:)>=-1.75);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_MCE(:,ind_Y) ),10.^([ceil(amp_log_min)+2,ceil(amp_log_min)+2]));
set(h_contour,contour_line);
ind_Y = find(YY_all(1,:)<=-1.75);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_MCE(:,ind_Y) ),10.^([ceil(amp_log_min)+2,ceil(amp_log_min)+2]));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 3;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,th_per_diff,color_level_per_neg,'LineStyle','none');

ind_Y = find(YY_all(1,:)>=-2);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[1,1]*-10);
set(h_contour,contour_line);
ind_Y = find(YY_all(1,:)<=-2);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[1,1]*-10);
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);

plot(x_lim,[1,1]*YY_all(y_plot_ind),'k:','LineWidth',1.5);
patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% F8Cp_hs F8Cp_hs F8Cp_hs F8Cp_hs F8Cp_hs F8Cp_hs F8Cp_hs F8Cp_hs F8Cp_hs F
ax_ind_coil = 2;
model_name='F8Cp_hs_RMG';

filename=fullfile(model_name,[model_name,'_compiled_result.mat']);
load(filename,'compiled_results');

XX_all = compiled_results.XX;
YY_all = compiled_results.YY;
th_CE = compiled_results.th_CE;
th_MCE = compiled_results.th_MCE;
th_per_diff = compiled_results.th_per_diff_MCE;
R_coil = compiled_results.R_coil;

th_CE(isnan(th_CE)) = 1e5;
th_per_diff(isnan(th_per_diff)) = -100;

%-------------------------------------------------------------------------
ax_ind_type = 1;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_CE )),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_CE ),10.^([ceil(amp_log_min)+1,ceil(amp_log_min)+1]));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);

ind_Y = find(YY_all(1,:)>=-1.75);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_CE(:,ind_Y) ),10.^([ceil(amp_log_min)+2,ceil(amp_log_min)+2]));
set(h_contour,contour_line);
ind_Y = find(YY_all(1,:)<=-1.75);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_CE(:,ind_Y) ),10.^([ceil(amp_log_min)+2,ceil(amp_log_min)+2]));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 2;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_MCE )),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_MCE ),10.^([ceil(amp_log_min)+1,ceil(amp_log_min)+1]));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);

ind_Y = find(YY_all(1,:)>=-1.75);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_MCE(:,ind_Y) ),10.^([ceil(amp_log_min)+2,ceil(amp_log_min)+2]));
set(h_contour,contour_line);
ind_Y = find(YY_all(1,:)<=-1.75);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),abs(th_MCE(:,ind_Y) ),10.^([ceil(amp_log_min)+2,ceil(amp_log_min)+2]));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 3;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,th_per_diff,color_level_per_neg,'LineStyle','none');

ind_Y = find(YY_all(1,:)>=-2);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[1,1]*-10);
set(h_contour,contour_line);
ind_Y = find(YY_all(1,:)<=-2);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[1,1]*-10);
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',150);

plot(x_lim,[1,1]*YY_all(y_plot_ind),'k:','LineWidth',1.5);
patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%%

frame = getframe(h_f);
im_3 = frame2im(frame);
im_3 = im_3(round( (1 - ( y_begin(1) + y_length(1) + y_gap/2) * y_unit ) * figure_length_y) +1:round( (1 - ( y_begin(2) - y_gap*3/2) * y_unit ) * figure_length_y),:,:);
close(h_f)
