coil_title = 'Figure-8 coil - aligned';
x_lim = [-2.53,7.53];   %cm

h_f = figure(format_figure);
set_axes_2x3;

%% F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_mp
ax_ind_coil = 1;

model_name='F8Ca_mp_RMG';

filename=fullfile(model_name,[model_name,'_compiled_result.mat']);
load(filename,'compiled_results');

XX_all = compiled_results.XX;
YY_all = compiled_results.YY;
th_CE = compiled_results.th_CE;
th_MCE = compiled_results.th_MCE;
th_per_diff = compiled_results.th_per_diff_MCE;
R_coil = compiled_results.R_coil;

ind_x_neg = find(XX_all(:,1) <= abs(x_lim(1))) ;

%-------------------------------------------------------------------------
ax_ind_type = 1;
axes(h_ax(ax_ind_coil,ax_ind_type));
contourf(XX_all,YY_all,log10(abs(th_CE)),color_level_amp,'LineStyle','none');
contourf(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),log10(abs(th_CE(ind_x_neg,:))),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_CE),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);
[~,h_contour]=contour(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),abs(th_CE(ind_x_neg,:) ),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 2;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_MCE)),color_level_amp,'LineStyle','none');
contourf(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),log10(abs(th_MCE(ind_x_neg,:))),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_MCE),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);
[~,h_contour]=contour(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),abs(th_MCE(ind_x_neg,:)),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 3;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,th_per_diff,color_level_per_neg,'LineStyle','none');

plot(x_lim,[1,1]*YY_all(y_plot_ind),'k:','LineWidth',1.5);

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);


%% F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs F8Ca_hs
ax_ind_coil = 2;
model_name='F8Ca_hs_RMG';

filename=fullfile(model_name,[model_name,'_compiled_result.mat']);
load(filename,'compiled_results');

XX_all = compiled_results.XX;
YY_all = compiled_results.YY;
th_CE = compiled_results.th_CE;
th_MCE = compiled_results.th_MCE;
th_per_diff = compiled_results.th_per_diff_MCE;
R_coil = compiled_results.R_coil;

%-------------------------------------------------------------------------
ax_ind_type = 1;
axes(h_ax(ax_ind_coil,ax_ind_type));
contourf(XX_all,YY_all,log10(abs(th_CE)),color_level_amp,'LineStyle','none');
contourf(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),log10(abs(th_CE(ind_x_neg,:))),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_CE),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);
[~,h_contour]=contour(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),abs(th_CE(ind_x_neg,:)),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 2;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,log10(abs(th_MCE )),color_level_amp,'LineStyle','none');
contourf(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),log10(abs(th_MCE(ind_x_neg,:))),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_MCE),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);
[~,h_contour]=contour(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),abs(th_MCE(ind_x_neg,:)),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%--------------------------------------------------------------------------
ax_ind_type = 3;
axes(h_ax(ax_ind_coil,ax_ind_type));

contourf(XX_all,YY_all,th_per_diff,color_level_per_neg,'LineStyle','none');

plot(x_lim,[1,1]*YY_all(y_plot_ind),'k:','LineWidth',1.5);

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%%
frame = getframe(h_f);
im_2 = frame2im(frame);
im_2 = im_2(round( (1 - ( y_begin(1) + y_length(1) + y_gap/2) * y_unit ) * figure_length_y) +1:round( (1 - ( y_begin(2) - y_gap*3/2) * y_unit ) * figure_length_y),:,:);
close(h_f);
