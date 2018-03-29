coil_title = 'Figure-8 coil - perpendicular';
x_length = [10];
x_lim = [-5.03,5.03];   %cm

h_f1 = figure(format_figure);
h_f2 = figure(format_figure);

set_axes_6x1;

model_name=['F8Cp_',wvf ,'_RMG'];
filename=fullfile(model_name,[model_name,'_compiled_result.mat']);
load(filename,'compiled_results');

XX_all = compiled_results.XX;
YY_all = compiled_results.YY;
th_CE = compiled_results.th_CE;
R_coil = compiled_results.R_coil;
N_coil = compiled_results.N_coil;

ax_ind_coil = 1;

%% F8Cp UA F8Cp UA F8Cp UA F8Cp UA F8Cp UA F8Cp UA F8Cp UA F8Cp UA F8Cp UA F8Cp UA
suffix = '_UA';
th_UND = compiled_results.(['th',suffix]);
th_per_diff = ( th_UND ./ compiled_results.th_CE - 1) * 100;

th_per_diff(isnan(th_per_diff)) = -100;
%--------------------------------------------------------------------------
ax_ind_type = 1;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,log10(abs(th_UND )),color_level_amp,'LineStyle','none');


[C,h_contour]=contour(XX_all,YY_all,abs(th_UND ),10.^([ceil(amp_log_min):floor(amp_log_max)]));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
ax_ind_type = 4;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,th_per_diff,color_level_per_full,'LineStyle','none');
%% --------------------------------------------------------------------------
ind_Y = find(YY_all(1,:)>=-1.75);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[60,60]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',200);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[40,40]);
set(h_contour,contour_line,'LineStyle','--');
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);

ind_Y = find(YY_all(1,:)>=-2.25);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[-40,-40]);
set(h_contour,contour_line);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[20,20]);
set(h_contour,contour_line,'LineStyle','--');

ind_Y = find(YY_all(1,:)<=-1.75);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[60,60]);
set(h_contour,contour_line,'LineStyle','--');
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[40,40]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',200);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',200);

ind_Y = find(YY_all(1,:)<=-2.25);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[-40,-40]);
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',200);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[20,20]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',200);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% F8Cp UF F8Cp UF F8Cp UF F8Cp UF F8Cp UF F8Cp UF F8Cp UF F8Cp UF F8Cp UF F8Cp UF
suffix = '_UF';
th_UND = compiled_results.(['th',suffix]);
th_per_diff = ( th_UND ./ compiled_results.th_CE - 1) * 100;

th_per_diff(isnan(th_per_diff)) = -100;
%--------------------------------------------------------------------------
ax_ind_type = 2;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,log10(abs(th_UND )),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_UND ),10.^([ceil(amp_log_min):floor(amp_log_max)]));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
ax_ind_type = 5;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,th_per_diff,color_level_per_full,'LineStyle','none');
%% --------------------------------------------------------------------------
ind_X = find(abs(XX_all(:,1))<=1.75);
ind_Y = find(YY_all(1,:)>=-1.75);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[-40,-40]);
set(h_contour,contour_line);

ind_Y = find(YY_all(1,:)<=-1.75);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',200);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[-40,-40]);
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',200);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% F8Cp UAF F8Cp UAF F8Cp UAF F8Cp UAF F8Cp UAF F8Cp UAF F8Cp UAF F8Cp UAF F8Cp UAF F8Cp UAF
suffix = '_UAF';
th_UND = compiled_results.(['th',suffix]);
th_per_diff = ( th_UND ./ compiled_results.th_CE - 1) * 100;

th_per_diff(isnan(th_per_diff)) = -100;
%--------------------------------------------------------------------------
ax_ind_type = 3;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,log10(abs(th_UND )),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_UND ),10.^([ceil(amp_log_min):floor(amp_log_max)]));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
ax_ind_type = 6;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,th_per_diff,color_level_per_full,'LineStyle','none');
%% --------------------------------------------------------------------------

ind_Y = find(YY_all(1,:)>=-2);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[-40,-40]);
set(h_contour,contour_line);
ind_Y = find(YY_all(1,:)>=-1.5);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[20,20]);
set(h_contour,contour_line,'LineStyle','--');

ind_Y = find(YY_all(1,:)<=-1.5);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[20,20]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',200);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',200);

ind_Y = find(YY_all(1,:)<=-2);
ind_X = find(XX_all(:,1)<=0); 
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[-40,40]);
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',200);
ind_X = find(XX_all(:,1)>=0); 
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[-40,40]);
set(h_contour,contour_line);

patch(R_coil*x_coil_norm,YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%%
frame = getframe(h_f1);
im_3u = frame2im(frame);
im_3u = im_3u(:,1:round( (x_begin(1) + x_length(1)+x_gap/2) * x_unit * figure_length_x),:);
close(h_f1);

frame = getframe(h_f2);
im_3d = frame2im(frame);
im_3d = im_3d(:,1:round( (x_begin(1) + x_length(1)+x_gap/2) * x_unit * figure_length_x),:);
close(h_f2);
