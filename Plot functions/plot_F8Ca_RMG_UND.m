coil_title = 'Figure-8 coil - aligned';
x_length = [8];
x_lim = [-0.53,7.53];  %cm

h_f1 = figure(format_figure);
h_f2 = figure(format_figure);

set_axes_6x1;


model_name=['F8Ca_',wvf ,'_RMG'];
filename=fullfile(model_name,[model_name,'_compiled_result.mat']);
load(filename,'compiled_results');

XX_all = compiled_results.XX;
YY_all = compiled_results.YY;
th_CE = compiled_results.th_CE;
R_coil = compiled_results.R_coil;
N_coil = compiled_results.N_coil;

ax_ind_coil = 1;
ind_x_neg = find(XX_all(:,1) <= abs(x_lim(1))) ;

%% F8Ca UA F8Ca UA F8Ca UA F8Ca UA F8Ca UA F8Ca UA F8Ca UA F8Ca UA F8Ca UA F8Ca UA F8Ca UA F8Ca UA
suffix = '_UA';
th_UND = compiled_results.(['th',suffix]);
th_per_diff = ( th_UND ./ compiled_results.th_CE - 1) * 100;

%--------------------------------------------------------------------------
ax_ind_type = 1;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,log10(abs(th_UND )),color_level_amp,'LineStyle','none');
contourf(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),log10(abs(th_UND(ind_x_neg,:) )),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_UND ),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);
[~,h_contour]=contour(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),abs(th_UND(ind_x_neg,:) ),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);


ax_ind_type = 4;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,th_per_diff,color_level_per_full,'LineStyle','none');
contourf(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),th_per_diff(ind_x_neg,:),color_level_per_full,'LineStyle','none');
%%

ind_Y = find(YY_all(1,:)>=-2.25);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[60,60]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',300);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[40,40]);
set(h_contour,contour_line,'LineStyle','--');
ind_Y = find(YY_all(1,:)>=-2.75);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[20,20]);
set(h_contour,contour_line,'LineStyle','--');

ind_Y = find(YY_all(1,:)<=-2.25);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[60,60]);
set(h_contour,contour_line,'LineStyle','--');
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',300);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[40,40]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',300);
ind_Y = find(YY_all(1,:)<=-2.75);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[20,20]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',300);

[C,h_contour]=contour(XX_all,YY_all,th_per_diff,[-20,-20]);
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',10,'Interpreter','latex','LabelSpacing',300);
[~,h_contour]=contour(XX_all,YY_all,th_per_diff,[-40,-40]);
set(h_contour,contour_line);

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% F8Ca UF F8Ca UF F8Ca UF F8Ca UF F8Ca UF F8Ca UF F8Ca UF F8Ca UF F8Ca UF F8Ca UF F8Ca UF F8Ca UF
suffix = '_UF';
th_UND = compiled_results.(['th',suffix]);
th_per_diff = ( th_UND ./ compiled_results.th_CE - 1) * 100;

%--------------------------------------------------------------------------
ax_ind_type = 2;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,log10(abs(th_UND )),color_level_amp,'LineStyle','none');
contourf(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),log10(abs(th_UND(ind_x_neg,:) )),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_UND ),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);
[~,h_contour]=contour(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),abs(th_UND(ind_x_neg,:) ),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

ax_ind_type = 5;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,th_per_diff,color_level_per_full,'LineStyle','none');
contourf(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),th_per_diff(ind_x_neg,:),color_level_per_full,'LineStyle','none');
%%

ind_X = find(XX_all(:,1)<=1.75);
[C,h_contour]=contour(XX_all(ind_X,:),YY_all(ind_X,:),th_per_diff(ind_X,:),[20,20]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',300);
ind_X = find(XX_all(:,1)>=1.75);
ind_Y = find(YY_all(1,:)>=-2.25);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[20,20]);
set(h_contour,contour_line,'LineStyle','--');
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
ind_Y = find(YY_all(1,:)<=-2.25);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[20,20]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',10,'Interpreter','latex','LabelSpacing',300);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
clabel(C,h_contour,'FontSize',10,'Interpreter','latex','LabelSpacing',300);

ind_Y = find(YY_all(1,:)>=-2.25);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[-20,-40]);
set(h_contour,contour_line);
ind_Y = find(YY_all(1,:)<=-2.25);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[-40,-40]);
set(h_contour,contour_line);
ind_X = find(XX_all(:,1)<=3);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[-20,-20]);
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',10,'Interpreter','latex','LabelSpacing',300);
ind_X = find(XX_all(:,1)>=3);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[-20,-20]);
set(h_contour,contour_line);

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%% F8Ca UAF F8Ca UAF F8Ca UAF F8Ca UAF F8Ca UAF F8Ca UAF F8Ca UAF F8Ca UAF F8Ca UAF F8Ca UAF F8Ca UAF F8Ca UAF
suffix = '_UAF';
th_UND = compiled_results.(['th',suffix]);
th_per_diff = ( th_UND ./ compiled_results.th_CE - 1) * 100;

%--------------------------------------------------------------------------
ax_ind_type = 3;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,log10(abs(th_UND )),color_level_amp,'LineStyle','none');
contourf(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),log10(abs(th_UND(ind_x_neg,:) )),color_level_amp,'LineStyle','none');

[C,h_contour]=contour(XX_all,YY_all,abs(th_UND ),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',13,'Interpreter','latex','LabelSpacing',350);
[~,h_contour]=contour(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),abs(th_UND(ind_x_neg,:) ),10.^(round(amp_log_min):round(amp_log_max)));
set(h_contour,contour_line);

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);


ax_ind_type = 6;
axes(h_ax(ax_ind_type,ax_ind_coil));

contourf(XX_all,YY_all,th_per_diff,color_level_per_full,'LineStyle','none');
contourf(-XX_all(ind_x_neg,:),YY_all(ind_x_neg,:),th_per_diff(ind_x_neg,:),color_level_per_full,'LineStyle','none');
%% --------------------------------------------------------------------------

ind_Y = find(YY_all(1,:)>=-2.5);
[~,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
ind_Y = find(YY_all(1,:)<=-2.5);
[C,h_contour]=contour(XX_all(:,ind_Y),YY_all(:,ind_Y),th_per_diff(:,ind_Y),[0,0]);
set(h_contour,contour_line,'LineWidth',2.5);
clabel(C,h_contour,'FontSize',10,'Interpreter','latex','LabelSpacing',300);

ind_X = find(XX_all(:,1)>=3);
ind_Y = find(YY_all(1,:)>=-2.25);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[20,20]);
set(h_contour,contour_line,'LineStyle','--');
ind_Y = find(YY_all(1,:)>=-2);
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',300);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[40,40]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',300);
ind_X = find(XX_all(:,1)>=4);
ind_Y = find(YY_all(1,:)<=-2.25);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[20,20]);
set(h_contour,contour_line,'LineStyle','--');
ind_Y = find(YY_all(1,:)<=-2);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[40,40]);
set(h_contour,contour_line,'LineStyle','--');

ind_X = find(XX_all(:,1)<=3.5 & XX_all(:,1)>=2.25);
[~,h_contour]=contour(XX_all(ind_X,:),YY_all(ind_X,:),th_per_diff(ind_X,:),[60,60]);
set(h_contour,contour_line,'LineStyle','--');
ind_X = find(XX_all(:,1)>=3.5);
[C,h_contour]=contour(XX_all(ind_X,:),YY_all(ind_X,:),th_per_diff(ind_X,:),[60,60]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',300);

ind_X = find(XX_all(:,1)<=2.25);
ind_Y = find(YY_all(2,:)>=-2.5);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[60,60]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',300);
[~,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[20,40]);
set(h_contour,contour_line,'LineStyle','--');

ind_X = find(XX_all(:,1)<=2.5);
ind_Y = find(YY_all(1,:)<=-2.5);
[C,h_contour]=contour(XX_all(ind_X,ind_Y),YY_all(ind_X,ind_Y),th_per_diff(ind_X,ind_Y),[20,40]);
set(h_contour,contour_line,'LineStyle','--');
clabel(C,h_contour,'FontSize',11,'Interpreter','latex','LabelSpacing',300);

[C,h_contour]=contour(XX_all,YY_all,th_per_diff,[-20,-20]);
set(h_contour,contour_line);
clabel(C,h_contour,'FontSize',10,'Interpreter','latex','LabelSpacing',300);

patch(R_coil*(x_coil_norm + 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);
patch(R_coil*(x_coil_norm - 1),YY_all(y_coil_ind)*y_coil_norm,c_coil,format_coil);

%%
frame = getframe(h_f1);
im_2u = frame2im(frame);
im_2u = im_2u(:,1:round( (x_begin(1) + x_length(1)+x_gap/2) * x_unit * figure_length_x),:);
close(h_f1);

frame = getframe(h_f2);
im_2d = frame2im(frame);
im_2d = im_2d(:,1:round( (x_begin(1) + x_length(1)+x_gap/2) * x_unit * figure_length_x),:);
close(h_f2);
